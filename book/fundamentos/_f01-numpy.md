<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.python filename="python/tests/test_f01_cross.py"}
def matriz_numpy(N: int, C: int) -> np.ndarray:
    """Matriz canales × muestras a partir del vector MULTIPLEXED 0..N*C-1."""
    v = np.arange(N * C)
    return v.reshape(N, C).T  # cada fila del reshape es una muestra; .T es una vista
```
