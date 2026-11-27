# TEST de N03 · filtrado (incluido desde runtests.jl)
#
# Necesita: uv run --project python python scripts/n03_senales.py
#           y la salida del oráculo Lean en verification/N03/oraculo_lean/a1.txt

using LeanlabJulia.N03Filtrado
using DSP, Random

const DIR_N03 = joinpath(RAIZ, "verification", "N03")

"""Lee una entrada «α, y₀, x…» en racionales exactos."""
function leer_entrada(nombre)
    r(s) = (p = split(strip(s), '/'); length(p) == 1 ? parse(BigInt, p[1]) // 1 : parse(BigInt, p[1]) // parse(BigInt, p[2]))
    l = readlines(joinpath(DIR_N03, "senales", nombre * "_entrada.txt"))
    return r(l[1]), r(l[2]), r.(l[3:end])
end
leer_f64(nombre) = collect(ltoh.(reinterpret(Float64, read(joinpath(DIR_N03, "senales", nombre * ".f64")))))

@testset "N03 · filtrado" begin

    @testset "Un polo · exacto: Julia Rational = oráculo Lean (ℚ)" begin
        α, y0, x = leer_entrada("a1")
        lean = [(p = split(l, '/'); parse(BigInt, p[1]) // parse(BigInt, p[2]))
                for l in readlines(joinpath(DIR_N03, "oraculo_lean", "a1.txt"))]
        @test filtro_un_polo(α, x; y0 = y0) == lean
    end

    @testset "Un polo · Float64 frente a exacto (a2, N = 2000)" begin
        α, y0, x = leer_entrada("a2")
        exacto = filtro_un_polo(α, x; y0 = y0)
        flotante = filtro_un_polo(Float64(α), Float64.(x); y0 = Float64(y0))
        err = abs.(flotante .- Float64.(exacto))
        @test maximum(err) ≤ 1e-12                                   # tolerancia del protocolo
        println("  Float64 frente a exacto (a2): error máximo = $(maximum(err)); ",
                "n = 10: $(err[10]), 100: $(err[100]), 1000: $(err[1000]), 2000: $(err[2000])")
    end

    @testset "Propiedades demostradas en Lean, ensayadas en Float64" begin
        rng = Xoshiro(27112026)
        for _ in 1:500
            α = rand(rng) * 0.999 + 0.001; M = 10 * rand(rng)
            x = (2 .* rand(rng, 300) .- 1) .* M; y0 = (2 * rand(rng) - 1) * M
            y = filtro_un_polo(α, x; y0 = y0)
            @test maximum(abs, y) ≤ M * (1 + 1e-12)                     # N03-P01 acotación
            k = rand(rng, 1:299)
            x2 = copy(x); x2[k+1:end] .= 0.0
            @test filtro_un_polo(α, x2; y0 = y0)[1:k] == y[1:k]       # N03-P02 causalidad
        end
        @test all(filtro_un_polo(0.3, fill(2.5, 100); y0 = 2.5) .≈ 2.5)  # N03-P03 continua
        y = filtro_un_polo(0.25, fill(1.0, 20); y0 = 0.0)
        @test all(y .- 1.0 .≈ [(0.75)^(n) * (0.0 - 1.0) for n in 1:20])  # N03-P04 transitorio
    end

    @testset "Butterworth de orden 4 (500 Hz, corte 40 Hz)" begin
        f = butterworth(4, 40, 500)
        @test length(f.biquads) == 2
        @test all(abs.(polos(f)) .< 1)                                  # estable
        H = freqresp(f, [0.0, 2π * 40 / 500])
        @test abs(H[1]) ≈ 1.0 rtol = 1e-10                              # ganancia en continua
        @test abs(H[2]) ≈ 1 / sqrt(2) rtol = 1e-10                      # −3 dB en el corte
    end

    @testset "Filtrado por bloques conserva el estado" begin
        f = butterworth(4, 40, 500)
        x = leer_f64("b1")
        @test filtrar_bloques(f, x, 137) ≈ filt(f, x) rtol = 1e-12
    end

    @testset "Mutaciones" begin
# FRAGMENTO: mutaciones_n03
        α, y0, x = leer_entrada("a1")
        lean = filtro_un_polo(α, x; y0 = y0)                            # = oráculo (ver arriba)
        coef_cambiados = filtro_un_polo(1 - α, x; y0 = y0)              # α y (1 − α) intercambiados
        corte_mal_normalizado = SecondOrderSections(digitalfilter(Lowpass(40 / 500), Butterworth(4)))
        reinicio_por_bloque(f, x, t) = reduce(vcat, [filt(f, x[i:min(i + t - 1, end)]) for i in 1:t:length(x)])
        f = butterworth(4, 40, 500); b1 = leer_f64("b1")
        @test coef_cambiados != lean
        @test !isapprox(abs(freqresp(corte_mal_normalizado, [2π * 40 / 500])[1]), 1 / sqrt(2); rtol = 1e-3)
        @test !isapprox(reinicio_por_bloque(f, b1, 137), filt(f, b1); rtol = 1e-6)
# FIN: mutaciones_n03
    end
end
