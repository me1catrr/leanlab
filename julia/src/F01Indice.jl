"""
    F01Indice

Implementación Julia de F01-P01: correspondencia entre la posición de una muestra
en un vector binario MULTIPLEXED y su lugar en la matriz canales × muestras.

Julia indexa **desde uno** y almacena las matrices **por columnas**
(*column-major*). Por eso `reshape(v, C, N)` produce directamente la matriz
canales × muestras **sin copiar** los datos.

Especificación formal (base cero) en `lean/LeanlabBook/F01/Indice.lean`:
`idx C n c = n * C + c`. Aquí, en base uno: `indice(C, n, c) = (n - 1) * C + c`.
"""
module F01Indice

export indice, indice_comprobado, canal_y_muestra, matriz_multiplexada, matriz_copia

"""
    indice(C, n, c) -> Int

Posición (base uno) de la muestra `n` del canal `c` en un vector MULTIPLEXED con `C`
canales. Precondiciones: `C ≥ 1`, `n ≥ 1`, `1 ≤ c ≤ C`.
"""
# FRAGMENTO: indice
function indice(C::Integer, n::Integer, c::Integer)
    (C ≥ 1 && n ≥ 1 && 1 ≤ c ≤ C) || throw(ArgumentError("índices fuera de rango: C=$C, n=$n, c=$c"))
    return (n - 1) * C + c
end
# FIN: indice

"""
    indice_comprobado(C, n, c) -> Int

Igual que `indice`, pero detecta el desbordamiento de `Int` (que en ℕ no existe).
"""
function indice_comprobado(C::Integer, n::Integer, c::Integer)
    (C ≥ 1 && n ≥ 1 && 1 ≤ c ≤ C) || throw(ArgumentError("índices fuera de rango: C=$C, n=$n, c=$c"))
    return Base.checked_add(Base.checked_mul(n - 1, C), c)
end

"""
    canal_y_muestra(C, k) -> (n, c)

Inversa de `indice`: recupera la muestra `n` y el canal `c` (base uno) de la posición `k`.
"""
function canal_y_muestra(C::Integer, k::Integer)
    (C ≥ 1 && k ≥ 1) || throw(ArgumentError("posición fuera de rango: C=$C, k=$k"))
    q, r = divrem(k - 1, C)
    return (q + 1, r + 1)
end

"""
    matriz_multiplexada(v, C) -> matriz C × N

Vista canales × muestras de un vector MULTIPLEXED, **sin copiar** los datos.
"""
# FRAGMENTO: matriz
function matriz_multiplexada(v::AbstractVector, C::Integer)
    C ≥ 1 || throw(ArgumentError("C debe ser ≥ 1"))
    length(v) % C == 0 || throw(ArgumentError("la longitud $(length(v)) no es múltiplo de C=$C"))
    return reshape(v, C, length(v) ÷ C)
end
# FIN: matriz

"""
    matriz_copia(v, C) -> Matrix C × N

Igual que `matriz_multiplexada`, pero devuelve una copia independiente.
"""
matriz_copia(v::AbstractVector, C::Integer) = copy(matriz_multiplexada(v, C))

end # module
