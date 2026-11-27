<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/test/n03.jl"}
α, y0, x = leer_entrada("a1")
lean = filtro_un_polo(α, x; y0 = y0)                            # = oráculo (ver arriba)
coef_cambiados = filtro_un_polo(1 - α, x; y0 = y0)              # α y (1 − α) intercambiados
corte_mal_normalizado = SecondOrderSections(digitalfilter(Lowpass(40 / 500), Butterworth(4)))
reinicio_por_bloque(f, x, t) = reduce(vcat, [filt(f, x[i:min(i + t - 1, end)]) for i in 1:t:length(x)])
f = butterworth(4, 40, 500); b1 = leer_f64("b1")
@test coef_cambiados != lean
@test !isapprox(abs(freqresp(corte_mal_normalizado, [2π * 40 / 500])[1]), 1 / sqrt(2); rtol = 1e-3)
@test !isapprox(reinicio_por_bloque(f, b1, 137), filt(f, b1); rtol = 1e-6)
```
