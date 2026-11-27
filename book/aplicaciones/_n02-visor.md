<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->
```{=html}
<div class="lean-visor">
<section class="lean-decl" id="visor-samuelson_desv">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **Samuelson para desviaciones de suma nula.** Si `∑ d = 0`, entonces
`n · d_j² ≤ (n − 1) · ∑ d²`. La prueba usa Cauchy–Schwarz sobre los demás
`n − 1` términos, cuya suma es `−d_j`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">samuelson_desv</span> <span class="lk-bracket">{</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">d</span> <span class="lk-delim">:</span> <span class="lk-const">Fin</span> <span class="lk-var">n</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">h0</span> <span class="lk-delim">:</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">=</span> <span class="lk-num">0</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">j</span> <span class="lk-delim">:</span> <span class="lk-const">Fin</span> <span class="lk-var">n</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">d</span> <span class="lk-var">j</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-operator">≤</span> <span class="lk-bracket">(</span><span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">-</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">have</span> <span class="lk-var">hj</span> <span class="lk-delim">:</span> <span class="lk-var">j</span> <span class="lk-operator">∈</span> <span class="lk-bracket">(</span><span class="lk-const">univ</span> <span class="lk-delim">:</span> <span class="lk-const">Finset</span> <span class="lk-bracket">(</span><span class="lk-const">Fin</span> <span class="lk-var">n</span><span class="lk-bracket">)</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lk-const">mem_univ</span> <span class="lk-var">j</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t5"><span class="lk-keyword">have</span> <span class="lk-var">hsum</span> <span class="lk-delim">:</span> <span class="lk-var">d</span> <span class="lk-var">j</span> <span class="lk-operator">+</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span> <span class="lk-operator">∈</span> <span class="lk-const">univ</span><span class="lk-delim">.</span><span class="lk-const">erase</span> <span class="lk-var">j</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">=</span> <span class="lk-num">0</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span> <span class="lean-tac" id="t4"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t3"><span class="lk-const">add_sum_erase</span> <span class="lk-wildcard">_</span> <span class="lk-wildcard">_</span> <span class="lk-var">hj</span><sup class="lean-tac-n">3</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">4</sup></span><span class="lk-separator">;</span> <span class="lk-keyword">exact</span> <span class="lk-var">h0</span><sup class="lean-tac-n">5</sup></span>
  <span class="lean-tac" id="t6"><span class="lk-keyword">have</span> <span class="lk-var">hsq</span> <span class="lk-delim">:</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-operator">=</span> <span class="lk-var">d</span> <span class="lk-var">j</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-operator">+</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span> <span class="lk-operator">∈</span> <span class="lk-const">univ</span><span class="lk-delim">.</span><span class="lk-const">erase</span> <span class="lk-var">j</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-delim">:=</span>
    <span class="lk-bracket">(</span><span class="lk-const">add_sum_erase</span> <span class="lk-wildcard">_</span> <span class="lk-bracket">(</span><span class="lk-keyword">fun</span> <span class="lk-var">i</span> <span class="lk-delim">=&gt;</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">^</span> <span class="lk-num">2</span><span class="lk-bracket">)</span> <span class="lk-var">hj</span><span class="lk-bracket">)</span><span class="lk-delim">.</span><span class="lk-const">symm</span><sup class="lean-tac-n">6</sup></span>
  <span class="lean-tac" id="t15"><span class="lk-keyword">have</span> <span class="lk-var">hcard</span> <span class="lk-delim">:</span> <span class="lk-bracket">(</span><span class="lk-bracket">(</span><span class="lk-unknown">#</span><span class="lk-bracket">(</span><span class="lk-const">univ</span><span class="lk-delim">.</span><span class="lk-const">erase</span> <span class="lk-var">j</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">=</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">-</span> <span class="lk-num">1</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span>
    <span class="lean-tac" id="t10"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t7"><span class="lk-const">card_erase_of_mem</span> <span class="lk-var">hj</span><span class="lk-separator">,</span><sup class="lean-tac-n">7</sup></span> <span class="lean-tac" id="t8"><span class="lk-const">card_univ</span><span class="lk-separator">,</span><sup class="lean-tac-n">8</sup></span> <span class="lean-tac" id="t9"><span class="lk-const">Fintype.card_fin</span><sup class="lean-tac-n">9</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">10</sup></span>
    <span class="lean-tac" id="t13"><span class="lk-keyword">have</span> <span class="lk-delim">:</span> <span class="lk-num">1</span> <span class="lk-operator">≤</span> <span class="lk-var">n</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.one_le_iff_ne_zero</span><span class="lk-delim">.</span><span class="lk-const">mpr</span> <span class="lk-bracket">(</span><span class="lean-tac" id="t11"><span class="lk-keyword">by</span><sup class="lean-tac-n">11</sup></span> <span class="lean-tac" id="t12"><span class="lk-keyword">rintro</span> <span class="lk-var">rfl</span><sup class="lean-tac-n">12</sup></span><span class="lk-separator">;</span> <span class="lk-keyword">exact</span> <span class="lk-var">j</span><span class="lk-delim">.</span><span class="lk-const">elim0</span><span class="lk-bracket">)</span><sup class="lean-tac-n">13</sup></span>
    <span class="lean-tac" id="t14"><span class="lk-keyword">push_cast</span> <span class="lk-bracket">[</span><span class="lk-var">this</span><span class="lk-bracket">]</span><sup class="lean-tac-n">14</sup></span>
    <span class="lk-keyword">ring</span><sup class="lean-tac-n">15</sup></span>
  <span class="lean-tac" id="t16"><span class="lk-keyword">have</span> <span class="lk-var">cs</span> <span class="lk-delim">:=</span> <span class="lk-const">sq_sum_le_card_mul_sum_sq</span> <span class="lk-bracket">(</span><span class="lk-unknown">s</span> <span class="lk-delim">:=</span> <span class="lk-const">univ</span><span class="lk-delim">.</span><span class="lk-const">erase</span> <span class="lk-var">j</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-unknown">f</span> <span class="lk-delim">:=</span> <span class="lk-var">d</span><span class="lk-bracket">)</span><sup class="lean-tac-n">16</sup></span>
  <span class="lean-tac" id="t18"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t17"><span class="lk-var">hcard</span><sup class="lean-tac-n">17</sup></span><span class="lk-bracket">]</span> <span class="lk-keyword">at</span> <span class="lk-var">cs</span><sup class="lean-tac-n">18</sup></span>
  <span class="lean-tac" id="t19"><span class="lk-keyword">have</span> <span class="lk-var">hneg</span> <span class="lk-delim">:</span> <span class="lk-unknown">∑</span> <span class="lk-var">i</span> <span class="lk-operator">∈</span> <span class="lk-const">univ</span><span class="lk-delim">.</span><span class="lk-const">erase</span> <span class="lk-var">j</span><span class="lk-separator">,</span> <span class="lk-var">d</span> <span class="lk-var">i</span> <span class="lk-operator">=</span> <span class="lk-operator">-</span><span class="lk-var">d</span> <span class="lk-var">j</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span> <span class="lk-keyword">linarith</span><sup class="lean-tac-n">19</sup></span>
  <span class="lean-tac" id="t22"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t20"><span class="lk-var">hneg</span><span class="lk-separator">,</span><sup class="lean-tac-n">20</sup></span> <span class="lean-tac" id="t21"><span class="lk-const">neg_sq</span><sup class="lean-tac-n">21</sup></span><span class="lk-bracket">]</span> <span class="lk-keyword">at</span> <span class="lk-var">cs</span><sup class="lean-tac-n">22</sup></span>
  <span class="lean-tac" id="t24"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t23"><span class="lk-var">hsq</span><sup class="lean-tac-n">23</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">24</sup></span>
  <span class="lk-keyword">nlinarith</span> <span class="lk-bracket">[</span><span class="lk-var">cs</span><span class="lk-bracket">]</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="2"><details><summary><code>have hj : j ∈ (univ : Finset (Fin n)) := mem_univ j</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="3"><details><summary><code>add_sum_erase _ _ hj</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
⊢ ∑ x, d x = 0</pre></details></li>
<li value="4"><details><summary><code>rw [add_sum_erase _ _ hj]</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
⊢ ∑ x, d x = 0</pre></details></li>
<li value="5"><details><summary><code>have hsum : d j + ∑ i ∈ univ.erase j, d i = 0 := by rw [add_sum_era…</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="6"><details><summary><code>have hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2 := …</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="7"><details><summary><code>card_erase_of_mem hj,</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑(#univ - 1) = ↑n - 1</pre></details></li>
<li value="8"><details><summary><code>card_univ,</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑(Fintype.card (Fin n) - 1) = ↑n - 1</pre></details></li>
<li value="9"><details><summary><code>Fintype.card_fin</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑(n - 1) = ↑n - 1</pre></details></li>
<li value="10"><details><summary><code>rw [card_erase_of_mem hj, card_univ, Fintype.card_fin]</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑(n - 1) = ↑n - 1</pre></details></li>
<li value="11"><details><summary><code>by</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ n ≠ 0</pre></details></li>
<li value="12"><details><summary><code>rintro rfl</code></summary><pre class="lean-estado">d : Fin 0 → ℝ
h0 : ∑ i, d i = 0
j : Fin 0
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
⊢ False</pre></details></li>
<li value="13"><details><summary><code>have : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr (by rintro rfl; exact j.…</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
this : 1 ≤ n
⊢ ↑(n - 1) = ↑n - 1</pre></details></li>
<li value="14"><details><summary><code>push_cast [this]</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
this : 1 ≤ n
⊢ ↑n - 1 = ↑n - 1</pre></details></li>
<li value="15"><details><summary><code>have hcard : ((#(univ.erase j) : ℕ) : ℝ) = (n : ℝ) - 1 := by rw [ca…</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="16"><details><summary><code>have cs := sq_sum_le_card_mul_sum_sq (s := univ.erase j) (f := d)</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : (∑ i ∈ univ.erase j, d i) ^ 2 ≤ ↑(#(univ.erase j)) * ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="17"><details><summary><code>hcard</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : (∑ i ∈ univ.erase j, d i) ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="18"><details><summary><code>rw [hcard] at cs</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : (∑ i ∈ univ.erase j, d i) ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="19"><details><summary><code>have hneg : ∑ i ∈ univ.erase j, d i = -d j := by linarith</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : (∑ i ∈ univ.erase j, d i) ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="20"><details><summary><code>hneg,</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : (-d j) ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="21"><details><summary><code>neg_sq</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : d j ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="22"><details><summary><code>rw [hneg, neg_sq] at cs</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : d j ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * ∑ i, d i ^ 2</pre></details></li>
<li value="23"><details><summary><code>hsq</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : d j ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * (d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2)</pre></details></li>
<li value="24"><details><summary><code>rw [hsq]</code></summary><pre class="lean-estado">n : ℕ
d : Fin n → ℝ
h0 : ∑ i, d i = 0
j : Fin n
hj : j ∈ univ
hsum : d j + ∑ i ∈ univ.erase j, d i = 0
hsq : ∑ i, d i ^ 2 = d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2
hcard : ↑(#(univ.erase j)) = ↑n - 1
cs : d j ^ 2 ≤ (↑n - 1) * ∑ i ∈ univ.erase j, d i ^ 2
hneg : ∑ i ∈ univ.erase j, d i = -d j
⊢ ↑n * d j ^ 2 ≤ (↑n - 1) * (d j ^ 2 + ∑ i ∈ univ.erase j, d i ^ 2)</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-z_le_tres">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N02-P01 · Con 10 canales o menos, `|z| &gt; 3` es imposible.**
Para `n ≤ 10`: `(x_j − x̄)² ≤ 9 · σ²`, con `σ² = S/n` la varianza poblacional. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">z_le_tres</span> <span class="lk-bracket">{</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-delim">:</span> <span class="lk-const">Fin</span> <span class="lk-var">n</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">j</span> <span class="lk-delim">:</span> <span class="lk-const">Fin</span> <span class="lk-var">n</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hn10</span> <span class="lk-delim">:</span> <span class="lk-var">n</span> <span class="lk-operator">≤</span> <span class="lk-num">10</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-var">j</span> <span class="lk-operator">-</span> <span class="lk-const">media</span> <span class="lk-var">x</span><span class="lk-bracket">)</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-operator">≤</span> <span class="lk-num">9</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-const">sumaCuadrados</span> <span class="lk-var">x</span> <span class="lk-operator">/</span> <span class="lk-var">n</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t5"><span class="lk-keyword">have</span> <span class="lk-var">hn</span> <span class="lk-delim">:</span> <span class="lk-bracket">(</span><span class="lk-num">0</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">&lt;</span> <span class="lk-var">n</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span>
    <span class="lean-tac" id="t4"><span class="lk-keyword">have</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">&lt;</span> <span class="lk-var">n</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.pos_of_ne_zero</span> <span class="lk-bracket">(</span><span class="lean-tac" id="t2"><span class="lk-keyword">by</span><sup class="lean-tac-n">2</sup></span> <span class="lean-tac" id="t3"><span class="lk-keyword">rintro</span> <span class="lk-var">rfl</span><sup class="lean-tac-n">3</sup></span><span class="lk-separator">;</span> <span class="lk-keyword">exact</span> <span class="lk-var">j</span><span class="lk-delim">.</span><span class="lk-const">elim0</span><span class="lk-bracket">)</span><sup class="lean-tac-n">4</sup></span>
    <span class="lk-keyword">exact_mod_cast</span> <span class="lk-var">this</span><sup class="lean-tac-n">5</sup></span>
  <span class="lean-tac" id="t6"><span class="lk-keyword">have</span> <span class="lk-var">h</span> <span class="lk-delim">:=</span> <span class="lk-const">samuelson</span> <span class="lk-var">x</span> <span class="lk-var">j</span><sup class="lean-tac-n">6</sup></span>
  <span class="lean-tac" id="t7"><span class="lk-keyword">have</span> <span class="lk-var">hS</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">≤</span> <span class="lk-const">sumaCuadrados</span> <span class="lk-var">x</span> <span class="lk-delim">:=</span> <span class="lk-const">sum_nonneg</span> <span class="lk-keyword">fun</span> <span class="lk-var">i</span> <span class="lk-wildcard">_</span> <span class="lk-delim">=&gt;</span> <span class="lk-const">sq_nonneg</span> <span class="lk-wildcard">_</span><sup class="lean-tac-n">7</sup></span>
  <span class="lean-tac" id="t8"><span class="lk-keyword">have</span> <span class="lk-var">h10</span> <span class="lk-delim">:</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-operator">≤</span> <span class="lk-num">10</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span> <span class="lk-keyword">exact_mod_cast</span> <span class="lk-var">hn10</span><sup class="lean-tac-n">8</sup></span>
  <span class="lean-tac" id="t11"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t9"><span class="lk-const">mul_div_assoc&#x27;</span><span class="lk-separator">,</span><sup class="lean-tac-n">9</sup></span> <span class="lean-tac" id="t10"><span class="lk-const">le_div_iff₀</span> <span class="lk-var">hn</span><sup class="lean-tac-n">10</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">11</sup></span>
  <span class="lk-keyword">nlinarith</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
⊢ (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / ↑n)</pre></details></li>
<li value="2"><details><summary><code>by</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
⊢ n ≠ 0</pre></details></li>
<li value="3"><details><summary><code>rintro rfl</code></summary><pre class="lean-estado">x : Fin 0 → ℝ
j : Fin 0
hn10 : 0 ≤ 10
⊢ False</pre></details></li>
<li value="4"><details><summary><code>have : 0 &lt; n := Nat.pos_of_ne_zero (by rintro rfl; exact j.elim0)</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
this : 0 &lt; n
⊢ 0 &lt; ↑n</pre></details></li>
<li value="5"><details><summary><code>have hn : (0 : ℝ) &lt; n := by have : 0 &lt; n := Nat.pos_of_ne_zero (by …</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
⊢ (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / ↑n)</pre></details></li>
<li value="6"><details><summary><code>have h := samuelson x j</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
⊢ (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / ↑n)</pre></details></li>
<li value="7"><details><summary><code>have hS : 0 ≤ sumaCuadrados x := sum_nonneg fun i _ =&gt; sq_nonneg _</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
hS : 0 ≤ sumaCuadrados x
⊢ (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / ↑n)</pre></details></li>
<li value="8"><details><summary><code>have h10 : (n : ℝ) ≤ 10 := by exact_mod_cast hn10</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
hS : 0 ≤ sumaCuadrados x
h10 : ↑n ≤ 10
⊢ (x j - media x) ^ 2 ≤ 9 * (sumaCuadrados x / ↑n)</pre></details></li>
<li value="9"><details><summary><code>mul_div_assoc&#x27;,</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
hS : 0 ≤ sumaCuadrados x
h10 : ↑n ≤ 10
⊢ (x j - media x) ^ 2 ≤ 9 * sumaCuadrados x / ↑n</pre></details></li>
<li value="10"><details><summary><code>le_div_iff₀ hn</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
hS : 0 ≤ sumaCuadrados x
h10 : ↑n ≤ 10
⊢ (x j - media x) ^ 2 * ↑n ≤ 9 * sumaCuadrados x</pre></details></li>
<li value="11"><details><summary><code>rw [mul_div_assoc&#x27;, le_div_iff₀ hn]</code></summary><pre class="lean-estado">n : ℕ
x : Fin n → ℝ
j : Fin n
hn10 : n ≤ 10
hn : 0 &lt; ↑n
h : ↑n * (x j - media x) ^ 2 ≤ (↑n - 1) * sumaCuadrados x
hS : 0 ≤ sumaCuadrados x
h10 : ↑n ≤ 10
⊢ (x j - media x) ^ 2 * ↑n ≤ 9 * sumaCuadrados x</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-once_canales_basta">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N02-P01 (b) · La cota es ajustada en el umbral: con 11 canales sí puede
ocurrir.** Para `x = (1, 0, …, 0)` con 11 canales, `z_0² = 10 &gt; 9`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">once_canales_basta</span> <span class="lk-delim">:</span>
    <span class="lk-keyword">let</span> <span class="lk-var">x</span> <span class="lk-delim">:</span> <span class="lk-const">Fin</span> <span class="lk-num">11</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span> <span class="lk-delim">:=</span> <span class="lk-keyword">fun</span> <span class="lk-var">i</span> <span class="lk-delim">=&gt;</span> <span class="lk-keyword">if</span> <span class="lk-var">i</span> <span class="lk-operator">=</span> <span class="lk-num">0</span> <span class="lk-keyword">then</span> <span class="lk-num">1</span> <span class="lk-keyword">else</span> <span class="lk-num">0</span>
    <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-num">0</span> <span class="lk-operator">-</span> <span class="lk-const">media</span> <span class="lk-var">x</span><span class="lk-bracket">)</span> <span class="lk-operator">^</span> <span class="lk-num">2</span> <span class="lk-operator">&gt;</span> <span class="lk-num">9</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-const">sumaCuadrados</span> <span class="lk-var">x</span> <span class="lk-operator">/</span> <span class="lk-num">11</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">intro</span> <span class="lk-var">x</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t3"><span class="lk-keyword">simp</span> <span class="lk-keyword">only</span> <span class="lk-bracket">[</span><span class="lk-var">x</span><span class="lk-separator">,</span> <span class="lk-const">sumaCuadrados</span><span class="lk-separator">,</span> <span class="lk-const">media</span><span class="lk-separator">,</span> <span class="lk-const">Fin.sum_univ_succ</span><span class="lk-separator">,</span> <span class="lk-const">Fin.sum_univ_zero</span><span class="lk-bracket">]</span><sup class="lean-tac-n">3</sup></span>
  <span class="lk-keyword">norm_num</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">⊢ let x := fun i =&gt; if i = 0 then 1 else 0;
(x 0 - media x) ^ 2 &gt; 9 * (sumaCuadrados x / 11)</pre></details></li>
<li value="2"><details><summary><code>intro x</code></summary><pre class="lean-estado">x : Fin 11 → ℝ := fun i =&gt; if i = 0 then 1 else 0
⊢ (x 0 - media x) ^ 2 &gt; 9 * (sumaCuadrados x / 11)</pre></details></li>
<li value="3"><details><summary><code>simp only [x, sumaCuadrados, media, Fin.sum_univ_succ, Fin.sum_univ…</code></summary><pre class="lean-estado">x : Fin 11 → ℝ := fun i =&gt; if i = 0 then 1 else 0
⊢ ((if True then 1 else 0) -
      ((if True then 1 else 0) +
          ((if Fin.succ 0 = 0 then 1 else 0) +
            ((if (Fin.succ 0).succ = 0 then 1 else 0) +
              ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                  ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                    ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                      ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                        ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                              0))))))))))) /
        ↑11) ^
    2 &gt;
  9 *
    ((((if True then 1 else 0) -
            ((if True then 1 else 0) +
                ((if Fin.succ 0 = 0 then 1 else 0) +
                  ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                    ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                      ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                        ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                    0))))))))))) /
              ↑11) ^
          2 +
        (((if Fin.succ 0 = 0 then 1 else 0) -
              ((if True then 1 else 0) +
                  ((if Fin.succ 0 = 0 then 1 else 0) +
                    ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                      ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                        ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                      0))))))))))) /
                ↑11) ^
            2 +
          (((if (Fin.succ 0).succ = 0 then 1 else 0) -
                ((if True then 1 else 0) +
                    ((if Fin.succ 0 = 0 then 1 else 0) +
                      ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                        ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                        else 0) +
                                        0))))))))))) /
                  ↑11) ^
              2 +
            (((if (Fin.succ 0).succ.succ = 0 then 1 else 0) -
                  ((if True then 1 else 0) +
                      ((if Fin.succ 0 = 0 then 1 else 0) +
                        ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                          else 0) +
                                          0))))))))))) /
                    ↑11) ^
                2 +
              (((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) -
                    ((if True then 1 else 0) +
                        ((if Fin.succ 0 = 0 then 1 else 0) +
                          ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                            else 0) +
                                            0))))))))))) /
                      ↑11) ^
                  2 +
                (((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) -
                      ((if True then 1 else 0) +
                          ((if Fin.succ 0 = 0 then 1 else 0) +
                            ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                              else 0) +
                                              0))))))))))) /
                        ↑11) ^
                    2 +
                  (((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) -
                        ((if True then 1 else 0) +
                            ((if Fin.succ 0 = 0 then 1 else 0) +
                              ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                              else 0) +
                                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                else 0) +
                                                0))))))))))) /
                          ↑11) ^
                      2 +
                    (((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) -
                          ((if True then 1 else 0) +
                              ((if Fin.succ 0 = 0 then 1 else 0) +
                                ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                else 0) +
                                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then
                                                    1
                                                  else 0) +
                                                  0))))))))))) /
                            ↑11) ^
                        2 +
                      (((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) -
                            ((if True then 1 else 0) +
                                ((if Fin.succ 0 = 0 then 1 else 0) +
                                  ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                  else 0) +
                                                  ((if
                                                        (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ =
                                                          0 then
                                                      1
                                                    else 0) +
                                                    0))))))))))) /
                              ↑11) ^
                          2 +
                        (((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) -
                              ((if True then 1 else 0) +
                                  ((if Fin.succ 0 = 0 then 1 else 0) +
                                    ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                              ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                  else 0) +
                                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                    else 0) +
                                                    ((if
                                                          (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ =
                                                            0 then
                                                        1
                                                      else 0) +
                                                      0))))))))))) /
                                ↑11) ^
                            2 +
                          (((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1 else 0) -
                                ((if True then 1 else 0) +
                                    ((if Fin.succ 0 = 0 then 1 else 0) +
                                      ((if (Fin.succ 0).succ = 0 then 1 else 0) +
                                        ((if (Fin.succ 0).succ.succ = 0 then 1 else 0) +
                                          ((if (Fin.succ 0).succ.succ.succ = 0 then 1 else 0) +
                                            ((if (Fin.succ 0).succ.succ.succ.succ = 0 then 1 else 0) +
                                              ((if (Fin.succ 0).succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                                ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ = 0 then 1 else 0) +
                                                  ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                    else 0) +
                                                    ((if (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ = 0 then 1
                                                      else 0) +
                                                      ((if
                                                            (Fin.succ 0).succ.succ.succ.succ.succ.succ.succ.succ.succ =
                                                              0 then
                                                          1
                                                        else 0) +
                                                        0))))))))))) /
                                  ↑11) ^
                              2 +
                            0))))))))))) /
      11)</pre></details></li>
</ol>
</section>
<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real del módulo · SHA-256 del JSON: <code>f440db210c2e46d7…</code></p>
</div>
```
