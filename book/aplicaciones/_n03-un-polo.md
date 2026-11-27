<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/src/N03Filtrado.jl"}
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
```

```{.julia filename="julia/src/N03Filtrado.jl"}
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
```
