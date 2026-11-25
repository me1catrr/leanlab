"""
    N01BrainVision

Lector BrainVision mínimo y original de LEANLAB (licencia MIT), escrito para
estudiar su verificación. **No** es el cargador de ningún motor de producción.

Contrato (verification/N01/protocolo.yml):

- N01-C01  dimensiones canales × muestras completas;
- N01-C02  solo orientación MULTIPLEXED (VECTORIZED se rechaza);
- N01-C03  formatos IEEE_FLOAT_32 e INT_16, little-endian;
- N01-C04  calibración x_µV = raw · resolución; unidad µV, uV o vacía;
- N01-C05  cualquier otra unidad se rechaza;
- N01-C06  fs = 10⁶ / SamplingInterval[µs], sin suponer que sea entera;
- N01-C07  archivo truncado → aviso y muestras completas; ninguna → error;
- N01-C08  los marcadores (.vmrk) quedan fuera del alcance.

El lector se divide en etapas (`leer_bytes`, `decodificar`, `calibrar`) para
poder probarlas y medirlas por separado.
"""
module N01BrainVision

using ..F01Indice: matriz_multiplexada

export leer_cabecera, leer_brainvision, leer_bytes, decodificar, calibrar

const UNIDADES_MICROVOLTIO = ("", "µV", "μV", "uV")   # µ (U+00B5) y μ (U+03BC)
const FORMATOS = Dict("IEEE_FLOAT_32" => Float32, "INT_16" => Int16)

"""Lee el texto de la cabecera. Si no es UTF-8 válido, lo interpreta como
Latin-1 (la «µ» de algunos equipos es el byte 0xB5)."""
function texto_cabecera(ruta::AbstractString)
    bytes = read(ruta)
    s = String(copy(bytes))
    isvalid(s) && return s
    return String(map(Char, bytes))
end

"""
    leer_cabecera(ruta_vhdr) -> NamedTuple

Interpreta las secciones `[Common Infos]`, `[Binary Infos]` y `[Channel Infos]`.
"""
function leer_cabecera(ruta::AbstractString)
    seccion = ""
    comun = Dict{String,String}()
    binario = Dict{String,String}()
    canales = Pair{Int,String}[]
    for linea in eachline(IOBuffer(texto_cabecera(ruta)))
        l = strip(linea)
        (isempty(l) || startswith(l, ";")) && continue
        if startswith(l, "[") && endswith(l, "]")
            seccion = l[2:end-1]
            continue
        end
        clave, valor = occursin('=', l) ? split(l, '='; limit = 2) : (l, "")
        clave, valor = strip(clave), strip(valor)
        if seccion == "Common Infos"
            comun[clave] = valor
        elseif seccion == "Binary Infos"
            binario[clave] = valor
        elseif seccion == "Channel Infos" && startswith(clave, "Ch")
            push!(canales, parse(Int, clave[3:end]) => valor)
        end
    end
    sort!(canales; by = first)
    C = parse(Int, comun["NumberOfChannels"])
    length(canales) == C || throw(ArgumentError("se declaran $C canales y se describen $(length(canales))"))

    nombres = String[]
    resoluciones = Float64[]
    unidades = String[]
    for (_, desc) in canales
        campos = split(desc, ','; keepempty = true)
        push!(nombres, String(campos[1]))
        push!(resoluciones, length(campos) ≥ 3 && !isempty(strip(campos[3])) ? parse(Float64, campos[3]) : 1.0)
        push!(unidades, length(campos) ≥ 4 ? String(strip(campos[4])) : "")
    end

    return (
        archivo_datos = joinpath(dirname(ruta), comun["DataFile"]),
        orientacion = get(comun, "DataOrientation", "MULTIPLEXED"),
        C = C,
        N_declaradas = haskey(comun, "DataPoints") ? parse(Int, comun["DataPoints"]) : nothing,
        intervalo_us = parse(Float64, comun["SamplingInterval"]),
        formato = get(binario, "BinaryFormat", "IEEE_FLOAT_32"),
        canales = nombres,
        resoluciones = resoluciones,
        unidades = unidades,
    )
end

"""Etapa 1 · I/O: lee el archivo binario completo."""
leer_bytes(ruta::AbstractString) = read(ruta)

"""
Etapa 2 · Decodificación: interpreta los bytes como valores `T` little-endian
y devuelve la matriz C × n de las `n` muestras completas (sin escalar).
"""
# FRAGMENTO: etapas
function decodificar(bytes::Vector{UInt8}, ::Type{T}, C::Integer) where {T}
    bps = sizeof(T)
    n = length(bytes) ÷ (C * bps)                 # muestras completas
    n ≥ 1 || throw(ArgumentError("el archivo no contiene ninguna muestra completa"))
    v = ltoh.(reinterpret(T, view(bytes, 1:n*C*bps)))
    return matriz_multiplexada(v, C)              # F01: x[c, n] = v[(n-1)C + c]
end

"""Etapa 3 · Calibración: x_µV[c, n] = Float64(raw[c, n]) · resolución[c]."""
calibrar(crudo::AbstractMatrix, resoluciones::AbstractVector) = Float64.(crudo) .* resoluciones
# FIN: etapas

"""
    leer_brainvision(ruta_vhdr) -> (datos_uV, fs, canales, avisos)

Lee un registro BrainVision según el contrato N01. Devuelve la señal en µV
(canales × muestras), la frecuencia de muestreo en Hz, los nombres de los
canales y los avisos emitidos.
"""
function leer_brainvision(ruta::AbstractString)
    cab = leer_cabecera(ruta)
    cab.orientacion == "MULTIPLEXED" ||
        throw(ArgumentError("orientación $(cab.orientacion) no admitida (solo MULTIPLEXED)"))
    haskey(FORMATOS, cab.formato) || throw(ArgumentError("formato $(cab.formato) no admitido"))
    for u in cab.unidades
        u in UNIDADES_MICROVOLTIO || throw(ArgumentError("unidad «$u» no admitida (solo µV)"))
    end
    T = FORMATOS[cab.formato]
    bytes = leer_bytes(cab.archivo_datos)
    crudo = decodificar(bytes, T, cab.C)

    avisos = String[]
    bloque = cab.C * sizeof(T)
    if length(bytes) % bloque != 0
        push!(avisos, "archivo truncado: se descartan $(length(bytes) % bloque) bytes de una muestra incompleta")
    end
    n = size(crudo, 2)
    if cab.N_declaradas !== nothing && n != cab.N_declaradas
        push!(avisos, "se declaran $(cab.N_declaradas) muestras y hay $n completas")
    end
    foreach(a -> @warn(a), avisos)

    return (datos_uV = calibrar(crudo, cab.resoluciones), fs = 1e6 / cab.intervalo_us,
            canales = cab.canales, avisos = avisos)
end

end # module
