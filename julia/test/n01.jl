# TEST de N01 · lector BrainVision (incluido desde runtests.jl)
#
# Necesita los ficheros sintéticos: uv run --project python python scripts/n01_ficheros.py
# Oráculo: el resultado analítico exacto de verification/N01/esperado/*.json.

using LeanlabJulia.N01BrainVision

const DIR_N01 = joinpath(RAIZ, "verification", "N01")
fichero(nombre) = joinpath(DIR_N01, "ficheros", nombre * ".vhdr")

"""Lee el JSON esperado (formato fijo generado por scripts/n01_ficheros.py)."""
function leer_esperado(nombre)
    s = read(joinpath(DIR_N01, "esperado", nombre * ".json"), String)
    campo(k) = match(Regex("\"$k\":\\s*([^,\\n]+)"), s).captures[1]
    C = parse(Int, campo("C"))
    N = parse(Int, campo("N"))
    fs = parse(Float64, campo("fs_Hz"))
    bloque = s[findfirst("\"datos_uV\"", s)[end]+1:end]
    nums = parse.(Float64, [m.match for m in eachmatch(r"-?\d+(\.\d+)?(e-?\d+)?", bloque)])
    return (C = C, N = N, fs = fs, datos = permutedims(reshape(nums, N, C)))
end

"""¿Coincide la lectura con el resultado analítico (tolerancia del protocolo)?"""
function coincide(datos, esp; rtol = 1e-12)
    size(datos) == (esp.C, esp.N) || return false
    return all(isapprox.(datos, esp.datos; rtol = rtol, atol = 0.0))
end

@testset "N01 · lector BrainVision" begin

    @testset "Ficheros sintéticos presentes" begin
        for f in ("f1_float32", "f2_int16", "f3_truncado", "f4_vectorizado", "f5_milivoltios", "f6_fs_no_entera")
            @test isfile(fichero(f))
        end
    end

    @testset "N01-C01/C02/C04 · lectura frente al resultado analítico" begin
        for f in ("f1_float32", "f2_int16", "f6_fs_no_entera")
            r = leer_brainvision(fichero(f))
            esp = leer_esperado(f)
            @test coincide(r.datos_uV, esp)
            @test isempty(r.avisos)
        end
        @test leer_brainvision(fichero("f1_float32")).datos_uV == leer_esperado("f1_float32").datos  # exacto
    end

    @testset "N01-C06 · frecuencia no entera" begin
        r = leer_brainvision(fichero("f6_fs_no_entera"))
        @test r.fs ≈ 1e6 / 3 rtol = 1e-12
        @test !isinteger(r.fs)
    end

    @testset "N01-C07 · archivo truncado" begin
        r = @test_logs (:warn,) (:warn,) leer_brainvision(fichero("f3_truncado"))
        @test size(r.datos_uV) == (3, 3)
        @test coincide(r.datos_uV, leer_esperado("f3_truncado"))
        @test length(r.avisos) == 2
        @test_throws ArgumentError decodificar(UInt8[0x00, 0x01], Float32, 3)   # ninguna completa
    end

    @testset "N01-C02/C05 · rechazos por contrato" begin
        @test_throws ArgumentError leer_brainvision(fichero("f4_vectorizado"))
        @test_throws ArgumentError leer_brainvision(fichero("f5_milivoltios"))
    end

    @testset "Mutaciones que las pruebas deben detectar" begin
# FRAGMENTO: mutaciones_n01
        cab = leer_cabecera(fichero("f2_int16"))
        bytes = leer_bytes(cab.archivo_datos)
        crudo = decodificar(bytes, Int16, cab.C)
        esp = leer_esperado("f2_int16")
        sin_resolucion = Float64.(crudo)                                  # olvida calibrar
        en_voltios = calibrar(crudo, cab.resoluciones) .* 1e-6            # unidades de MNE
        big_endian = calibrar(ntoh.(crudo), cab.resoluciones)             # orden de bytes
        orientacion = calibrar(permutedims(reshape(vec(crudo), 4, 3)), cab.resoluciones)
        @test !coincide(sin_resolucion, esp)
        @test !coincide(en_voltios, esp)          # ¡seis órdenes de magnitud!
        @test !coincide(big_endian, esp)
        @test !coincide(orientacion, esp)
# FIN: mutaciones_n01
        @test coincide(calibrar(crudo, cab.resoluciones), esp)            # la versión correcta
    end

    @testset "Aritmética exacta frente a Float64: (raw·r)·s frente a raw·(r·s)" begin
        # En ℝ el producto es asociativo (demostrado en Lean, N01-P03).
        # En Float64 no siempre: se buscan contraejemplos en todo el rango de Int16.
        r, s = 0.1, 1e-6
        distintos = [x for x in -32768:32767 if (Float64(x) * r) * s != Float64(x) * (r * s)]
        @test !isempty(distintos)
        x = first(distintos)
        a, b = (x * r) * s, x * (r * s)
        @test a != b
        @test isapprox(a, b; rtol = 1e-15)        # pero la diferencia es de redondeo
        println("  Contraejemplo Float64: x = $x, (x·0.1)·1e-6 = $a, x·(0.1·1e-6) = $b; ",
                "$(length(distintos)) de 65536 valores de Int16 difieren")
    end
end
