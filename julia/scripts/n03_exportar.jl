# Exporta los resultados Julia de N03 para la comparación cruzada.
# Uso: julia --project=julia julia/scripts/n03_exportar.jl
using LeanlabJulia.N03Filtrado
using DSP

const RAIZ = normpath(joinpath(@__DIR__, "..", ".."))
const DIR = joinpath(RAIZ, "verification", "N03")
mkpath(joinpath(DIR, "julia"))

leer_f64(n) = collect(ltoh.(reinterpret(Float64, read(joinpath(DIR, "senales", n * ".f64")))))
num(x) = repr(Float64(x))
lista(v) = "[" * join(num.(v), ", ") * "]"

function leer_entrada(nombre)
    r(s) = (p = split(strip(s), '/'); length(p) == 1 ? parse(BigInt, p[1]) // 1 : parse(BigInt, p[1]) // parse(BigInt, p[2]))
    l = readlines(joinpath(DIR, "senales", nombre * "_entrada.txt"))
    return r(l[1]), r(l[2]), r.(l[3:end])
end

# Parte A · error de Float64 frente al exacto (a2).
α, y0, x = leer_entrada("a2")
err = abs.(filtro_un_polo(Float64(α), Float64.(x); y0 = Float64(y0)) .- Float64.(filtro_un_polo(α, x; y0 = y0)))
write(joinpath(DIR, "julia", "a2_error.json"),
      """{"N": $(length(err)), "error_max": $(num(maximum(err))), "error_en": {"10": $(num(err[10])), "100": $(num(err[100])), "1000": $(num(err[1000])), "2000": $(num(err[2000]))}}\n""")

# Parte B · Butterworth.
f = butterworth(4, 40, 500)
zpk = ZeroPoleGain(digitalfilter(Lowpass(40), Butterworth(4); fs = 500))
frecs = range(0, 250; length = 512)
H = freqresp(f, 2π .* frecs ./ 500)
b1 = leer_f64("b1"); imp = leer_f64("impulso")
write(joinpath(DIR, "julia", "butter.json"), """{
 "polos_re": $(lista(real.(zpk.p))), "polos_im": $(lista(imag.(zpk.p))),
 "ceros_re": $(lista(real.(zpk.z))), "ceros_im": $(lista(imag.(zpk.z))), "ganancia": $(num(zpk.k)),
 "sos_dsp": [$(join(["[" * join(num.([b.b0, b.b1, b.b2, 1.0, b.a1, b.a2]), ", ") * "]" for b in f.biquads], ", "))], "sos_ganancia_global": $(num(f.g)),
 "frecuencias_Hz": $(lista(frecs)), "modulo_H": $(lista(abs.(H))),
 "b1_una_pasada": $(lista(filt(f, b1))), "b1_fase_cero": $(lista(filtfilt(f, b1))),
 "impulso": $(lista(filt(f, imp)))
}
""")
println("Resultados Julia de N03 en ", joinpath(DIR, "julia"))
