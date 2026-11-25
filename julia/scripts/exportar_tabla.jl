# Exporta la tabla (n, c, k) en base cero calculada por la implementación Julia,
# para la comparación cruzada (CROSS) con el oráculo Lean y con NumPy.
# Uso: julia --project=julia julia/scripts/exportar_tabla.jl
using LeanlabJulia.F01Indice

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const DESTINO = joinpath(RAIZ, "verification", "F01", "julia")
mkpath(DESTINO)

for (N, C) in [(4, 3), (1, 1), (7, 5), (3, 31)]
    filas = String[]
    for n in 1:N, c in 1:C                       # mismo orden que el archivo
        push!(filas, "[$(n - 1),$(c - 1),$(indice(C, n, c) - 1)]")
    end
    write(joinpath(DESTINO, "tabla_$(N)x$(C).json"), "[" * join(filas, ",") * "]\n")
end
println("Tablas Julia escritas en ", DESTINO)
