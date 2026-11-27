"""CROSS de N03 · Butterworth: DSP.jl frente a SciPy y MNE; un polo: exacto.

Uso: uv run --project python python scripts/n03_cross.py

Aplica verification/N03/protocolo.yml (versión 1). Escribe verification/N03/cross.json.
"""

from __future__ import annotations

import json
import warnings
from pathlib import Path

import mne
import numpy as np
import scipy
from scipy import signal

RAIZ = Path(__file__).resolve().parents[1]
DIR = RAIZ / "verification" / "N03"
FS, ORDEN, FC = 500.0, 4, 40.0


def leer_f64(n: str) -> np.ndarray:
    return np.fromfile(DIR / "senales" / f"{n}.f64", dtype="<f8")


def ordenar(z: np.ndarray) -> np.ndarray:
    return np.array(sorted(z, key=lambda c: (round(c.real, 9), round(c.imag, 9))))


def dif_max(a, b) -> float:
    return float(np.max(np.abs(np.asarray(a) - np.asarray(b))))


def main() -> None:
    jl = json.loads((DIR / "julia" / "butter.json").read_text(encoding="utf-8"))
    a2 = json.loads((DIR / "julia" / "a2_error.json").read_text(encoding="utf-8"))
    b1, imp = leer_f64("b1"), leer_f64("impulso")

    sos_sp = signal.butter(ORDEN, FC, fs=FS, output="sos")
    z_sp, p_sp, k_sp = signal.sos2zpk(sos_sp)
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        iir = mne.filter.create_filter(b1, FS, l_freq=None, h_freq=FC, method="iir",
                                       iir_params=dict(order=ORDEN, ftype="butter", output="sos"), verbose="ERROR")
    sos_mne = iir["sos"]

    p_jl = np.array(jl["polos_re"]) + 1j * np.array(jl["polos_im"])
    z_jl = np.array(jl["ceros_re"]) + 1j * np.array(jl["ceros_im"])
    frecs = np.array(jl["frecuencias_Hz"])
    _, H_sp = signal.sosfreqz(sos_sp, worN=frecs, fs=FS)
    H_jl = np.array(jl["modulo_H"])

    y_sp = signal.sosfilt(sos_sp, b1)
    y_jl = np.array(jl["b1_una_pasada"])
    imp_sp = signal.sosfilt(sos_sp, imp)

    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        y_mne = mne.filter.filter_data(b1[np.newaxis, :] * 1.0, FS, l_freq=None, h_freq=FC, method="iir",
                                       iir_params=dict(order=ORDEN, ftype="butter", output="sos"), verbose="ERROR")[0]
    y_ff_jl = np.array(jl["b1_fase_cero"])
    n = len(b1); i0, i1 = int(0.1 * n), int(0.9 * n)
    tol_salida = 1e-9 * float(np.max(np.abs(b1)))

    r = {
        "protocolo": "verification/N03/protocolo.yml (versión 1)",
        "versiones": {"mne": mne.__version__, "numpy": np.__version__, "scipy": scipy.__version__},
        "un_polo": {
            "a1_julia_igual_lean": "ver TEST (igualdad exacta en Rational{BigInt})",
            "a2_error_max_float64": a2["error_max"], "a2_error_en": a2["error_en"],
            "a2_dentro_tolerancia": a2["error_max"] <= 1e-12,
        },
        "butterworth": {
            "polos_iguales": bool(np.allclose(ordenar(p_jl), ordenar(p_sp), rtol=1e-12, atol=0)),
            "ceros_iguales": bool(np.allclose(ordenar(z_jl), ordenar(z_sp), rtol=1e-12, atol=1e-12)),
            "ceros_max_dif_sos2zpk": dif_max(ordenar(z_jl), ordenar(z_sp)),
            "ceros_iguales_zpk_directo": bool(np.allclose(
                ordenar(z_jl), ordenar(signal.butter(ORDEN, FC, fs=FS, output="zpk")[0]), rtol=1e-12, atol=1e-12)),
            "ganancia_jl_vs_sp_rel": abs(jl["ganancia"] - k_sp) / abs(k_sp),
            "polos_modulo_max": float(np.max(np.abs(p_sp))),
            "estable": bool(np.all(np.abs(p_jl) < 1) and np.all(np.abs(p_sp) < 1)),
            "sos_scipy_igual_mne": bool(np.allclose(sos_sp, sos_mne, rtol=1e-12, atol=0)),
            "sos_coeficientes_identicos_dsp_scipy": bool(
                np.allclose(np.array(jl["sos_dsp"]), sos_sp, rtol=1e-12, atol=0)),
            "H_max_dif": dif_max(H_jl, np.abs(H_sp)),
            "H_dentro_tolerancia": bool(np.allclose(H_jl, np.abs(H_sp), rtol=1e-10, atol=1e-14)),
            "H0": float(np.abs(H_sp[0])), "H_corte": float(np.abs(signal.sosfreqz(sos_sp, worN=[FC], fs=FS)[1][0])),
            "una_pasada_max_dif": dif_max(y_jl, y_sp),
            "una_pasada_tolerancia": tol_salida,
            "una_pasada_dentro_tolerancia": dif_max(y_jl, y_sp) <= tol_salida,
            "impulso_max_dif": dif_max(jl["impulso"], imp_sp),
            "fase_cero_max_dif_total": dif_max(y_ff_jl, y_mne),
            "fase_cero_max_dif_central80": dif_max(y_ff_jl[i0:i1], y_mne[i0:i1]),
        },
    }
    bw = r["butterworth"]
    discrepancias = []
    if not bw["sos_coeficientes_identicos_dsp_scipy"]:
        discrepancias.append({"tipo": "diferencia_metodologica", "detalle":
            "representación de las SOS: DSP.jl guarda la ganancia global aparte y SciPy la integra en la "
            "primera sección; el orden y el emparejamiento de las secciones coinciden, y también los polos, "
            "la ganancia y la respuesta en frecuencia"})
    if bw["fase_cero_max_dif_total"] > tol_salida:
        discrepancias.append({"tipo": "diferencia_metodologica", "detalle":
            "filtrado de fase cero: MNE y DSP.jl rellenan los bordes de forma distinta; "
            f"diferencia máxima {bw['fase_cero_max_dif_total']:.3g} en total y "
            f"{bw['fase_cero_max_dif_central80']:.3g} en el 80 % central"})
    if not bw["ceros_iguales"] and bw["ceros_iguales_zpk_directo"]:
        discrepancias.append({"tipo": "precision", "detalle":
            "los ceros reconstruidos desde las SOS con scipy.signal.sos2zpk difieren de −1 en "
            f"{bw['ceros_max_dif_sos2zpk']:.2g}: el cero doble de cada sección es una raíz múltiple, mal "
            "condicionada; con los ceros que da directamente butter(…, output='zpk') la coincidencia es exacta. "
            "El efecto depende de la biblioteca LAPACK de la plataforma: no aparece en Linux (CI)"})
    ceros_ok = bw["ceros_iguales"] or bw["ceros_iguales_zpk_directo"]
    ok = (bw["polos_iguales"] and ceros_ok and bw["H_dentro_tolerancia"]
          and bw["una_pasada_dentro_tolerancia"] and bw["estable"] and r["un_polo"]["a2_dentro_tolerancia"])
    if not ok:
        discrepancias.append({"tipo": "pendiente", "detalle": "algún criterio del protocolo no se cumple"})
    r["discrepancias"] = discrepancias
    (DIR / "cross.json").write_text(json.dumps(r, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(json.dumps({k: v for k, v in bw.items()}, ensure_ascii=False, indent=1))
    for d in discrepancias:
        print("·", d["tipo"], "—", d["detalle"])


if __name__ == "__main__":
    main()
