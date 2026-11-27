"""
    N02Calidad

Control de calidad por canal, original de LEANLAB (MIT), escrito para estudiar
su verificación. Contrato en verification/N02/protocolo.yml:

- N02-C01  no válido: el canal tiene algún NaN o Inf (se excluye del resto);
- N02-C02  plano: rango pico a pico < `umbral_plano` (1 µV);
- N02-C03  saturado: fracción de |x| ≥ `limite_sat` (1000 µV) ≥ `frac_sat` (1 %);
- N02-C04  atípico: |z| > `umbral_z` (3), con z el z-score POBLACIONAL de la
           desviación típica poblacional de cada canal, calculado sobre los
           canales válidos y no planos; si su dispersión es 0, ninguno;
- N02-C05  etiquetas por canal (unión); N02-C06 no modifica los datos.

Cota de Samuelson (demostrada en Lean, N02-P01): con n canales en el cálculo,
|z| ≤ √(n − 1). Con n ≤ 10, ningún canal puede superar |z| > 3.
"""
module N02Calidad

using Statistics

export control_calidad, metricas_canal

"""Métricas de un canal: rango pico a pico, desviación típica poblacional y
fracción de muestras saturadas."""
function metricas_canal(x::AbstractVector{<:Real}; limite_sat = 1000.0)
    rango = maximum(x) - minimum(x)
    sigma = std(x; corrected = false)
    frac = count(v -> abs(v) ≥ limite_sat, x) / length(x)
    return (rango = rango, sigma = sigma, frac_sat = frac)
end

"""
    control_calidad(X; umbral_plano=1.0, limite_sat=1000.0, frac_sat=0.01, umbral_z=3.0)

`X` es canales × muestras en µV. Devuelve, por canal, las etiquetas
(`:no_valido`, `:plano`, `:saturado`, `:atipico`) y las métricas, y además el
número de canales que entran en el cálculo del z-score.
"""
# FRAGMENTO: control_calidad
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
# FIN: control_calidad

end # module
