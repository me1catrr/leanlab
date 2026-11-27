"""Genera las señales sintéticas de N03 (deterministas).

Uso: uv run --project python python scripts/n03_senales.py

Escribe en verification/N03/senales/ (no versionado; se regenera):
  a1_entrada.txt, a2_entrada.txt   filtro de un polo: α, y₀ y x en racionales «p/q»
  b1.f64, impulso.f64              Butterworth: Float64 little-endian
Las mismas entradas exactas las leen Lean (a1), Julia y Python.
"""

from __future__ import annotations

import math
import struct
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
DIR = RAIZ / "verification" / "N03" / "senales"


def main() -> None:
    DIR.mkdir(parents=True, exist_ok=True)

    # a1 · α = 1/4, y₀ = 0, doce enteros fijos.
    x1 = [4, -8, 12, 0, 5, -3, 7, 7, -10, 2, 0, 1]
    (DIR / "a1_entrada.txt").write_text("1/4\n0\n" + "".join(f"{v}\n" for v in x1), encoding="utf-8")

    # a2 · α = 1/10, y₀ = 0, N = 2000 milésimas deterministas en [−1, 1].
    x2 = [((k * 7919) % 2001) - 1000 for k in range(2000)]
    (DIR / "a2_entrada.txt").write_text("1/10\n0\n" + "".join(f"{v}/1000\n" for v in x2), encoding="utf-8")

    # b1 · suma de senoides a 10, 60 y 120 Hz, fs = 500 Hz, N = 2000.
    fs, N = 500.0, 2000
    b1 = [math.sin(2 * math.pi * 10 * n / fs) + 0.5 * math.sin(2 * math.pi * 60 * n / fs)
          + 0.2 * math.sin(2 * math.pi * 120 * n / fs) for n in range(N)]
    (DIR / "b1.f64").write_bytes(struct.pack(f"<{N}d", *b1))

    # impulso · delta de Kronecker, N = 400.
    imp = [1.0] + [0.0] * 399
    (DIR / "impulso.f64").write_bytes(struct.pack(f"<{len(imp)}d", *imp))
    print(f"Señales en {DIR.relative_to(RAIZ)}")


if __name__ == "__main__":
    main()
