# BENCH de N02 · `julia --project=julia julia/scripts/bench_n02.jl`
#
# Pregunta: ¿importa cómo están dispuestos los datos en memoria al calcular
# métricas por canal? Julia guarda las matrices por columnas: en una matriz
# canales × muestras (C × N), las muestras de un canal NO son contiguas.
# Se comparan las mismas métricas sobre X (C × N, filas) y sobre Xt (N × C,
# columnas contiguas). Antes de medir se valida que dan lo mismo.
using BenchmarkTools, Dates, Statistics
using LeanlabJulia.N02Calidad

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const C, N = 31, 500_000

X = [20.0 * sin(2π * 10 * n / 500 + c) + (c == 7 ? 400.0 : 0.0) * cos(2π * n / 500) for c in 1:C, n in 1:N]
Xt = permutedims(X)                                        # N × C: cada canal es una columna contigua

metricas_filas(X) = [metricas_canal(view(X, c, :)) for c in axes(X, 1)]
metricas_columnas(Xt) = [metricas_canal(view(Xt, :, c)) for c in axes(Xt, 2)]

# 1. Validar antes de medir (mismo cálculo, distinta disposición).
@assert all(map((a, b) -> isapprox(a.sigma, b.sigma; rtol = 1e-12) && a.rango == b.rango && a.frac_sat == b.frac_sat,
                metricas_filas(X), metricas_columnas(Xt)))

BenchmarkTools.DEFAULT_PARAMETERS.seconds = 5
casos = [
    "métricas por canal · C × N (filas, con salto)" => (@benchmarkable metricas_filas($X)),
    "métricas por canal · N × C (columnas contiguas)" => (@benchmarkable metricas_columnas($Xt)),
    "control_calidad completo · C × N" => (@benchmarkable control_calidad($X)),
]
resultados = Dict{String,Any}()
for (nombre, b) in casos
    t = run(tune!(b))
    ns = t.times
    resultados[nombre] = Dict("muestras" => length(ns), "mediana_ns" => median(ns),
        "q25_ns" => quantile(ns, 0.25), "q75_ns" => quantile(ns, 0.75),
        "asignaciones" => t.allocs, "memoria_bytes" => t.memory)
    println(rpad(nombre, 50), " mediana = ", round(median(ns) / 1e6; digits = 2), " ms")
end

function json(x)
    x isa AbstractDict && return "{" * join(["\"$k\": " * json(x[k]) for k in sort(collect(keys(x)))], ", ") * "}"
    x isa AbstractString && return "\"" * escape_string(x) * "\""
    x isa AbstractFloat && return string(round(x; digits = 3))
    return string(x)
end
entorno = Dict("fecha" => string(now()), "julia" => string(VERSION), "sistema" => string(Sys.KERNEL, " ", Sys.ARCH),
    "cpu" => Sys.cpu_info()[1].model, "hilos_julia" => Threads.nthreads(),
    "benchmarktools" => string(pkgversion(BenchmarkTools)),
    "datos" => "Float64 sintético determinista, C=$C × N=$N ($(round(C*N*8/2^20; digits=1)) MiB)")
write(joinpath(RAIZ, "verification", "N02", "bench_julia.json"), json(Dict("entorno" => entorno, "resultados" => resultados)) * "\n")
println("Resultados en verification/N02/bench_julia.json")
