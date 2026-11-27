# TEST de F01-P01 · `julia --project=julia julia/test/runtests.jl`
#
# Comprueba la implementación Julia frente a la especificación (base uno) y
# demuestra que las pruebas detectan errores típicos (mutaciones). Las mismas
# propiedades están demostradas en Lean sobre ℕ; aquí se ensayan sobre `Int`.

using Test
using LeanlabJulia.F01Indice

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))

"""Contrato de F01-P01 para una función índice `f(C, n, c)` (base uno),
comprobado exhaustivamente para un registro N × C."""
function cumple_contrato(f, N, C)
    vistos = Set{Int}()
    for n in 1:N, c in 1:C
        k = f(C, n, c)
        1 ≤ k ≤ N * C || return false        # acotación
        k ∈ vistos && return false            # inyectividad
        push!(vistos, k)
    end
    return length(vistos) == N * C            # cobertura
end

"""Lee la tabla del oráculo Lean `[[n,c,k],…]` (base cero)."""
function leer_tabla(ruta)
    nums = parse.(Int, split(replace(read(ruta, String), r"[\[\]\s]" => " "), r"[ ,]+"; keepempty = false))
    return [Tuple(nums[i:i+2]) for i in 1:3:length(nums)]
end

@testset "F01-P01 · índice MULTIPLEXED" begin

    @testset "Ejemplo 3 canales × 4 muestras" begin
        @test indice(3, 1, 1) == 1
        @test indice(3, 1, 3) == 3
        @test indice(3, 2, 1) == 4
        @test indice(3, 4, 3) == 12
        @test canal_y_muestra(3, 4) == (2, 1)
    end

    @testset "Contrato exhaustivo (acotación, inyectividad, cobertura)" begin
        for N in 1:12, C in 1:12
            @test cumple_contrato(indice, N, C)
        end
    end

    @testset "Inversa" begin
        for C in 1:9, k in 1:200
            n, c = canal_y_muestra(C, k)
            @test indice(C, n, c) == k
        end
    end

    @testset "Matriz canales × muestras sin copia" begin
        v = collect(1:12)
        M = matriz_multiplexada(v, 3)
        @test size(M) == (3, 4)
        @test M[:, 1] == [1, 2, 3]            # la muestra 1 de los tres canales
        @test M[2, :] == [2, 5, 8, 11]        # el canal 2 a lo largo del tiempo
        for n in 1:4, c in 1:3
            @test M[c, n] == v[indice(3, n, c)]
        end
        @test Base.mightalias(M, v)           # comparte memoria con v (vista)
        @test !Base.mightalias(matriz_copia(v, 3), v)
        @test_throws ArgumentError matriz_multiplexada(collect(1:10), 3)
    end

    @testset "Precondiciones" begin
        @test_throws ArgumentError indice(3, 0, 1)
        @test_throws ArgumentError indice(3, 1, 4)
        @test_throws ArgumentError indice(0, 1, 1)
    end

    @testset "Desbordamiento de Int (no existe en ℕ)" begin
        C = 2
        n = typemax(Int) ÷ C + 2
        @test indice(C, n, 1) < 0             # Int64 da la vuelta en silencio
        @test_throws OverflowError indice_comprobado(C, n, 1)
    end

    @testset "Mutaciones que las pruebas deben detectar" begin
# FRAGMENTO: mutaciones
        intercambio(C, n, c) = (c - 1) * C + n          # n y c intercambiados
        base_cero(C, n, c) = n * C + c                  # olvida restar 1 (base)
        vectorizada(C, n, c) = (c - 1) * 4 + n          # orientación por canal con N fijo
        @test !cumple_contrato(intercambio, 4, 3)
        @test !cumple_contrato(base_cero, 4, 3)
        @test !cumple_contrato(vectorizada, 5, 3)
# FIN: mutaciones
        # Una matriz de dimensiones correctas puede tener orientación incorrecta:
        v = collect(1:12)
        @test size(permutedims(reshape(v, 4, 3))) == (3, 4)
        @test permutedims(reshape(v, 4, 3)) != matriz_multiplexada(v, 3)
    end

    @testset "Correspondencia con el oráculo Lean (base cero)" begin
        dir = joinpath(RAIZ, "verification", "F01", "oraculo_lean")
        tamanos = [(4, 3), (1, 1), (7, 5), (3, 31)]
        for (N, C) in tamanos
            tabla = leer_tabla(joinpath(dir, "tabla_$(N)x$(C).json"))
            @test length(tabla) == N * C
            for (n0, c0, k0) in tabla
                @test indice(C, n0 + 1, c0 + 1) == k0 + 1
            end
        end
    end
end

include("n01.jl")

include("n02.jl")
