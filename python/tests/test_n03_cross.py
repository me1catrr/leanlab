"""CROSS de N03 · `uv run --project python pytest python/tests`.

Requiere las señales (scripts/n03_senales.py), los resultados de Julia
(julia/scripts/n03_exportar.jl) y el informe verification/N03/cross.json
(scripts/n03_cross.py). Comprueba los criterios del protocolo, versión 1.
"""

import json
from pathlib import Path

import numpy as np
import pytest
from scipy import signal

RAIZ = Path(__file__).resolve().parents[2]
DIR = RAIZ / "verification" / "N03"


@pytest.fixture(scope="module")
def informe():
    return json.loads((DIR / "cross.json").read_text(encoding="utf-8"))


def test_un_polo_float64_frente_a_exacto(informe):
    assert informe["un_polo"]["a2_dentro_tolerancia"]


def test_butterworth_coincide(informe):
    bw = informe["butterworth"]
    assert bw["polos_iguales"] and bw["estable"]
    assert bw["ceros_iguales_zpk_directo"]          # los ceros directos coinciden exactamente
    assert bw["H_dentro_tolerancia"] and bw["una_pasada_dentro_tolerancia"]
    assert bw["sos_scipy_igual_mne"]
    assert abs(bw["H0"] - 1) < 1e-10 and abs(bw["H_corte"] - 2 ** -0.5) < 1e-10


def test_discrepancias_clasificadas(informe):
    tipos = sorted(d["tipo"] for d in informe["discrepancias"])
    assert "pendiente" not in tipos
    assert tipos == ["diferencia_metodologica", "diferencia_metodologica", "precision"]


def test_raiz_doble_mal_condicionada():
    """Fenómeno de precisión aislado: la raíz doble de 1 + 2z + z² recuperada
    numéricamente se aleja de −1 en ~√ε, aunque los coeficientes sean exactos."""
    sos = signal.butter(4, 40, fs=500, output="sos")
    z, _, _ = signal.sos2zpk(sos)
    err = np.max(np.abs(z + 1))
    assert 1e-10 < err < 1e-6
