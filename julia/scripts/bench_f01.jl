# BENCH de F01-P01 · `julia --project=julia julia/scripts/bench_f01.jl`
#
# Pregunta: ¿cuánto cuesta construir la matriz canales × muestras a partir del
# vector MULTIPLEXED, con vista (`reshape`) o con copia?
# No es una comparación entre lenguajes. Antes de medir se valida el resultado.
using BenchmarkTools, Dates, LinearAlgebra, Statistics
using LeanlabJulia.F01Indice

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const C = 31          # canales
const N = 100_000     # muestras por canal (200 s a 500 Hz)

v = rand(Float32, N * C)

# 1. Validar antes de medir: vista y copia contienen lo mismo y respetan el índice.
M_vista = matriz_multiplexada(v, C)
M_copia = matriz_copia(v, C)
@assert M_vista == M_copia
@assert all(M_vista[c, n] == v[indice(C, n, c)] for n in (1, N ÷ 2, N), c in (1, 16, C))

# 2. Medir (ejecución en caliente; la compilación queda fuera).
casos = [
    "vista (reshape)" => (@benchmarkable matriz_multiplexada($v, $C)),
    "copia (copy ∘ reshape)" => (@benchmarkable matriz_copia($v, $C)),
    "muestras × canales (permutedims)" => (@benchmarkable permutedims(matriz_multiplexada($v, $C))),
]
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 3

function resumen(t)
    ns = t.times
    return Dict(
        "muestras" => length(ns),
        "mediana_ns" => median(ns), "minimo_ns" => minimum(ns),
        "q25_ns" => quantile(ns, 0.25), "q75_ns" => quantile(ns, 0.75),
        "asignaciones" => t.allocs, "memoria_bytes" => t.memory,
    )
end

resultados = Dict{String,Any}()
for (nombre, b) in casos
    t = run(tune!(b))
    resultados[nombre] = resumen(t)
    println(rpad(nombre, 36), " mediana = ", round(median(t.times) / 1e3; digits = 3), " µs  ",
            "asignaciones = ", t.allocs, "  memoria = ", t.memory, " B")
end

# 3. Registrar el entorno junto a los resultados.
function json(x)
    x isa AbstractDict && return "{" * join(["\"$k\": " * json(x[k]) for k in sort(collect(keys(x)))], ", ") * "}"
    x isa AbstractString && return "\"" * escape_string(x) * "\""
    x isa AbstractFloat && return string(round(x; digits = 3))
    return string(x)
end
entorno = Dict(
    "fecha" => string(now()),
    "julia" => string(VERSION),
    "sistema" => string(Sys.KERNEL, " ", Sys.ARCH),
    "cpu" => Sys.cpu_info()[1].model,
    "hilos_julia" => Threads.nthreads(),
    "hilos_blas" => BLAS.get_num_threads(),
    "benchmarktools" => string(pkgversion(BenchmarkTools)),
    "datos" => "Float32 aleatorio, C=$C canales × N=$N muestras",
    "segundos_por_caso" => 3,
)
salida = joinpath(RAIZ, "verification", "F01", "bench_julia.json")
write(salida, json(Dict("entorno" => entorno, "resultados" => resultados)) * "\n")
println("Resultados en ", salida)
