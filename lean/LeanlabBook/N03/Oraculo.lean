import LeanlabBook.N03.Recurrencia

/-! Ejecutable `n03_filtro`: lee de la entrada estándar
    línea 1: α        (racional «p/q» o entero)
    línea 2: y₀
    resto:   una muestra de x por línea
y escribe la salida exacta del filtro de un polo, un racional «p/q» por línea.
Es el oráculo exacto de N03 para la comparación con Julia. -/

open LeanlabBook.N03

def leerRacional (s : String) : Option ℚ :=
  match (s.trimAscii.toString.splitOn "/") with
  | [p] => (p.toInt?).map (fun z => (z : ℚ))
  | [p, q] => do
    let a ← p.toInt?
    let b ← q.toNat?
    if b = 0 then none else some ((a : ℚ) / (b : ℚ))
  | _ => none

def mostrar (q : ℚ) : String := s!"{q.num}/{q.den}"

def main : IO UInt32 := do
  let entrada ← (← IO.getStdin).readToEnd
  let lineas := (entrada.splitOn "\n").filter (fun l => !l.trimAscii.isEmpty)
  match lineas.map leerRacional with
  | some α :: some y₀ :: resto =>
    match resto.mapM id with
    | some xs =>
      for y in filtroQ α y₀ xs do
        IO.println (mostrar y)
      return 0
    | none => IO.eprintln "muestra no válida"; return 1
  | _ => IO.eprintln "uso: α, y₀ y una muestra por línea (racionales p/q)"; return 1
