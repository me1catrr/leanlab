import LeanlabBook.F01.Indice

/-! Ejecutable `f01_tabla N C`: imprime en JSON la tabla `[[n, c, idx], …]`
de la especificación `LeanlabBook.F01.tabla`. Es el oráculo Lean de la
comparación cruzada (CROSS) con Julia y NumPy. -/

open LeanlabBook.F01

def main (args : List String) : IO UInt32 := do
  match args.map String.toNat? with
  | [some N, some C] =>
    let filas := (tabla N C).map fun (n, c, k) => s!"[{n},{c},{k}]"
    IO.println ("[" ++ ",".intercalate filas ++ "]")
    return 0
  | _ =>
    IO.eprintln "uso: f01_tabla N C"
    return 1
