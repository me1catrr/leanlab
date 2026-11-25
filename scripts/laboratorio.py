"""Laboratorio de código de LEANLAB: componentes generados desde las evidencias.

Uso (desde la raíz):  uv run --project python python scripts/laboratorio.py

Regenera todos los fragmentos del libro a partir de las fuentes únicas de
evidencia. Ningún número de estos componentes se escribe a mano:

* Ficha de evidencia   ← verification/<ID>.yml
* Tabla CROSS          ← verification/N01/cross_mne.json
* Gráfico BENCH (SVG)  ← verification/<cap>/bench_julia.json
* Datos binario→matriz ← verification/F01/oraculo_lean/tabla_4x{2,3,4}.json

Los fragmentos son HTML estático (sin JavaScript), salvo el componente
interactivo binario→matriz, que usa assets/js/binario-matriz.js.
"""

from __future__ import annotations

import hashlib
import html
import json
import math
from pathlib import Path

import yaml

RAIZ = Path(__file__).resolve().parents[1]
BOOK = RAIZ / "book"
CABECERA = "<!-- Generado por scripts/laboratorio.py desde {fuente}. No editar a mano. -->"

ESTADOS = {"PROPOSED", "ILLUSTRATIVE", "REPORTED", "INSPECTED", "REPRODUCED", "FAILED"}
ACEPTACION = {"pendiente", "requiere revisión", "aceptada", "rechazada"}
PILARES = [("PROOF", "p-proof"), ("TEST", "p-test"), ("CROSS", "p-cross"), ("BENCH", "p-bench")]


def esc(x) -> str:
    return html.escape(str(x))


def insignia(estado: str) -> str:
    clase = "estado hecho" if estado == "REPRODUCED" else ("estado fallo" if estado == "FAILED" else "estado")
    return f'<span class="{clase}">{esc(estado)}</span>'


def sha16(ruta: Path) -> str:
    return hashlib.sha256(ruta.read_bytes()).hexdigest()[:16]


def escribir(ruta: Path, fuente: str, cuerpo: str) -> None:
    ruta.parent.mkdir(parents=True, exist_ok=True)
    ruta.write_text("\n".join([CABECERA.format(fuente=fuente), "```{=html}", cuerpo, "```", ""]), encoding="utf-8")


# --- Ficha de evidencia ---------------------------------------------------
def ficha(yml: Path, salida: Path) -> None:
    d = yaml.safe_load(yml.read_text(encoding="utf-8"))
    ev = d["evidencias"]
    for pilar, _ in PILARES:
        assert ev[pilar]["estado"] in ESTADOS, f"{yml}: estado no válido en {pilar}"
    assert d["estado_ejecucion"] in ESTADOS and d["aceptacion_cientifica"] in ACEPTACION
    corr = d["correspondencia_formal_implementacion"]
    filas = "".join(
        f'<tr><th scope="row"><span class="pilar-etq {clase}">{p}</span></th>'
        f'<td>{insignia(ev[p]["estado"])}</td><td>{esc(ev[p].get("resumen", ""))}</td></tr>'
        for p, clase in PILARES
    )
    filas += (f'<tr><th scope="row">Correspondencia Lean ↔ código</th><td>{insignia(corr["estado"])}</td>'
              f'<td>{esc(" ".join(corr["descripcion"].split())[:220])}…</td></tr>')
    filas += (f'<tr><th scope="row">Aceptación científica</th>'
              f'<td><span class="estado">{esc(d["aceptacion_cientifica"])}</span></td>'
              f'<td>Dimensión independiente del estado de ejecución; requiere revisión humana.</td></tr>')
    limites = "".join(f"<li>{esc(l)}</li>" for l in d.get("limitaciones", []))
    cuerpo = f"""<figure class="ficha-evidencia" aria-label="Ficha de evidencia {esc(d['id'])}">
<header><span class="ficha-id">{esc(d['id'])}</span> · {esc(d['titulo'])}</header>
<div class="tabla-desplazable"><table>
<thead><tr><th scope="col">Pilar</th><th scope="col">Estado</th><th scope="col">Evidencia</th></tr></thead>
<tbody>{filas}</tbody></table></div>
<details><summary>Limitaciones declaradas</summary><ul>{limites}</ul></details>
<figcaption>Generada desde <code>{esc(yml.relative_to(RAIZ))}</code> (SHA-256 {sha16(yml)}…).</figcaption>
</figure>"""
    escribir(salida, yml.relative_to(RAIZ), cuerpo)


# --- Tabla CROSS ----------------------------------------------------------
CLASES = {"sin_discrepancia": "Sin discrepancia", "diferencia_metodologica": "Diferencia metodológica",
          "precision": "Precisión", "error": "Error", "referencia_no_comparable": "Referencia no comparable",
          "pendiente": "Pendiente"}


def cross(fuente: Path, salida: Path) -> None:
    d = json.loads(fuente.read_text(encoding="utf-8"))
    filas = []
    for r in d["resultados"]:
        if "julia_vs_mne" in r:
            jm = r["julia_vs_mne"]
            res = f'residuo máx. {jm["residuo_max_V"]:.3g} V · RMSE {jm["rmse"]:.3g} V'
            res += " · idénticos bit a bit" if r.get("identicos_bit_a_bit") else ""
        elif "mne_vs_analitico" in r and "error_max_abs" in r["mne_vs_analitico"]:
            ma = r["mne_vs_analitico"]
            res = f'MNE frente al analítico: error máx. {ma["error_max_abs"]:.3g} V'
        else:
            res = "—"
        avisos = []
        if r["avisos_julia"]:
            avisos.append(f'Julia: {len(r["avisos_julia"])} aviso(s)')
        if r["mne"] == "leido":
            avisos.append("MNE: " + (f'{len(r["avisos_mne"])} aviso(s)' if r["avisos_mne"] else "sin avisos"))
        jl = "rechaza" if r["julia"] == "rechazado" else "lee"
        clase = "estado hecho" if r["clasificacion"] == "sin_discrepancia" else "estado"
        filas.append(
            f'<tr><th scope="row"><code>{esc(r["fichero"])}</code></th><td>{jl}</td>'
            f'<td>{"lee" if r["mne"] == "leido" else esc(r["mne"])}</td>'
            f'<td>{esc(res)}<br><small>{esc(" · ".join(avisos))}</small></td>'
            f'<td><span class="{clase}">{esc(CLASES[r["clasificacion"]])}</span></td></tr>')
    tol = d["tolerancia"]
    cuerpo = f"""<figure class="cross-studio" aria-label="Comparación cruzada">
<div class="tabla-desplazable"><table>
<thead><tr><th scope="col">Fichero</th><th scope="col">Julia</th><th scope="col">MNE</th><th scope="col">Resultado</th><th scope="col">Clasificación</th></tr></thead>
<tbody>{''.join(filas)}</tbody></table></div>
<figcaption>Generada desde <code>{esc(fuente.relative_to(RAIZ))}</code> (SHA-256 {sha16(fuente)}…). MNE {esc(d['mne'])}, NumPy {esc(d['numpy'])}; tolerancia rtol = {tol['rtol']:g}, atol = {tol['atol']:g}, fijada en el protocolo antes de comparar.</figcaption>
</figure>"""
    escribir(salida, fuente.relative_to(RAIZ), cuerpo)


# --- Gráfico BENCH --------------------------------------------------------
def formato_t(ns: float) -> str:
    if ns < 1e3:
        return f"{ns:.0f} ns"
    if ns < 1e6:
        return f"{ns / 1e3:.0f} µs"
    return f"{ns / 1e6:.2f} ms"


def formato_mem(b: float) -> str:
    return f"{b:.0f} B" if b < 1024 else (f"{b / 2**10:.1f} KiB" if b < 2**20 else f"{b / 2**20:.1f} MiB")


def bench(fuente: Path, salida: Path, titulo: str, log: bool) -> None:
    d = json.loads(fuente.read_text(encoding="utf-8"))
    casos = sorted(d["resultados"].items())
    ent = d["entorno"]
    ancho, izq, alto_fila, sup = 640, 250, 34, 10
    vmax = max(v["q75_ns"] for _, v in casos)
    vmin = min(v["mediana_ns"] for _, v in casos)

    if log:
        lo, hi = 10 ** math.floor(math.log10(vmin)), 10 ** math.ceil(math.log10(vmax))
        x = lambda v: izq + (ancho - izq - 20) * (math.log10(max(v, lo)) - math.log10(lo)) / (math.log10(hi) - math.log10(lo))
        marcas = [10 ** e for e in range(int(math.log10(lo)), int(math.log10(hi)) + 1)]
    else:
        lo, hi = 0.0, vmax * 1.1
        x = lambda v: izq + (ancho - izq - 20) * v / hi
        paso = 10 ** math.floor(math.log10(hi / 4))
        marcas = [paso * k for k in range(0, int(hi / paso) + 1, max(1, int(hi / paso) // 4))]

    alto = sup + alto_fila * len(casos) + 34
    partes = [f'<svg viewBox="0 0 {ancho} {alto}" role="img" aria-labelledby="t-{salida.stem} d-{salida.stem}" class="bench-svg">',
              f'<title id="t-{salida.stem}">{esc(titulo)}</title>',
              f'<desc id="d-{salida.stem}">Mediana de cada caso con su rango intercuartílico. '
              f'{"Escala logarítmica." if log else "Escala lineal."} Valores en la tabla siguiente.</desc>']
    for m in marcas:
        partes.append(f'<line x1="{x(m):.1f}" x2="{x(m):.1f}" y1="{sup}" y2="{alto - 30}" class="eje-rejilla"/>'
                      f'<text x="{x(m):.1f}" y="{alto - 14}" class="eje-txt" text-anchor="middle">{formato_t(m)}</text>')
    for i, (nombre, v) in enumerate(casos):
        y = sup + i * alto_fila + 6
        partes.append(f'<text x="{izq - 8}" y="{y + 14}" class="caso-txt" text-anchor="end">{esc(nombre)}</text>')
        partes.append(f'<rect x="{izq}" y="{y + 4}" width="{max(x(v["mediana_ns"]) - izq, 1.5):.1f}" height="16" class="barra"/>')
        partes.append(f'<line x1="{x(v["q25_ns"]):.1f}" x2="{x(v["q75_ns"]):.1f}" y1="{y + 12}" y2="{y + 12}" class="iqr"/>')
        partes.append(f'<text x="{min(x(v["q75_ns"]) + 6, ancho - 4):.1f}" y="{y + 16}" class="valor-txt">{formato_t(v["mediana_ns"])}</text>')
    partes.append("</svg>")

    filas = "".join(
        f'<tr><th scope="row">{esc(n)}</th><td>{formato_t(v["mediana_ns"])}</td>'
        f'<td>{formato_t(v["q25_ns"])} – {formato_t(v["q75_ns"])}</td><td>{formato_mem(v["memoria_bytes"])}</td>'
        f'<td>{v["asignaciones"]}</td><td>{v["muestras"]}</td></tr>' for n, v in casos)
    cuerpo = f"""<figure class="bench-studio" aria-label="{esc(titulo)}">
{''.join(partes)}
<div class="tabla-desplazable"><table>
<thead><tr><th scope="col">Caso</th><th scope="col">Mediana</th><th scope="col">Q1 – Q3</th><th scope="col">Memoria</th><th scope="col">Asignaciones</th><th scope="col">Muestras</th></tr></thead>
<tbody>{filas}</tbody></table></div>
<figcaption>{esc(titulo)}. {esc(ent['datos'])}. {esc(ent['cpu'])}, Julia {esc(ent['julia'])}, {ent['hilos_julia']} hilo(s), BenchmarkTools {esc(ent['benchmarktools'])}, {esc(ent['fecha'][:10])}. Una sola máquina: no generalizable. Generado desde <code>{esc(fuente.relative_to(RAIZ))}</code> (SHA-256 {sha16(fuente)}…).</figcaption>
</figure>"""
    escribir(salida, fuente.relative_to(RAIZ), cuerpo)


# --- Datos del componente binario → matriz --------------------------------
def datos_binario(salida: Path) -> None:
    tablas, procedencia = {}, {}
    for C in (2, 3, 4):
        f = RAIZ / "verification" / "F01" / "oraculo_lean" / f"tabla_4x{C}.json"
        tablas[str(C)] = json.loads(f.read_text())
        procedencia[str(C)] = {"fuente": str(f.relative_to(RAIZ)), "sha256": hashlib.sha256(f.read_bytes()).hexdigest()}
    doc = {"N": 4, "tablas_multiplexed": tablas, "procedencia": procedencia,
           "nota": "Tablas (n, c, idx) en base cero producidas por el oráculo Lean (lake exe f01_tabla 4 C)."}
    salida.parent.mkdir(parents=True, exist_ok=True)
    salida.write_text(json.dumps(doc, ensure_ascii=False) + "\n", encoding="utf-8")


def main() -> None:
    v = RAIZ / "verification"
    ficha(v / "F01-P01.yml", BOOK / "fundamentos" / "_f01-ficha.md")
    ficha(v / "N01-P01.yml", BOOK / "aplicaciones" / "_n01-ficha.md")
    cross(v / "N01" / "cross_mne.json", BOOK / "aplicaciones" / "_n01-cross.md")
    bench(v / "F01" / "bench_julia.json", BOOK / "fundamentos" / "_f01-bench.md",
          "F01 · construir la matriz canales × muestras (31 × 100 000, Float32)", log=True)
    bench(v / "N01" / "bench_julia.json", BOOK / "aplicaciones" / "_n01-bench.md",
          "N01 · etapas del lector BrainVision (31 × 500 000, INT_16)", log=False)
    datos_binario(BOOK / "assets" / "datos" / "binario-matriz.json")
    print("Componentes del Laboratorio regenerados.")


if __name__ == "__main__":
    main()
