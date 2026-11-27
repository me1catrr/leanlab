# BENCH de N03 · `julia --project=julia julia/scripts/bench_n03.jl`
#
# Dos preguntas:
# 1. ¿Cuánto cuesta filtrar 31 canales con un Butterworth según la disposición
#    de los datos (C × N con copias por fila, frente a N × C por columnas)?
# 2. ¿Cuánto cuesta la exactitud? El filtro de un polo en Float64 frente a
#    Rational{BigInt}, con la misma entrada (a2, N = 2000).
# Antes de medir se valida que cada pareja da el mismo resultado.
using BenchmarkTools, Dates, Statistics
using LeanlabJulia.N03Filtrado
using DSP

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const C, N = 31, 500_000
f = butterworth(4, 40, 500)
X = [sin(2π * 10 * n / 500 + c) + 0.3 * sin(2π * 90 * n / 500) for c in 1:C, n in 1:N]
Xt = permutedims(X)
@assert filtrar_filas(f, X) ≈ permutedims(filtrar_columnas(f, Xt))

r(s) = (p = split(strip(s), '/'); length(p) == 1 ? parse(BigInt, p[1]) // 1 : parse(BigInt, p[1]) // parse(BigInt, p[2]))
l = readlines(joinpath(RAIZ, "verification", "N03", "senales", "a2_entrada.txt"))
α, y0, x = r(l[1]), r(l[2]), r.(l[3:end])
xf = Float64.(x)
@assert maximum(abs.(filtro_un_polo(Float64(α), xf; y0 = 0.0) .- Float64.(filtro_un_polo(α, x; y0 = y0)))) ≤ 1e-12

BenchmarkTools.DEFAULT_PARAMETERS.seconds = 5
casos = [
    "Butterworth · C × N (por filas, con copias)" => (@benchmarkable filtrar_filas($f, $X)),
    "Butterworth · N × C (por columnas)" => (@benchmarkable filtrar_columnas($f, $Xt)),
    "un polo · Float64 (N = 2000)" => (@benchmarkable filtro_un_polo($(Float64(α)), $xf; y0 = 0.0)),
    "un polo · Rational{BigInt} exacto (N = 2000)" => (@benchmarkable filtro_un_polo($α, $x; y0 = $y0)),
]
resultados = Dict{String,Any}()
for (nombre, b) in casos
    t = run(tune!(b))
    ns = t.times
    resultados[nombre] = Dict("muestras" => length(ns), "mediana_ns" => median(ns),
        "q25_ns" => quantile(ns, 0.25), "q75_ns" => quantile(ns, 0.75),
        "asignaciones" => t.allocs, "memoria_bytes" => t.memory)
    println(rpad(nombre, 48), " mediana = ", round(median(ns) / 1e6; digits = 3), " ms")
end

function json(x)
    x isa AbstractDict && return "{" * join(["\"$k\": " * json(x[k]) for k in sort(collect(keys(x)))], ", ") * "}"
    x isa AbstractString && return "\"" * escape_string(x) * "\""
    x isa AbstractFloat && return string(round(x; digits = 3))
    return string(x)
end
entorno = Dict("fecha" => string(now()), "julia" => string(VERSION), "sistema" => string(Sys.KERNEL, " ", Sys.ARCH),
    "cpu" => Sys.cpu_info()[1].model, "hilos_julia" => Threads.nthreads(),
    "benchmarktools" => string(pkgversion(BenchmarkTools)), "dsp" => string(pkgversion(DSP)),
    "datos" => "Butterworth: Float64 sintético C=$C × N=$N; un polo: entrada a2 (N = 2000)")
write(joinpath(RAIZ, "verification", "N03", "bench_julia.json"), json(Dict("entorno" => entorno, "resultados" => resultados)) * "\n")
println("Resultados en verification/N03/bench_julia.json")
