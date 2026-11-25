"""CROSS de N01 · compara lector Julia, MNE-Python y resultado analítico.

Uso: uv run --project python python scripts/n01_cross.py

Aplica el protocolo verification/N01/protocolo.yml (versión 1, fijado antes de
comparar): tolerancia rtol = 1e-12, atol = 0; MNE devuelve voltios y se
compara con x_V = 1e-6 · x_µV. Escribe verification/N01/cross_mne.json con, por
fichero: forma, frecuencia, error máximo absoluto y relativo, RMSE, residuo
máximo y la clasificación de cada discrepancia.
"""

from __future__ import annotations

import json
import logging
import warnings
from pathlib import Path

import mne
import numpy as np

RAIZ = Path(__file__).resolve().parents[1]
DIR = RAIZ / "verification" / "N01"
RTOL, ATOL = 1e-12, 0.0
FICHEROS = ["f1_float32", "f2_int16", "f3_truncado", "f4_vectorizado", "f5_milivoltios", "f6_fs_no_entera"]


def leer_json(sub: str, nombre: str) -> dict:
    return json.loads((DIR / sub / f"{nombre}.json").read_text(encoding="utf-8"))


def leer_mne(nombre: str) -> dict:
    """Lee con MNE y registra cualquier aviso (warnings o logging)."""
    capturados: list[str] = []

    class Captura(logging.Handler):
        def emit(self, rec):
            if rec.levelno >= logging.WARNING:
                capturados.append(rec.getMessage())

    manejador = Captura()
    logging.getLogger("mne").addHandler(manejador)
    try:
        with warnings.catch_warnings(record=True) as w:
            warnings.simplefilter("always")
            raw = mne.io.read_raw_brainvision(DIR / "ficheros" / f"{nombre}.vhdr", preload=True, verbose="WARNING")
        capturados += [str(x.message) for x in w]
        return {"estado": "leido", "datos_V": raw.get_data(), "fs_Hz": raw.info["sfreq"], "avisos": capturados}
    except Exception as e:  # registrar, no ocultar
        return {"estado": "error", "motivo": f"{type(e).__name__}: {e}", "avisos": capturados}
    finally:
        logging.getLogger("mne").removeHandler(manejador)


def metricas(a: np.ndarray, b: np.ndarray) -> dict:
    """Errores de a frente a b (misma forma)."""
    d = a - b
    rel = np.abs(d) / np.where(b != 0, np.abs(b), 1.0)
    return {
        "error_max_abs": float(np.max(np.abs(d))),
        "error_max_rel": float(np.max(rel)),
        "rmse": float(np.sqrt(np.mean(d**2))),
        "dentro_tolerancia": bool(np.allclose(a, b, rtol=RTOL, atol=ATOL)),
    }


def comparar(nombre: str) -> dict:
    esp = leer_json("esperado", nombre)
    jl = leer_json("julia", nombre)
    mn = leer_mne(nombre)
    analitico_V = np.array(esp["datos_uV"]) * 1e-6
    r = {"fichero": nombre, "julia": jl["estado"], "mne": mn["estado"],
         "avisos_julia": jl.get("avisos", []), "avisos_mne": mn["avisos"]}

    if mn["estado"] == "leido":
        r["mne_vs_analitico"] = metricas(mn["datos_V"], analitico_V) if mn["datos_V"].shape == analitico_V.shape \
            else {"forma_mne": list(mn["datos_V"].shape), "forma_analitica": list(analitico_V.shape)}
        r["fs_mne"] = mn["fs_Hz"]
    if jl["estado"] == "leido":
        julia_V = np.array(jl["datos_uV"]) * 1e-6
        r["julia_vs_analitico"] = metricas(julia_V, analitico_V)
        r["fs_julia"] = jl["fs_Hz"]
        if mn["estado"] == "leido" and mn["datos_V"].shape == julia_V.shape:
            r["julia_vs_mne"] = metricas(julia_V, mn["datos_V"])
            r["julia_vs_mne"]["residuo_max_V"] = r["julia_vs_mne"].pop("error_max_abs")
            r["fs_iguales"] = bool(np.isclose(jl["fs_Hz"], mn["fs_Hz"], rtol=RTOL, atol=0))
            r["identicos_bit_a_bit"] = bool(np.array_equal(julia_V, mn["datos_V"]))
    else:
        r["motivo_julia"] = jl["motivo"]

    # Clasificación según el protocolo.
    if jl["estado"] == "leido" and mn["estado"] == "leido":
        ok = r.get("julia_vs_mne", {}).get("dentro_tolerancia") and r.get("fs_iguales")
        if not ok:
            r["clasificacion"] = "pendiente"
        elif r["avisos_julia"] and not r["avisos_mne"]:
            r["clasificacion"] = "diferencia_metodologica"
            r["nota"] = "mismos datos; Julia avisa del truncamiento y MNE no emite ningún aviso"
        elif r.get("identicos_bit_a_bit"):
            r["clasificacion"] = "sin_discrepancia"
        else:
            r["clasificacion"] = "precision"
            r["nota"] = "diferencias de redondeo dentro de la tolerancia (orden de las operaciones en Float64)"
    elif jl["estado"] == "rechazado" and mn["estado"] == "leido":
        r["clasificacion"] = "diferencia_metodologica"
        r["nota"] = "el contrato de LEANLAB rechaza el fichero; MNE lo admite"
    else:
        r["clasificacion"] = "pendiente"
    return r


def main() -> None:
    informe = {
        "protocolo": "verification/N01/protocolo.yml (versión 1)",
        "mne": mne.__version__, "numpy": np.__version__,
        "tolerancia": {"rtol": RTOL, "atol": ATOL},
        "resultados": [comparar(f) for f in FICHEROS],
    }
    (DIR / "cross_mne.json").write_text(json.dumps(informe, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    for r in informe["resultados"]:
        extra = r.get("julia_vs_mne", {})
        print(f"{r['fichero']:18s} julia={r['julia']:10s} mne={r['mne']:7s} → {r['clasificacion']}"
              + (f"  (residuo máx {extra.get('residuo_max_V'):.3g} V, bit a bit: {r.get('identicos_bit_a_bit')})" if extra else ""))


if __name__ == "__main__":
    main()
