# TEST de N02 · control de calidad (incluido desde runtests.jl)
#
# Necesita los datos sintéticos: uv run --project python python scripts/n02_datos.py
# Oráculo: etiquetas exactas de verification/N02/esperado/*.etiquetas.txt.

using LeanlabJulia.N02Calidad
using Random, Statistics

const DIR_N02 = joinpath(RAIZ, "verification", "N02")
const CONJUNTOS_N02 = ("d1_mixto", "d2_ocho_canales", "d3_once_canales", "d4_identicos", "d5_plano_parcial")

"""Lee una matriz de N02 (Float64 little-endian, canal tras canal) como C × N."""
function leer_n02(nombre)
    meta = Dict(split(l, '=') |> p -> (p[1] => p[2]) for l in eachline(joinpath(DIR_N02, "datos", nombre * ".meta")))
    C, N = parse(Int, meta["C"]), parse(Int, meta["N"])
    v = ltoh.(reinterpret(Float64, read(joinpath(DIR_N02, "datos", nombre * ".f64"))))
    return permutedims(reshape(collect(v), N, C))
end

leer_etiquetas(nombre) = [Symbol.(filter(!isempty, split(strip(split(l, ':'; limit = 2)[2]), ',')))
                          for l in eachline(joinpath(DIR_N02, "esperado", nombre * ".etiquetas.txt"))]

"""¿Coinciden las etiquetas de una función de QC con el oráculo en todos los conjuntos?"""
function acierta_todo(qc)
    all(CONJUNTOS_N02) do nombre
        sort.(qc(leer_n02(nombre)).etiquetas) == sort.(leer_etiquetas(nombre))
    end
end

@testset "N02 · control de calidad" begin

    @testset "Etiquetas frente al oráculo exacto" begin
        for nombre in CONJUNTOS_N02
            r = control_calidad(leer_n02(nombre))
            @test sort.(r.etiquetas) == sort.(leer_etiquetas(nombre))
        end
    end

    @testset "Cota de Samuelson en los datos (N02-P01)" begin
        r2 = control_calidad(leer_n02("d2_ocho_canales"))
        @test r2.n_canales_z == 8
        @test maximum(abs, r2.z) ≤ sqrt(7) * (1 + 1e-12)
        @test isempty(reduce(vcat, r2.etiquetas))           # 45 veces mayor y sin marcar
        r3 = control_calidad(leer_n02("d3_once_canales"))
        @test r3.z[11] ≈ sqrt(10) rtol = 1e-12               # z = √10 exactamente
    end

    @testset "Cota de Samuelson con datos aleatorios (propiedad)" begin
        rng = Xoshiro(20261126)
        for _ in 1:2000
            C = rand(rng, 2:40)
            X = randn(rng, C, 64) .* exp.(3 .* randn(rng, C))   # amplitudes muy dispares
            r = control_calidad(X)
            zs = filter(isfinite, r.z)
            r.n_canales_z ≥ 2 && !isempty(zs) || continue     # muy pocos canales no planos
            @test maximum(abs, zs) ≤ sqrt(r.n_canales_z - 1) * (1 + 1e-12)
        end
    end

    @testset "Casos degenerados y pureza" begin
        r4 = control_calidad(leer_n02("d4_identicos"))
        @test all(isnan, r4.z)                                  # dispersión 0: sin z
        X = leer_n02("d1_mixto"); copia = copy(X)
        control_calidad(X)
        @test isequal(X, copia)                                 # N02-C06 (isequal: NaN = NaN)
    end

    @testset "Mutaciones" begin
# FRAGMENTO: mutaciones_n02
        # Errores típicos, escritos como variantes del contrato:
        sin_excluir_no_validos(X) = control_calidad(replace(X, NaN => 0.0))
        umbral_mayor_o_igual(X) = control_calidad(X; umbral_z = prevfloat(3.0))
        z_sobre_todos(X) = control_calidad(X; umbral_plano = -Inf)   # los planos entran en z
        @test !acierta_todo(sin_excluir_no_validos)
        @test !acierta_todo(z_sobre_todos)
# FIN: mutaciones_n02
        # Mutante SUPERVIVIENTE: ningún conjunto del protocolo distingue «>» de «≥»
        # en el umbral. Es un hueco conocido de las pruebas, no un acierto.
        @test acierta_todo(umbral_mayor_o_igual)
    end
end
