# Exporta el resultado del control de calidad Julia de cada conjunto de N02
# (etiquetas y métricas) para la comparación cruzada.
# Uso: julia --project=julia julia/scripts/n02_exportar.jl
using LeanlabJulia.N02Calidad

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const DIR = joinpath(RAIZ, "verification", "N02")
mkpath(joinpath(DIR, "julia"))

function leer(nombre)
    meta = Dict(split(l, '=') |> p -> (p[1] => p[2]) for l in eachline(joinpath(DIR, "datos", nombre * ".meta")))
    C, N = parse(Int, meta["C"]), parse(Int, meta["N"])
    v = ltoh.(reinterpret(Float64, read(joinpath(DIR, "datos", nombre * ".f64"))))
    return permutedims(reshape(collect(v), N, C))
end

num(x) = isfinite(x) ? repr(x) : "null"
lista(v) = "[" * join(num.(v), ", ") * "]"

for nombre in ("d1_mixto", "d2_ocho_canales", "d3_once_canales", "d4_identicos", "d5_plano_parcial")
    r = control_calidad(leer(nombre))
    etq = "[" * join(["[" * join(["\"$e\"" for e in es], ", ") * "]" for es in r.etiquetas], ", ") * "]"
    write(joinpath(DIR, "julia", nombre * ".json"),
          """{"conjunto": "$nombre", "etiquetas": $etq, "sigma": $(lista(r.sigma)), "rango": $(lista(r.rango)), "frac_sat": $(lista(r.frac_sat)), "z": $(lista(r.z)), "n_canales_z": $(r.n_canales_z)}\n""")
end
println("Resultados Julia escritos en ", joinpath(DIR, "julia"))
