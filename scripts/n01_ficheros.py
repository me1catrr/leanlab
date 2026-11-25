"""Genera los ficheros BrainVision SINTÉTICOS de N01 y su resultado analítico.

Uso: uv run --project python python scripts/n01_ficheros.py

Escribe en verification/N01/ficheros/ (no versionado; se regenera) los tríos
.vhdr/.vmrk/.eeg descritos en verification/N01/protocolo.yml, y en
verification/N01/esperado/ el resultado analítico de cada uno, calculado con
fracciones exactas. Determinista: sin aleatoriedad. Ningún fichero contiene
datos de personas.
"""

from __future__ import annotations

import json
import struct
from fractions import Fraction
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
DIR_F = RAIZ / "verification" / "N01" / "ficheros"
DIR_E = RAIZ / "verification" / "N01" / "esperado"

CABECERA = """Brain Vision Data Exchange Header File Version 1.0
; Fichero sintético de LEANLAB (N01). No contiene datos de ninguna persona.

[Common Infos]
Codepage=UTF-8
DataFile={nombre}.eeg
MarkerFile={nombre}.vmrk
DataFormat=BINARY
DataOrientation={orientacion}
NumberOfChannels={C}
DataPoints={N}
SamplingInterval={intervalo}

[Binary Infos]
BinaryFormat={formato}

[Channel Infos]
{canales}
"""

MARCADORES = """Brain Vision Data Exchange Marker File, Version 1.0

[Common Infos]
Codepage=UTF-8
DataFile={nombre}.eeg

[Marker Infos]
Mk1=New Segment,,1,1,0
"""


def escribir(nombre, *, C, N, formato, orientacion="MULTIPLEXED", resol=None,
             unidad="µV", intervalo=2000, crudo=None, recorte=0):
    """crudo[n][c]: valor crudo de la muestra n (base 0) del canal c (base 0)."""
    resol = resol or [1.0] * C
    canales = "\n".join(f"Ch{c + 1}=C{c + 1},,{resol[c]:g},{unidad}" for c in range(C))
    (DIR_F / f"{nombre}.vhdr").write_text(
        CABECERA.format(nombre=nombre, orientacion=orientacion, C=C, N=N,
                        intervalo=intervalo, formato=formato, canales=canales),
        encoding="utf-8")
    (DIR_F / f"{nombre}.vmrk").write_text(MARCADORES.format(nombre=nombre), encoding="utf-8")

    fmt = "<f" if formato == "IEEE_FLOAT_32" else "<h"   # little-endian
    if orientacion == "MULTIPLEXED":
        orden = [(n, c) for n in range(N) for c in range(C)]
    else:  # VECTORIZED: un canal entero tras otro
        orden = [(n, c) for c in range(C) for n in range(N)]
    datos = b"".join(struct.pack(fmt, crudo[n][c]) for n, c in orden)
    if recorte:
        datos = datos[:-recorte]
    (DIR_F / f"{nombre}.eeg").write_bytes(datos)
    return resol


def esperado(nombre, *, C, N, resol, crudo, unidad="µV", intervalo=2000,
             rechazo=None, n_completas=None):
    """Resultado analítico (exacto) en µV, canales × muestras."""
    fs = Fraction(10**6, intervalo)
    doc = {"fichero": nombre, "C": C, "fs_Hz": float(fs), "fs_exacta": f"{fs.numerator}/{fs.denominator}"}
    if rechazo:
        doc["rechazo_julia"] = rechazo
    n_ok = N if n_completas is None else n_completas
    factor = {"µV": Fraction(1), "uV": Fraction(1), "mV": Fraction(1000)}[unidad]
    datos = [[float(Fraction(crudo[n][c]) * Fraction(str(resol[c])) * factor) for n in range(n_ok)]
             for c in range(C)]
    doc.update({"N": n_ok, "unidad_salida": "µV", "datos_uV": datos})
    (DIR_E / f"{nombre}.json").write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


def main() -> None:
    DIR_F.mkdir(parents=True, exist_ok=True)
    DIR_E.mkdir(parents=True, exist_ok=True)

    # f1 · Float32, valores 1..12 en el orden del archivo (exactos en binario).
    C, N = 3, 4
    crudo = [[n * C + c + 1 for c in range(C)] for n in range(N)]
    r = escribir("f1_float32", C=C, N=N, formato="IEEE_FLOAT_32", crudo=crudo)
    esperado("f1_float32", C=C, N=N, resol=r, crudo=crudo)

    # f2 · Int16 con resolución distinta por canal (0.1 no es exacto en binario).
    crudo2 = [[(-1) ** (n * C + c) * 10 * (n * C + c + 1) for c in range(C)] for n in range(N)]
    r = escribir("f2_int16", C=C, N=N, formato="INT_16", resol=[0.1, 0.5, 1.0], crudo=crudo2)
    esperado("f2_int16", C=C, N=N, resol=r, crudo=crudo2)

    # f3 · Truncado: faltan 6 bytes (la última muestra queda incompleta).
    r = escribir("f3_truncado", C=C, N=N, formato="IEEE_FLOAT_32", crudo=crudo, recorte=6)
    esperado("f3_truncado", C=C, N=N, resol=r, crudo=crudo, n_completas=3)

    # f4 · VECTORIZED: el lector Julia debe rechazarlo por contrato.
    r = escribir("f4_vectorizado", C=C, N=N, formato="IEEE_FLOAT_32", orientacion="VECTORIZED", crudo=crudo)
    esperado("f4_vectorizado", C=C, N=N, resol=r, crudo=crudo, rechazo="orientación VECTORIZED")

    # f5 · Unidad mV: el lector Julia debe rechazarla por contrato.
    r = escribir("f5_milivoltios", C=C, N=N, formato="IEEE_FLOAT_32", unidad="mV", crudo=crudo)
    esperado("f5_milivoltios", C=C, N=N, resol=r, crudo=crudo, unidad="mV", rechazo="unidad mV")

    # f6 · SamplingInterval = 3 µs → fs = 333333,33… Hz (no entera).
    C6, N6 = 2, 5
    crudo6 = [[n * C6 + c + 1 for c in range(C6)] for n in range(N6)]
    r = escribir("f6_fs_no_entera", C=C6, N=N6, formato="INT_16", intervalo=3, crudo=crudo6)
    esperado("f6_fs_no_entera", C=C6, N=N6, resol=r, crudo=crudo6, intervalo=3)

    print(f"Ficheros en {DIR_F.relative_to(RAIZ)}; esperados en {DIR_E.relative_to(RAIZ)}")


if __name__ == "__main__":
    main()
