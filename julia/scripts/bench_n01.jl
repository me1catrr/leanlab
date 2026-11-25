# BENCH de N01 · `julia --project=julia julia/scripts/bench_n01.jl`
#
# Pregunta: ¿dónde se va el tiempo al leer un registro BrainVision?
# Se miden por separado las etapas del lector (I/O, decodificación,
# calibración) sobre un fichero sintético grande. Antes de medir se valida que
# la composición de etapas da lo mismo que el lector completo.
# Advertencia: tras la primera lectura el archivo queda en la caché del sistema
# operativo; la etapa de I/O mide, por tanto, lectura desde memoria caché.
using BenchmarkTools, Dates, LinearAlgebra, Statistics
using LeanlabJulia.N01BrainVision

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const C, N = 31, 500_000                       # 1000 s a 500 Hz, 31 canales

dir = mktempdir()
nombre = "bench_int16"
open(joinpath(dir, nombre * ".vhdr"), "w") do io
    print(io, """
    Brain Vision Data Exchange Header File Version 1.0
    ; Fichero sintético de LEANLAB (benchmark N01).
    [Common Infos]
    DataFile=$nombre.eeg
    MarkerFile=$nombre.vmrk
    DataFormat=BINARY
    DataOrientation=MULTIPLEXED
    NumberOfChannels=$C
    DataPoints=$N
    SamplingInterval=2000
    [Binary Infos]
    BinaryFormat=INT_16
    [Channel Infos]
    """)
    for c in 1:C
        println(io, "Ch$c=C$c,,0.1,µV")
    end
end
crudo_v = Int16[mod(k * 7919, 4001) - 2000 for k in 1:N*C]   # determinista
write(joinpath(dir, nombre * ".eeg"), htol.(crudo_v))
vhdr = joinpath(dir, nombre * ".vhdr")
cab = leer_cabecera(vhdr)

# 1. Validar antes de medir.
completo = leer_brainvision(vhdr).datos_uV
por_etapas = calibrar(decodificar(leer_bytes(cab.archivo_datos), Int16, C), cab.resoluciones)
@assert completo == por_etapas
@assert size(completo) == (C, N)

# 2. Medir cada etapa.
bytes = leer_bytes(cab.archivo_datos)
crudo = decodificar(bytes, Int16, C)
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 5
etapas = [
    "1 · I/O (leer_bytes)" => (@benchmarkable leer_bytes($(cab.archivo_datos))),
    "2 · decodificación (reinterpret + ltoh + reshape)" => (@benchmarkable decodificar($bytes, Int16, $C)),
    "3 · calibración (Float64 · resolución)" => (@benchmarkable calibrar($crudo, $(cab.resoluciones))),
    "total (leer_brainvision)" => (@benchmarkable leer_brainvision($vhdr)),
]
resultados = Dict{String,Any}()
for (nombre_etapa, b) in etapas
    t = run(tune!(b))
    ns = t.times
    resultados[nombre_etapa] = Dict("muestras" => length(ns), "mediana_ns" => median(ns),
        "q25_ns" => quantile(ns, 0.25), "q75_ns" => quantile(ns, 0.75),
        "asignaciones" => t.allocs, "memoria_bytes" => t.memory)
    println(rpad(nombre_etapa, 52), " mediana = ", round(median(ns) / 1e6; digits = 2), " ms  memoria = ",
            round(t.memory / 2^20; digits = 1), " MiB")
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
    "datos" => "INT_16 sintético determinista, C=$C × N=$N ($(round(N*C*2/2^20; digits=1)) MiB), resolución 0,1 µV",
    "advertencia_io" => "archivo en la caché del sistema operativo tras la primera lectura")
write(joinpath(RAIZ, "verification", "N01", "bench_julia.json"), json(Dict("entorno" => entorno, "resultados" => resultados)) * "\n")
println("Resultados en verification/N01/bench_julia.json")
