"""CROSS de N02 · control de calidad: Julia, NumPy/SciPy, MNE y oráculo exacto.

Uso: uv run --project python python scripts/n02_cross.py

Aplica verification/N02/protocolo.yml (versión 1): métricas con rtol = 1e-12,
atol = 0; etiquetas por igualdad exacta. Escribe verification/N02/cross.json.
"""

from __future__ import annotations

import json
import logging
import warnings
from pathlib import Path

import mne
import numpy as np
import scipy
from scipy import stats

RAIZ = Path(__file__).resolve().parents[1]
DIR = RAIZ / "verification" / "N02"
RTOL, ATOL = 1e-12, 0.0
CONJUNTOS = ["d1_mixto", "d2_ocho_canales", "d3_once_canales", "d4_identicos", "d5_plano_parcial"]


def leer(nombre: str) -> tuple[np.ndarray, float]:
    meta = dict(l.split("=", 1) for l in (DIR / "datos" / f"{nombre}.meta").read_text(encoding="utf-8").split())
    C, N = int(meta["C"]), int(meta["N"])
    X = np.fromfile(DIR / "datos" / f"{nombre}.f64", dtype="<f8").reshape(C, N)   # canal tras canal
    return X, float(meta["fs"])


def qc_numpy(X: np.ndarray) -> dict:
    """Implementación independiente del contrato N02 con NumPy/SciPy."""
    C = X.shape[0]
    etiquetas = [[] for _ in range(C)]
    validos = np.all(np.isfinite(X), axis=1)
    rango = np.where(validos, np.ptp(np.where(validos[:, None], X, 0), axis=1), np.nan)
    sigma = np.where(validos, np.std(np.where(validos[:, None], X, 0), axis=1, ddof=0), np.nan)
    frac = np.where(validos, np.mean(np.abs(np.where(validos[:, None], X, 0)) >= 1000.0, axis=1), np.nan)
    for c in range(C):
        if not validos[c]:
            etiquetas[c].append("no_valido")
            continue
        if rango[c] < 1.0:
            etiquetas[c].append("plano")
        if frac[c] >= 0.01:
            etiquetas[c].append("saturado")
    en_z = [c for c in range(C) if validos[c] and "plano" not in etiquetas[c]]
    z = np.full(C, np.nan)
    with np.errstate(invalid="ignore", divide="ignore"):
        z_sc = stats.zscore(sigma[en_z], ddof=0) if en_z else np.array([])
    for i, c in enumerate(en_z):
        z[c] = z_sc[i]
        if np.isfinite(z_sc[i]) and abs(z_sc[i]) > 3.0:
            etiquetas[c].append("atipico")
    return {"etiquetas": etiquetas, "sigma": sigma, "rango": rango, "frac_sat": frac, "z": z,
            "z_scipy_crudo": z_sc}


def planos_mne(X: np.ndarray, fs: float) -> list[int]:
    """Canales planos según MNE (diferencias consecutivas, por tramos)."""
    validos = np.all(np.isfinite(X), axis=1)
    info = mne.create_info([f"C{c}" for c in range(X.shape[0])], fs, "eeg")
    raw = mne.io.RawArray(np.where(validos[:, None], X, 0.0) * 1e-6, info, verbose="ERROR")
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        _, bads = mne.preprocessing.annotate_amplitude(raw, flat=1e-6, bad_percent=5, min_duration=0.002,
                                                       verbose="ERROR")
    return sorted(int(b[1:]) for b in bads if validos[int(b[1:])])


def iguales(a, b) -> bool:
    a, b = np.asarray(a, float), np.asarray(b, float)
    return bool(np.array_equal(np.isnan(a), np.isnan(b)) and
                np.allclose(a[~np.isnan(a)], b[~np.isnan(b)], rtol=RTOL, atol=ATOL))


def comparar(nombre: str) -> dict:
    X, fs = leer(nombre)
    jl = json.loads((DIR / "julia" / f"{nombre}.json").read_text(encoding="utf-8"))
    esp = json.loads((DIR / "esperado" / f"{nombre}.json").read_text(encoding="utf-8"))
    py = qc_numpy(X)
    jl_num = {k: np.array([np.nan if v is None else v for v in jl[k]]) for k in ("sigma", "rango", "frac_sat", "z")}
    planos_contrato = [c for c, e in enumerate(esp["etiquetas"]) if "plano" in e]
    planos_m = planos_mne(X, fs)
    r = {
        "conjunto": nombre,
        "etiquetas_oraculo": esp["etiquetas"],
        "julia_igual_oraculo": [sorted(e) for e in jl["etiquetas"]] == [sorted(e) for e in esp["etiquetas"]],
        "numpy_igual_oraculo": [sorted(e) for e in py["etiquetas"]] == [sorted(e) for e in esp["etiquetas"]],
        "metricas_julia_vs_numpy": {k: iguales(jl_num[k], py[k]) for k in jl_num},
        "max_dif_z": float(np.nanmax(np.abs(jl_num["z"] - py["z"]))) if np.isfinite(jl_num["z"]).any() else None,
        "planos_contrato": planos_contrato,
        "planos_mne": planos_m,
        "z_scipy_tiene_nan": bool(np.isnan(py["z_scipy_crudo"]).any()),
    }
    discrepancias = []
    if not (r["julia_igual_oraculo"] and r["numpy_igual_oraculo"] and all(r["metricas_julia_vs_numpy"].values())):
        discrepancias.append({"tipo": "pendiente", "detalle": "Julia, NumPy u oráculo no coinciden"})
    if planos_m != planos_contrato:
        discrepancias.append({"tipo": "diferencia_metodologica",
                              "detalle": "MNE marca como plano un canal plano solo por tramos; el contrato mira el registro completo"})
    if r["z_scipy_tiene_nan"]:
        discrepancias.append({"tipo": "diferencia_metodologica",
                              "detalle": "scipy.stats.zscore devuelve NaN si la dispersión es 0; el contrato define «ningún atípico»"})
    r["discrepancias"] = discrepancias
    r["clasificacion"] = "sin_discrepancia" if not discrepancias else \
        ("pendiente" if any(d["tipo"] == "pendiente" for d in discrepancias) else "diferencia_metodologica")
    return r


def main() -> None:
    informe = {"protocolo": "verification/N02/protocolo.yml (versión 1)", "mne": mne.__version__,
               "numpy": np.__version__, "scipy": scipy.__version__, "tolerancia": {"rtol": RTOL, "atol": ATOL},
               "resultados": [comparar(c) for c in CONJUNTOS]}
    (DIR / "cross.json").write_text(json.dumps(informe, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    for r in informe["resultados"]:
        print(f"{r['conjunto']:18s} julia=oráculo:{r['julia_igual_oraculo']} numpy=oráculo:{r['numpy_igual_oraculo']} "
              f"métricas:{all(r['metricas_julia_vs_numpy'].values())} planos contrato/MNE: {r['planos_contrato']}/{r['planos_mne']} → {r['clasificacion']}")


if __name__ == "__main__":
    main()
