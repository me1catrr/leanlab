module

public import Mathlib.Tactic

@[expose] public section

/-!
# F01-P01 · Del vector binario a la matriz multicanal

Un registro multicanal con disposición **MULTIPLEXED** guarda las muestras
intercaladas: primero los `C` canales de la muestra 0, después los `C`
canales de la muestra 1, y así sucesivamente. Con índices **en base cero**,
la muestra `n` del canal `c` ocupa la posición

    idx C n c = n * C + c,    con 0 ≤ n < N y 0 ≤ c < C.

Aquí se demuestran, sobre ℕ (sin límite de tamaño), cuatro propiedades:
acotación, recuperación del par (n, c), inyectividad y cobertura. También se
demuestra la correspondencia con el índice en **base uno** que usa Julia.

Lo que este fichero NO demuestra:
* que una implementación concreta en Julia o NumPy use esta fórmula (eso lo
  comprueban TEST y CROSS);
* nada sobre `Int64`: en ℕ no hay desbordamiento.
-/

namespace LeanlabBook.F01

/-- Índice lineal en base cero de la muestra `n` del canal `c`
en un registro MULTIPLEXED con `C` canales. -/
def idx (C n c : ℕ) : ℕ := n * C + c

/-- **F01-P01 · Acotación.** Si `n < N` y `c < C`, el índice cae dentro del
vector de longitud `N * C`. -/
theorem idx_lt {N C n c : ℕ} (hn : n < N) (hc : c < C) :
    idx C n c < N * C := by
  unfold idx
  calc n * C + c < n * C + C := by omega
    _ = (n + 1) * C := by ring
    _ ≤ N * C := Nat.mul_le_mul_right C hn

/-- El canal se recupera con el resto de la división por `C`. -/
theorem idx_mod {C n c : ℕ} (hc : c < C) : idx C n c % C = c := by
  unfold idx
  rw [Nat.add_comm, Nat.add_mul_mod_self_right, Nat.mod_eq_of_lt hc]

/-- La muestra se recupera con el cociente de la división por `C`. -/
theorem idx_div {C n c : ℕ} (hc : c < C) : idx C n c / C = n := by
  unfold idx
  have hC : 0 < C := by omega
  rw [Nat.add_comm, Nat.add_mul_div_right _ _ hC, Nat.div_eq_of_lt hc, Nat.zero_add]

/-- **Inyectividad.** Dos pares válidos distintos nunca comparten posición. -/
theorem idx_inj {C n c n' c' : ℕ} (hc : c < C) (hc' : c' < C)
    (h : idx C n c = idx C n' c') : n = n' ∧ c = c' := by
  constructor
  · rw [← idx_div (n := n) hc, ← idx_div (n := n') hc', h]
  · rw [← idx_mod (n := n) hc, ← idx_mod (n := n') hc', h]

/-- **Cobertura.** Toda posición del vector corresponde a un par válido. -/
theorem idx_surj {N C k : ℕ} (hk : k < N * C) :
    ∃ n c, n < N ∧ c < C ∧ idx C n c = k := by
  have hC : 0 < C := by
    rcases Nat.eq_zero_or_pos C with h | h
    · simp [h] at hk
    · exact h
  refine ⟨k / C, k % C, ?_, Nat.mod_lt k hC, ?_⟩
  · exact (Nat.div_lt_iff_lt_mul hC).2 hk
  · unfold idx
    rw [Nat.mul_comm]
    exact Nat.div_add_mod k C

/-- Índice en **base uno**, como en Julia: muestra `n ≥ 1`, canal `c ≥ 1`. -/
def idx1 (C n c : ℕ) : ℕ := (n - 1) * C + c

/-- **Correspondencia base uno ↔ base cero.** Desplazar ambos índices en uno
desplaza la posición en uno: `idx1 C (n+1) (c+1) = idx C n c + 1`. -/
theorem idx1_eq_idx_succ (C n c : ℕ) : idx1 C (n + 1) (c + 1) = idx C n c + 1 := by
  unfold idx1 idx
  simp only [Nat.add_sub_cancel]
  omega

/-- Especificación ejecutable: tabla `(n, c, idx)` de un registro `N × C`,
recorrida en el orden en que aparecen las muestras en el archivo. -/
def tabla (N C : ℕ) : List (ℕ × ℕ × ℕ) :=
  (List.range N).flatMap fun n => (List.range C).map fun c => (n, c, idx C n c)

end LeanlabBook.F01
