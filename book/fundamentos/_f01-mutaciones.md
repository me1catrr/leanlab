<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/test/runtests.jl"}
intercambio(C, n, c) = (c - 1) * C + n          # n y c intercambiados
base_cero(C, n, c) = n * C + c                  # olvida restar 1 (base)
vectorizada(C, n, c) = (c - 1) * 4 + n          # orientación por canal con N fijo
@test !cumple_contrato(intercambio, 4, 3)
@test !cumple_contrato(base_cero, 4, 3)
@test !cumple_contrato(vectorizada, 5, 3)
```
