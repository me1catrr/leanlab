"""
    N03Filtrado

Filtrado para N03 (MIT), escrito para estudiar su verificación.

- `filtro_un_polo`: y[n] = α·x[n] + (1 − α)·y[n − 1], genérico en el tipo
  numérico (Float64, Rational{BigInt}…). Sus propiedades están demostradas en
  Lean sobre ℝ (N03-P01…P04).
- `butterworth`: paso bajo Butterworth en secciones de segundo orden con DSP.jl.
- `filtrar_bloques`: filtrado por bloques conservando el estado entre bloques.
"""
module N03Filtrado

using DSP

export filtro_un_polo, butterworth, filtrar_bloques, polos, filtrar_filas, filtrar_columnas

# FRAGMENTO: un_polo
"""Filtro de un polo. `y0` hace de y[−1]. Requiere 0 < α ≤ 1."""
function filtro_un_polo(α, x::AbstractVector; y0 = zero(α * first(x)))
    0 < α ≤ 1 || throw(ArgumentError("se requiere 0 < α ≤ 1"))
    y = similar(x, typeof(α * first(x) + (1 - α) * y0))
    yprev = y0
    for n in eachindex(x)
        yprev = α * x[n] + (1 - α) * yprev
        y[n] = yprev
    end
    return y
end
# FIN: un_polo

"""Paso bajo Butterworth de `orden` con corte `fc` Hz a `fs` Hz, como SOS."""
butterworth(orden::Integer, fc::Real, fs::Real) =
    SecondOrderSections(digitalfilter(Lowpass(fc), Butterworth(orden); fs = fs))

"""Polos del filtro en el plano z."""
polos(f) = ZeroPoleGain(f).p

# FRAGMENTO: bloques
"""Filtra `x` por bloques de `tam` muestras conservando el estado entre bloques."""
function filtrar_bloques(f::SecondOrderSections, x::AbstractVector, tam::Integer)
    estado = DF2TFilter(f)                       # filtro con memoria
    y = similar(x, Float64)
    for i in 1:tam:length(x)
        j = min(i + tam - 1, length(x))
        y[i:j] = filt(estado, x[i:j])            # el estado pasa de un bloque al siguiente
    end
    return y
end
# FIN: bloques

"""Filtra cada canal de una matriz C × N (canales en filas)."""
function filtrar_filas(f, X::AbstractMatrix)
    Y = similar(X, Float64)
    for c in axes(X, 1)
        Y[c, :] = filt(f, X[c, :])
    end
    return Y
end

"""Filtra cada canal de una matriz N × C (canales en columnas contiguas)."""
filtrar_columnas(f, Xt::AbstractMatrix) = filt(f, Xt)

end # module
