module

public import Mathlib.Tactic
public import LeanlabBook.F01.Indice

@[expose] public section

/-!
# N01 · Bytes, muestras completas y calibración

Un archivo BrainVision MULTIPLEXED con `C` canales y `b` bytes por valor
guarda el valor de la muestra `n` del canal `c` a partir del byte

    offset b C n c = idx C n c * b          (base cero; `idx` de F01).

Se demuestran tres propiedades:

* **N01-P01 · Acotación en bytes.** Ese valor cabe entero en un archivo de
  `N · C · b` bytes. Reutiliza la acotación de F01.
* **N01-P02 · Muestras completas.** En `L` bytes caben `L / (C·b)` muestras
  completas, y no cabe ninguna más.
* **N01-P03 · Calibración y unidades.** En ℝ da igual calibrar y luego pasar
  a voltios que hacerlo con un único factor: `(x·r)·s = x·(r·s)`. En `Float64`
  esto NO siempre se cumple (contraejemplo real en las pruebas de Julia).

Lo que este fichero NO demuestra: que un lector concreto calcule así las
posiciones, ni nada sobre el orden de bytes o la conversión a `Float32`.
-/

namespace LeanlabBook.N01

open LeanlabBook.F01

/-- Primer byte del valor de la muestra `n` del canal `c` (base cero),
con `b` bytes por valor. -/
def offset (b C n c : ℕ) : ℕ := idx C n c * b

/-- **N01-P01 · Acotación en bytes.** El valor completo (sus `b` bytes) cabe
en un archivo de `N · C · b` bytes. -/
theorem offset_add_le {N C n c : ℕ} (b : ℕ) (hn : n < N) (hc : c < C) :
    offset b C n c + b ≤ N * C * b := by
  unfold offset
  have h : idx C n c + 1 ≤ N * C := idx_lt hn hc
  calc idx C n c * b + b = (idx C n c + 1) * b := by ring
    _ ≤ N * C * b := Nat.mul_le_mul_right b h

/-- Número de muestras completas en un archivo de `L` bytes. -/
def completas (L C b : ℕ) : ℕ := L / (C * b)

/-- **N01-P02 (a) · Caben.** Las muestras completas ocupan como mucho `L` bytes. -/
theorem completas_caben (L C b : ℕ) : completas L C b * (C * b) ≤ L :=
  Nat.div_mul_le_self L (C * b)

/-- **N01-P02 (b) · Son todas.** Una muestra más ya no cabe en `L` bytes. -/
theorem completas_maximas {L C b : ℕ} (h : 0 < C * b) :
    L < (completas L C b + 1) * (C * b) := by
  unfold completas
  have h1 := Nat.div_add_mod L (C * b)
  have h2 := Nat.mod_lt L h
  nlinarith [h1, h2]

/-- **N01-P03 · Calibración y unidades en ℝ.** Calibrar (`r`, µV por unidad
cruda) y después pasar a voltios (`s = 10⁻⁶`) equivale a multiplicar por el
factor único `r · s`, como hacen otras bibliotecas. En `Float64`, en cambio,
el resultado puede diferir en el último bit. -/
theorem calibrar_asoc (x r s : ℝ) : (x * r) * s = x * (r * s) := mul_assoc x r s

end LeanlabBook.N01
