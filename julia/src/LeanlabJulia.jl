"""
    LeanlabJulia

Código Julia original de LEANLAB (licencia MIT). Un submódulo por propiedad:
`F01Indice` implementa F01-P01.
"""
module LeanlabJulia

include("F01Indice.jl")
using .F01Indice
export F01Indice

include("N01BrainVision.jl")
using .N01BrainVision
export N01BrainVision

include("N02Calidad.jl")
using .N02Calidad
export N02Calidad

end # module
