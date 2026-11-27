"""Genera las matrices sintéticas de N02 y su oráculo exacto de etiquetas.

Uso: uv run --project python python scripts/n02_datos.py

Cada canal es una onda cuadrada ±A (media 0, desviación típica poblacional
exactamente A, rango 2A), una constante o una onda con un NaN. Así el oráculo
decide cada etiqueta con fracciones exactas (para el z-score compara z² con 9).

Escribe en verification/N02/datos/ (no versionado; se regenera) cada matriz
como Float64 little-endian, por filas de canal (canal 0 completo, canal 1…),
con un .meta de texto, y en verification/N02/esperado/ las etiquetas exactas.
"""

from __future__ import annotations

import json
import struct
from decimal import Decimal, getcontext
from fractions import Fraction
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
DIR_D = RAIZ / "verification" / "N02" / "datos"
DIR_E = RAIZ / "verification" / "N02" / "esperado"
N = 1000
PLANO, LIM_SAT, FRAC_SAT, UMBRAL_Z = Fraction(1), Fraction(1000), Fraction(1, 100), 3


def cuadrada(A) -> list:
    return [A if n % 2 == 0 else -A for n in range(N)]


def escribir(nombre: str, canales: list[list]) -> None:
    C = len(canales)
    with open(DIR_D / f"{nombre}.f64", "wb") as f:
        for ch in canales:
            f.write(struct.pack(f"<{N}d", *[float(v) for v in ch]))
    (DIR_D / f"{nombre}.meta").write_text(f"C={C}\nN={N}\nfs=500\nunidad=µV\norden=canal\n", encoding="utf-8")


def oraculo(nombre: str, canales: list[list]) -> None:
    """Etiquetas exactas según el contrato N02 (fracciones; NaN como None)."""
    etiquetas, sigma = [], {}
    for c, ch in enumerate(canales):
        e = []
        if any(v is None for v in ch):
            etiquetas.append(["no_valido"])
            continue
        vals = [Fraction(v) for v in ch]
        if max(vals) - min(vals) < PLANO:
            e.append("plano")
        if Fraction(sum(1 for v in vals if abs(v) >= LIM_SAT), N) >= FRAC_SAT:
            e.append("saturado")
        m = sum(vals) / N
        var = sum((v - m) ** 2 for v in vals) / N
        etiquetas.append(e)
        if "plano" not in e:
            sigma[c] = var  # se guarda σ²; las ondas cuadradas tienen σ racional
    # z-score poblacional de σ sobre los canales válidos y no planos.
    # σ_c = √var_c con var_c exacta; la raíz se calcula con 80 dígitos decimales
    # y la decisión exige un margen amplio frente al umbral (nunca Float64).
    getcontext().prec = 80
    s = {c: (Decimal(v.numerator) / Decimal(v.denominator)).sqrt() for c, v in sigma.items()}
    n = len(s)
    z2 = {}
    if n > 0:
        media = sum(s.values()) / n
        var_s = sum((v - media) ** 2 for v in s.values()) / n
        for c, v in s.items():
            if var_s == 0 or abs(var_s) < Decimal("1e-60"):
                z2[c] = None
                continue
            z2[c] = (v - media) ** 2 / var_s
            assert abs(z2[c] - UMBRAL_Z ** 2) > Decimal("1e-30"), f"{nombre}: z² demasiado cerca del umbral"
            if z2[c] > UMBRAL_Z ** 2:
                etiquetas[c].append("atipico")
    doc = {"conjunto": nombre, "C": len(canales), "N": N, "etiquetas": etiquetas,
           "z2_80_digitos": {str(c): (None if v is None else str(v)) for c, v in z2.items()},
           "z_float": {str(c): (None if v is None else float(v.sqrt())) for c, v in z2.items()},
           "n_canales_z": n}
    (DIR_E / f"{nombre}.json").write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    # Copia en texto plano para lectores sin JSON (Julia): «canal: etiqueta,etiqueta».
    (DIR_E / f"{nombre}.etiquetas.txt").write_text(
        "".join(f"{c}: {','.join(e)}\n" for c, e in enumerate(etiquetas)), encoding="utf-8")


def generar(nombre: str, canales: list[list]) -> None:
    escribir(nombre, [[float("nan") if v is None else v for v in ch] for ch in canales])
    oraculo(nombre, canales)


def main() -> None:
    DIR_D.mkdir(parents=True, exist_ok=True)
    DIR_E.mkdir(parents=True, exist_ok=True)

    # d1 · mixto: plano (2), saturado (5), no válido (9), canal grande (12).
    d1 = [cuadrada(20 + c) for c in range(16)]
    d1[2] = [3] * N
    d1[5] = cuadrada(1000)
    d1[9] = cuadrada(29)
    d1[9][500] = None
    d1[12] = cuadrada(400)
    generar("d1_mixto", d1)

    # d2 · ocho canales, uno 45 veces mayor: Samuelson impide |z| > 3.
    d2 = [cuadrada(20 + c) for c in range(7)] + [cuadrada(900)]
    generar("d2_ocho_canales", d2)

    # d3 · once canales: diez iguales y uno un 2,5 % mayor → z = √10 > 3.
    d3 = [cuadrada(20) for _ in range(10)] + [cuadrada(Fraction(41, 2))]
    generar("d3_once_canales", d3)

    # d4 · doce canales idénticos: la desviación de las σ es 0.
    d4 = [cuadrada(20) for _ in range(12)]
    generar("d4_identicos", d4)

    # d5 · canal 0 plano la primera mitad y ±50 la segunda.
    d5 = [cuadrada(20 + c) for c in range(12)]
    d5[0] = [0] * (N // 2) + [50 if n % 2 == 0 else -50 for n in range(N // 2)]
    generar("d5_plano_parcial", d5)

    print(f"Datos en {DIR_D.relative_to(RAIZ)}; esperados en {DIR_E.relative_to(RAIZ)}")


if __name__ == "__main__":
    main()
