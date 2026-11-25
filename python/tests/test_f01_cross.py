"""CROSS de F01-P01 · `uv run --project python pytest python/tests`.

Compara tres implementaciones independientes de la correspondencia vector
MULTIPLEXED → matriz canales × muestras, en base cero:

* el oráculo Lean (especificación ejecutable `LeanlabBook.F01.tabla`);
* la implementación Julia (`F01Indice.indice`, base uno, exportada a base cero);
* NumPy, que almacena por filas (*row-major*) por defecto.

Como los índices son enteros, la tolerancia es **cero**: igualdad exacta.
"""

import json
from pathlib import Path

import numpy as np
import pytest

RAIZ = Path(__file__).resolve().parents[2]
VERIF = RAIZ / "verification" / "F01"
TAMANOS = [(4, 3), (1, 1), (7, 5), (3, 31)]


def leer(origen: str, N: int, C: int) -> list[tuple[int, int, int]]:
    datos = json.loads((VERIF / origen / f"tabla_{N}x{C}.json").read_text())
    return [tuple(fila) for fila in datos]


# FRAGMENTO: matriz_numpy
def matriz_numpy(N: int, C: int) -> np.ndarray:
    """Matriz canales × muestras a partir del vector MULTIPLEXED 0..N*C-1."""
    v = np.arange(N * C)
    return v.reshape(N, C).T  # cada fila del reshape es una muestra; .T es una vista
# FIN: matriz_numpy


def tabla_numpy(N: int, C: int) -> list[tuple[int, int, int]]:
    M = matriz_numpy(N, C)
    return [(n, c, int(M[c, n])) for n in range(N) for c in range(C)]


@pytest.mark.parametrize("N,C", TAMANOS)
def test_lean_julia_numpy_coinciden(N, C):
    lean = leer("oraculo_lean", N, C)
    julia = leer("julia", N, C)
    numpy = tabla_numpy(N, C)
    assert len(lean) == N * C
    assert lean == julia == numpy


@pytest.mark.parametrize("N,C", TAMANOS)
def test_orden_fortran_equivale(N, C):
    """En orden Fortran (column-major, como Julia) basta reshape(C, N)."""
    v = np.arange(N * C)
    assert np.array_equal(v.reshape((C, N), order="F"), matriz_numpy(N, C))


def test_traspuesta_es_vista_sin_copia():
    v = np.arange(12)
    M = v.reshape(4, 3).T
    assert np.shares_memory(M, v)
    assert not M.flags["C_CONTIGUOUS"] and M.flags["F_CONTIGUOUS"]


@pytest.mark.parametrize("N,C", [(4, 3), (7, 5), (3, 31)])
def test_mutacion_orientacion_detectada(N, C):
    """Error típico: reshape(C, N) en orden C. Misma forma, contenido distinto."""
    v = np.arange(N * C)
    erronea = v.reshape(C, N)
    assert erronea.shape == matriz_numpy(N, C).shape
    assert not np.array_equal(erronea, matriz_numpy(N, C))
