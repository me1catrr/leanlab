"""CROSS de N01 · `uv run --project python pytest python/tests`.

Requiere los ficheros sintéticos (scripts/n01_ficheros.py) y las lecturas de
Julia (julia/scripts/n01_exportar.jl). Comprueba las expectativas fijadas en
verification/N01/protocolo.yml (versión 1) antes de ejecutar la comparación.
"""

import importlib.util
from pathlib import Path

import pytest

RAIZ = Path(__file__).resolve().parents[2]
_spec = importlib.util.spec_from_file_location("n01_cross", RAIZ / "scripts" / "n01_cross.py")
n01_cross = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(n01_cross)


@pytest.fixture(scope="module")
def resultados():
    return {f: n01_cross.comparar(f) for f in n01_cross.FICHEROS}


@pytest.mark.parametrize("f", ["f1_float32", "f2_int16", "f6_fs_no_entera"])
def test_julia_mne_y_analitico_coinciden(resultados, f):
    r = resultados[f]
    assert r["julia"] == r["mne"] == "leido"
    assert r["julia_vs_analitico"]["dentro_tolerancia"]
    assert r["mne_vs_analitico"]["dentro_tolerancia"]
    assert r["julia_vs_mne"]["dentro_tolerancia"]
    assert r["fs_iguales"]


def test_frecuencia_no_entera(resultados):
    r = resultados["f6_fs_no_entera"]
    assert r["fs_julia"] == pytest.approx(1e6 / 3, rel=1e-12)
    assert r["fs_julia"] != round(r["fs_julia"])


def test_truncado_mismos_datos_distinto_aviso(resultados):
    r = resultados["f3_truncado"]
    assert r["julia_vs_mne"]["dentro_tolerancia"]
    assert len(r["avisos_julia"]) == 2
    assert r["avisos_mne"] == []
    assert r["clasificacion"] == "diferencia_metodologica"


@pytest.mark.parametrize("f", ["f4_vectorizado", "f5_milivoltios"])
def test_rechazos_por_contrato_frente_a_mne(resultados, f):
    r = resultados[f]
    assert r["julia"] == "rechazado"
    assert r["mne"] == "leido"
    assert r["mne_vs_analitico"]["dentro_tolerancia"]   # MNE los lee bien
    assert r["clasificacion"] == "diferencia_metodologica"


def test_mne_devuelve_voltios(resultados):
    """La mutación «olvidar convertir» daría un factor 10⁶: se comprueba la escala."""
    import numpy as np
    esp = n01_cross.leer_json("esperado", "f1_float32")
    mne_V = n01_cross.leer_mne("f1_float32")["datos_V"]
    assert np.allclose(mne_V * 1e6, esp["datos_uV"], rtol=1e-12, atol=0)
    assert not np.allclose(mne_V, esp["datos_uV"], rtol=1e-3, atol=0)
