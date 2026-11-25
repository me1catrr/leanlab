"""Visor estático de demostraciones Lean a partir de la extracción de SubVerso.

Uso (desde la raíz del repositorio):
    uv run --project python python scripts/visor_lean.py \
        verification/F01/subverso/Indice.json book/fundamentos/_f01-visor.md \
        LeanlabBook.F01.idx_lt LeanlabBook.F01.idx_inj ...

Lee el JSON que produce `subverso-extract-mod` (código resaltado y estados de
prueba reales, calculados por Lean al elaborar el módulo) y escribe un
fragmento Markdown con HTML estático: el código de cada declaración, con las
tácticas numeradas, y debajo los estados de prueba que SubVerso asocia a cada
táctica. No usa JavaScript: cada estado es un <details> desplegable.

Ningún estado se escribe a mano: todo procede del JSON de SubVerso.
"""

from __future__ import annotations

import hashlib
import html
import json
import sys
from pathlib import Path


class Extraccion:
    def __init__(self, ruta: Path):
        crudo = ruta.read_bytes()
        self.sha256 = hashlib.sha256(crudo).hexdigest()
        doc = json.loads(crudo)
        self.items = doc["items"]
        datos = doc["data"]
        self.code = datos["code"]
        self.tokens = datos["tokens"]
        self.goals = datos["goals"]

    # --- texto plano -------------------------------------------------------
    def texto(self, cid: int) -> str:
        nodo = self.code[str(cid)]
        tipo, val = next(iter(nodo.items()))
        if tipo == "token":
            return self.tokens[str(val["tok"])]["content"]
        if tipo == "text":
            return val["str"]
        if tipo == "seq":
            return "".join(self.texto(h) for h in val["highlights"])
        if tipo == "tactics":
            return self.texto(val["content"])
        if tipo in ("span", "point"):
            return self.texto(val.get("content", val.get("highlight", 0)))
        raise ValueError(f"nodo desconocido: {tipo}")

    # --- HTML resaltado ----------------------------------------------------
    def clase_token(self, tok: dict) -> str:
        kind = tok["kind"]
        if not isinstance(kind, dict):
            return "lk-" + str(kind)
        return "lk-" + next(iter(kind))

    def html(self, cid: int, tacticas: list | None) -> str:
        nodo = self.code[str(cid)]
        tipo, val = next(iter(nodo.items()))
        if tipo == "token":
            tok = self.tokens[str(val["tok"])]
            return f'<span class="{self.clase_token(tok)}">{html.escape(tok["content"])}</span>'
        if tipo == "text":
            return html.escape(val["str"])
        if tipo == "seq":
            return "".join(self.html(h, tacticas) for h in val["highlights"])
        if tipo == "tactics":
            interior = self.html(val["content"], tacticas)
            if tacticas is None or not val["info"]:
                return interior
            tacticas.append(val)
            num = len(tacticas)
            return f'<span class="lean-tac" id="t{num}">{interior}<sup class="lean-tac-n">{num}</sup></span>'
        if tipo in ("span", "point"):
            return self.html(val.get("content", val.get("highlight", 0)), tacticas)
        raise ValueError(f"nodo desconocido: {tipo}")

    def estado(self, gid: int) -> str:
        g = self.goals[str(gid)]
        lineas = []
        for h in g["hypotheses"]:
            # Los nombres de las hipótesis apuntan a la tabla de tokens.
            nombres = " ".join(self.tokens[str(n)]["content"] for n in h["names"])
            lineas.append(f"{html.escape(nombres)} : {html.escape(self.texto(h['typeAndVal']))}")
        lineas.append(f'{html.escape(g.get("goalPrefix") or "⊢ ")}{html.escape(self.texto(g["conclusion"]))}')
        return "\n".join(lineas)

    def declaracion(self, nombre: str) -> dict:
        for it in self.items:
            if nombre in it["defines"]:
                return it
        raise KeyError(nombre)


def generar(json_ruta: Path, salida: Path, nombres: list[str]) -> None:
    ex = Extraccion(json_ruta)
    partes = [
        "<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->",
        "```{=html}",
        '<div class="lean-visor">',
    ]
    for nombre in nombres:
        it = ex.declaracion(nombre)
        tacticas: list = []
        codigo = ex.html(it["code"], tacticas).strip("\n")
        corto = nombre.split(".")[-1]
        partes.append(f'<section class="lean-decl" id="visor-{html.escape(corto)}">')
        partes.append(f'<pre class="lean-codigo"><code>{codigo}</code></pre>')
        if tacticas:
            partes.append('<ol class="lean-estados">')
            for i, t in enumerate(tacticas, start=1):
                tac_txt = " ".join(ex.texto(t["content"]).split())
                if len(tac_txt) > 70:
                    tac_txt = tac_txt[:67] + "…"
                estados = "\n\n".join(ex.estado(g) for g in t["info"])
                partes.append(
                    f'<li value="{i}"><details><summary><code>{html.escape(tac_txt)}</code></summary>'
                    f'<pre class="lean-estado">{estados}</pre></details></li>'
                )
            partes.append("</ol>")
        partes.append("</section>")
    partes.append(
        f'<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real '
        f'del módulo · SHA-256 del JSON: <code>{ex.sha256[:16]}…</code></p>'
    )
    partes += ["</div>", "```", ""]
    salida.parent.mkdir(parents=True, exist_ok=True)
    salida.write_text("\n".join(partes), encoding="utf-8")


if __name__ == "__main__":
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    generar(Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3:])
