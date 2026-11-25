<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/src/N01BrainVision.jl"}
function decodificar(bytes::Vector{UInt8}, ::Type{T}, C::Integer) where {T}
    bps = sizeof(T)
    n = length(bytes) ÷ (C * bps)                 # muestras completas
    n ≥ 1 || throw(ArgumentError("el archivo no contiene ninguna muestra completa"))
    v = ltoh.(reinterpret(T, view(bytes, 1:n*C*bps)))
    return matriz_multiplexada(v, C)              # F01: x[c, n] = v[(n-1)C + c]
end

"""Etapa 3 · Calibración: x_µV[c, n] = Float64(raw[c, n]) · resolución[c]."""
calibrar(crudo::AbstractMatrix, resoluciones::AbstractVector) = Float64.(crudo) .* resoluciones
```
