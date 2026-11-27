"""CROSS de N02 · `uv run --project python pytest python/tests`.

Requiere los datos (scripts/n02_datos.py) y los resultados de Julia
(julia/scripts/n02_exportar.jl). Comprueba las expectativas del protocolo
verification/N02/protocolo.yml (versión 1).
"""

import importlib.util
import warnings
from pathlib import Path

import pytest

RAIZ = Path(__file__).resolve().parents[2]
_spec = importlib.util.spec_from_file_location("n02_cross", RAIZ / "scripts" / "n02_cross.py")
n02_cross = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(n02_cross)


@pytest.fixture(scope="module")
def resultados():
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        return {c: n02_cross.comparar(c) for c in n02_cross.CONJUNTOS}


@pytest.mark.parametrize("c", n02_cross.CONJUNTOS)
def test_julia_numpy_y_oraculo_coinciden(resultados, c):
    r = resultados[c]
    assert r["julia_igual_oraculo"] and r["numpy_igual_oraculo"]
    assert all(r["metricas_julia_vs_numpy"].values())


def test_samuelson_ocho_canales(resultados):
    """Un canal 45 veces mayor no se marca: con 8 canales, |z| ≤ √7 < 3."""
    assert resultados["d2_ocho_canales"]["etiquetas_oraculo"] == [[]] * 8


def test_once_canales_marca(resultados):
    assert "atipico" in resultados["d3_once_canales"]["etiquetas_oraculo"][10]


def test_diferencias_metodologicas(resultados):
    assert resultados["d4_identicos"]["z_scipy_tiene_nan"]
    assert resultados["d5_plano_parcial"]["planos_mne"] == [0]
    assert resultados["d5_plano_parcial"]["planos_contrato"] == []
    assert resultados["d1_mixto"]["planos_mne"] == resultados["d1_mixto"]["planos_contrato"] == [2]
