<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/src/F01Indice.jl"}
function indice(C::Integer, n::Integer, c::Integer)
    (C ≥ 1 && n ≥ 1 && 1 ≤ c ≤ C) || throw(ArgumentError("índices fuera de rango: C=$C, n=$n, c=$c"))
    return (n - 1) * C + c
end
```

```{.julia filename="julia/src/F01Indice.jl"}
function matriz_multiplexada(v::AbstractVector, C::Integer)
    C ≥ 1 || throw(ArgumentError("C debe ser ≥ 1"))
    length(v) % C == 0 || throw(ArgumentError("la longitud $(length(v)) no es múltiplo de C=$C"))
    return reshape(v, C, length(v) ÷ C)
end
```
