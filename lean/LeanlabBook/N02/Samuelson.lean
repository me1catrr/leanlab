module

public import Mathlib.Tactic
public import Mathlib.Algebra.Order.Chebyshev

@[expose] public section

/-!
# N02 · Cota de Samuelson para los z-scores de un control de calidad

Muchos controles de calidad de EEG marcan como «atípico» un canal cuyo
z-score supera un umbral, por ejemplo `|z| > 3`. Con la desviación típica
**poblacional** (denominador `n`), la desigualdad de Samuelson acota todos
los z-scores posibles:

    z_j² ≤ n − 1,    es decir,    |z_j| ≤ √(n − 1).

Consecuencia práctica (**N02-P01**): con `n ≤ 10` canales, **ningún** canal
puede superar `|z| > 3`, por grande que sea su amplitud. Con 11 canales ya
puede ocurrir (se demuestra con un ejemplo concreto).

Lo que este fichero NO demuestra: nada sobre la implementación en `Float64`,
ni sobre otras definiciones de z-score (por ejemplo, con denominador `n − 1`,
cuya cota es `(n − 1)/√n`).
-/

namespace LeanlabBook.N02

open Finset

/-- Media aritmética de `n` valores. -/
noncomputable def media {n : ℕ} (x : Fin n → ℝ) : ℝ := (∑ i, x i) / n

/-- Suma de cuadrados de las desviaciones respecto a la media
(`n` veces la varianza poblacional). -/
noncomputable def sumaCuadrados {n : ℕ} (x : Fin n → ℝ) : ℝ := ∑ i, (x i - media x) ^ 2

/-- **Samuelson para desviaciones de suma nula.** Si `∑ d = 0`, entonces
`n · d_j² ≤ (n − 1) · ∑ d²`. La prueba usa Cauchy–Schwarz sobre los demás
`n − 1` términos, cuya suma es `−d_j`. -/
theorem samuelson_desv {n : ℕ} (d : Fin n → ℝ) (h0 : ∑ i, d i = 0) (j : Fin n) :
    (n : ℝ) * d j ^ 2 ≤ ((n : ℝ) - 1) * ∑ i, d i ^ 2 := by
  have hj : j ∈ (univ : Finset (Fin n)) := mem_univ j
  have hsum : d j + ∑ i ∈ univ.erase j, d i = 0 := by rw [add_sum_erase _ _ hj]; exact h0
  have hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2 :=
    (add_sum_erase _ (fun i => d i ^ 2) hj).symm
  have hcard : ((#(univ.erase j) : ℕ) : ℝ) = (n : ℝ) - 1 := by
    rw [card_erase_of_mem hj, card_univ, Fintype.card_fin]
    have : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr (by rintro rfl; exact j.elim0)
    push_cast [this]
    ring
  have cs := sq_sum_le_card_mul_sum_sq (s := univ.erase j) (f := d)
  rw [hcard] at cs
  have hneg : ∑ i ∈ univ.erase j, d i = -d j := by linarith
  rw [hneg, neg_sq] at cs
  rw [hsq]
  nlinarith [cs]

/-- **Desigualdad de Samuelson.** `n · (x_j − x̄)² ≤ (n − 1) · ∑ (x_i − x̄)²`. -/
theorem samuelson {n : ℕ} (x : Fin n → ℝ) (j : Fin n) :
    (n : ℝ) * (x j - media x) ^ 2 ≤ ((n : ℝ) - 1) * sumaCuadrados x := by
  have hn : (n : ℝ) ≠ 0 := by
    have : 0 < n := Nat.pos_of_ne_zero (by rintro rfl; exact j.elim0)
    exact_mod_cast this.ne'
  apply samuelson_desv (fun i => x i - media x) _ j
  rw [sum_sub_distrib, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul, media]
  field_simp
  ring

/-- **Cota de los z-scores.** Con varianza poblacional `σ² = S/n > 0`,
el z-score de cualquier canal cumple `z_j² ≤ n − 1`. -/
theorem z_cuadrado_le {n : ℕ} (x : Fin n → ℝ) (j : Fin n) (hS : 0 < sumaCuadrados x) :
    (x j - media x) ^ 2 / (sumaCuadrados x / n) ≤ (n : ℝ) - 1 := by
  have hn : (0 : ℝ) < n := by
    have : 0 < n := Nat.pos_of_ne_zero (by rintro rfl; exact j.elim0)
    exact_mod_cast this
  have h := samuelson x j
  rw [div_div_eq_mul_div, div_le_iff₀ hS]
  linarith

/-- **N02-P01 · Con 10 canales o menos, `|z| > 3` es imposible.**
Para `n ≤ 10`: `(x_j − x̄)² ≤ 9 · σ²`, con `σ² = S/n` la varianza poblacional. -/
theorem z_le_tres {n : ℕ} (x : Fin n → ℝ) (j : Fin n) (hn10 : n ≤ 10) :
    (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / n) := by
  have hn : (0 : ℝ) < n := by
    have : 0 < n := Nat.pos_of_ne_zero (by rintro rfl; exact j.elim0)
    exact_mod_cast this
  have h := samuelson x j
  have hS : 0 ≤ sumaCuadrados x := sum_nonneg fun i _ => sq_nonneg _
  have h10 : (n : ℝ) ≤ 10 := by exact_mod_cast hn10
  rw [mul_div_assoc', le_div_iff₀ hn]
  nlinarith

/-- **N02-P01 (b) · La cota es ajustada en el umbral: con 11 canales sí puede
ocurrir.** Para `x = (1, 0, …, 0)` con 11 canales, `z_0² = 10 > 9`. -/
theorem once_canales_basta :
    let x : Fin 11 → ℝ := fun i => if i = 0 then 1 else 0
    (x 0 - media x) ^ 2 > 9 * (sumaCuadrados x / 11) := by
  intro x
  simp only [x, sumaCuadrados, media, Fin.sum_univ_succ, Fin.sum_univ_zero]
  norm_num

end LeanlabBook.N02
