"""
    LeanlabJulia

Código Julia original de LEANLAB (licencia MIT). Un submódulo por propiedad:
`F01Indice` implementa F01-P01.
"""
module LeanlabJulia

include("F01Indice.jl")
using .F01Indice
export F01Indice

end # module
