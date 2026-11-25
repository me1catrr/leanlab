# Exporta lo que lee el lector Julia de cada fichero sintético de N01 (µV),
# o el rechazo por contrato, para la comparación cruzada con MNE.
# Uso: julia --project=julia julia/scripts/n01_exportar.jl
using LeanlabJulia.N01BrainVision
using Logging

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const ORIGEN = joinpath(RAIZ, "verification", "N01", "ficheros")
const DESTINO = joinpath(RAIZ, "verification", "N01", "julia")
mkpath(DESTINO)

num(x) = repr(x)                          # representación exacta de Float64
fila(v) = "[" * join(num.(v), ", ") * "]"

for f in ("f1_float32", "f2_int16", "f3_truncado", "f4_vectorizado", "f5_milivoltios", "f6_fs_no_entera")
    salida = joinpath(DESTINO, f * ".json")
    try
        r = with_logger(NullLogger()) do
            leer_brainvision(joinpath(ORIGEN, f * ".vhdr"))
        end
        datos = "[" * join([fila(r.datos_uV[c, :]) for c in axes(r.datos_uV, 1)], ", ") * "]"
        avisos = "[" * join(["\"$(escape_string(a))\"" for a in r.avisos], ", ") * "]"
        write(salida, """{"fichero": "$f", "estado": "leido", "fs_Hz": $(num(r.fs)), "avisos": $avisos, "datos_uV": $datos}\n""")
    catch e
        e isa ArgumentError || rethrow()
        write(salida, """{"fichero": "$f", "estado": "rechazado", "motivo": "$(escape_string(e.msg))"}\n""")
    end
end
println("Lecturas Julia escritas en ", DESTINO)
