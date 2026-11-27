<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/test/n02.jl"}
# Errores típicos, escritos como variantes del contrato:
sin_excluir_no_validos(X) = control_calidad(replace(X, NaN => 0.0))
umbral_mayor_o_igual(X) = control_calidad(X; umbral_z = prevfloat(3.0))
z_sobre_todos(X) = control_calidad(X; umbral_plano = -Inf)   # los planos entran en z
@test !acierta_todo(sin_excluir_no_validos)
@test !acierta_todo(z_sobre_todos)
```
