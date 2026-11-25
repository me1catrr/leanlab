"""Extrae fragmentos de código marcados para incluirlos en el libro.

Uso: python scripts/fragmento_codigo.py SALIDA.md LENGUAJE FICHERO:NOMBRE [FICHERO:NOMBRE ...]

En el fichero fuente, un fragmento se delimita con comentarios:
    # FRAGMENTO: nombre
    ...código...
    # FIN: nombre
Así el libro muestra exactamente el código que se ejecuta en TEST, CROSS y BENCH.
"""

import sys
import textwrap
from pathlib import Path


def extraer(fichero: Path, nombre: str) -> str:
    lineas = fichero.read_text(encoding="utf-8").splitlines()
    ini = f"# FRAGMENTO: {nombre}"
    fin = f"# FIN: {nombre}"
    try:
        a = next(i for i, l in enumerate(lineas) if l.strip() == ini)
        b = next(i for i, l in enumerate(lineas) if l.strip() == fin)
    except StopIteration:
        sys.exit(f"no se encuentra el fragmento '{nombre}' en {fichero}")
    return textwrap.dedent("\n".join(lineas[a + 1 : b])).strip("\n")


def main() -> None:
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    salida, lenguaje, specs = Path(sys.argv[1]), sys.argv[2], sys.argv[3:]
    bloques = ["<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->"]
    for spec in specs:
        fichero, nombre = spec.rsplit(":", 1)
        codigo = extraer(Path(fichero), nombre)
        bloques.append(f'```{{.{lenguaje} filename="{fichero}"}}\n{codigo}\n```')
    salida.parent.mkdir(parents=True, exist_ok=True)
    salida.write_text("\n\n".join(bloques) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
