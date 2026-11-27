<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/src/N02Calidad.jl"}
function control_calidad(X::AbstractMatrix{<:Real}; umbral_plano = 1.0, limite_sat = 1000.0,
                         frac_sat = 0.01, umbral_z = 3.0)
    C = size(X, 1)
    etiquetas = [Symbol[] for _ in 1:C]
    sigma = fill(NaN, C); rango = fill(NaN, C); fsat = fill(NaN, C); z = fill(NaN, C)
    for c in 1:C
        x = view(X, c, :)
        if !all(isfinite, x)
            push!(etiquetas[c], :no_valido)
            continue
        end
        m = metricas_canal(x; limite_sat)
        rango[c], sigma[c], fsat[c] = m.rango, m.sigma, m.frac_sat
        m.rango < umbral_plano && push!(etiquetas[c], :plano)
        m.frac_sat ≥ frac_sat && push!(etiquetas[c], :saturado)
    end
    en_z = [c for c in 1:C if isfinite(sigma[c]) && :plano ∉ etiquetas[c]]
    if !isempty(en_z)
        s = sigma[en_z]
        μ, σs = mean(s), std(s; corrected = false)
        if σs > 0
            for (i, c) in enumerate(en_z)
                z[c] = (s[i] - μ) / σs
                abs(z[c]) > umbral_z && push!(etiquetas[c], :atipico)
            end
        end
    end
    return (etiquetas = etiquetas, sigma = sigma, rango = rango, frac_sat = fsat, z = z,
            n_canales_z = length(en_z))
end
```
