<!-- Generado por scripts/fragmento_codigo.py. No editar a mano. -->

```{.julia filename="julia/test/n01.jl"}
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
```
