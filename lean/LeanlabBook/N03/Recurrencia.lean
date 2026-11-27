module

public import Mathlib.Tactic

@[expose] public section

/-!
# N03 · Filtro recursivo de un polo

    y[n] = α · x[n] + (1 − α) · y[n − 1],     y[−1] = y₀,     0 < α ≤ 1.

Es el filtro paso bajo más sencillo (media móvil exponencial). Se demuestran,
sobre ℝ:

* **N03-P01 · Acotación (estabilidad BIBO).** Si la entrada y el estado
  inicial están acotados por `M`, la salida también.
* **N03-P02 · Causalidad.** La salida en `n` solo depende de `x[0..n]`.
* **N03-P03 · Ganancia en continua.** Con entrada constante `c` y `y₀ = c`,
  la salida es exactamente `c`.
* **N03-P04 · Transitorio exacto.** Con entrada constante `c`,
  `y[n] − c = (1 − α)^(n+1) · (y₀ − c)`.

También se define la versión ejecutable sobre ℚ (`filtroQ`), oráculo exacto
de la comparación con Julia. Lo que NO se demuestra: nada sobre `Float64`,
ni sobre el filtro Butterworth de la segunda parte del capítulo.
-/

namespace LeanlabBook.N03

/-- Salida del filtro de un polo con coeficiente `α`, entrada `x` y estado
inicial `y₀` (que hace de `y[−1]`). -/
noncomputable def filtro (α : ℝ) (x : ℕ → ℝ) (y₀ : ℝ) : ℕ → ℝ
  | 0 => α * x 0 + (1 - α) * y₀
  | n + 1 => α * x (n + 1) + (1 - α) * filtro α x y₀ n

/-- Paso clave: una combinación convexa de dos valores acotados por `M`
está acotada por `M`. -/
theorem convexa_acotada {α a b M : ℝ} (h0 : 0 ≤ α) (h1 : α ≤ 1)
    (ha : |a| ≤ M) (hb : |b| ≤ M) : |α * a + (1 - α) * b| ≤ M := by
  calc |α * a + (1 - α) * b| ≤ |α * a| + |(1 - α) * b| := abs_add_le _ _
    _ = α * |a| + (1 - α) * |b| := by
        rw [abs_mul, abs_mul, abs_of_nonneg h0, abs_of_nonneg (sub_nonneg.mpr h1)]
    _ ≤ α * M + (1 - α) * M :=
        add_le_add (mul_le_mul_of_nonneg_left ha h0) (mul_le_mul_of_nonneg_left hb (sub_nonneg.mpr h1))
    _ = M := by ring

/-- **N03-P01 · Acotación.** Con `0 ≤ α ≤ 1`, `|x[n]| ≤ M` para todo `n` y
`|y₀| ≤ M`, se cumple `|y[n]| ≤ M` para todo `n`. -/
theorem filtro_acotado {α M y₀ : ℝ} {x : ℕ → ℝ} (h0 : 0 ≤ α) (h1 : α ≤ 1)
    (hx : ∀ n, |x n| ≤ M) (hy : |y₀| ≤ M) : ∀ n, |filtro α x y₀ n| ≤ M := by
  intro n
  induction n with
  | zero => exact convexa_acotada h0 h1 (hx 0) hy
  | succ n ih => exact convexa_acotada h0 h1 (hx (n + 1)) ih

/-- **N03-P02 · Causalidad.** Si dos entradas coinciden hasta `n`, las
salidas coinciden en `n`. -/
theorem filtro_causal {α y₀ : ℝ} {x x' : ℕ → ℝ} (n : ℕ)
    (h : ∀ k ≤ n, x k = x' k) : filtro α x y₀ n = filtro α x' y₀ n := by
  induction n with
  | zero => simp [filtro, h 0 le_rfl]
  | succ n ih =>
    simp only [filtro]
    rw [h (n + 1) le_rfl, ih (fun k hk => h k (Nat.le_succ_of_le hk))]

/-- **N03-P04 · Transitorio exacto.** Con entrada constante `c`:
`y[n] − c = (1 − α)^(n+1) · (y₀ − c)`. -/
theorem filtro_transitorio (α c y₀ : ℝ) (n : ℕ) :
    filtro α (fun _ => c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c) := by
  induction n with
  | zero => simp [filtro]; ring
  | succ n ih =>
    simp only [filtro] at ih ⊢
    rw [pow_succ]
    linear_combination (1 - α) * ih

/-- **N03-P03 · Ganancia en continua.** Con entrada constante `c` y `y₀ = c`,
la salida es exactamente `c`. -/
theorem filtro_continua (α c : ℝ) (n : ℕ) : filtro α (fun _ => c) c n = c := by
  have h := filtro_transitorio α c c n
  simp at h
  linarith

/-- Versión ejecutable sobre ℚ: devuelve la lista de salidas para una lista
de entradas. Es el oráculo exacto de la comparación con Julia. -/
def filtroQ (α : ℚ) (y₀ : ℚ) : List ℚ → List ℚ
  | [] => []
  | x :: xs =>
    let y := α * x + (1 - α) * y₀
    y :: filtroQ α y xs

end LeanlabBook.N03
