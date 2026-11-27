<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->
```{=html}
<div class="lean-visor">
<section class="lean-decl" id="visor-filtro">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Salida del filtro de un polo con coeficiente `α`, entrada `x` y estado
inicial `y₀` (que hace de `y[−1]`). -/</span>
<span class="lk-keyword">noncomputable</span> <span class="lk-keyword">def</span> <span class="lk-const">filtro</span> <span class="lk-bracket">(</span><span class="lk-var">α</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">y₀</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span>
  <span class="lk-delim">|</span> <span class="lk-num">0</span> <span class="lk-delim">=&gt;</span> <span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">x</span> <span class="lk-num">0</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">y₀</span>
  <span class="lk-delim">|</span> <span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span> <span class="lk-delim">=&gt;</span> <span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">x</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-const">filtro</span> <span class="lk-var">α</span> <span class="lk-var">x</span> <span class="lk-var">y₀</span> <span class="lk-var">n</span></code></pre>
</section>
<section class="lean-decl" id="visor-convexa_acotada">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Paso clave: una combinación convexa de dos valores acotados por `M`
está acotada por `M`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">convexa_acotada</span> <span class="lk-bracket">{</span><span class="lk-var">α</span> <span class="lk-var">a</span> <span class="lk-var">b</span> <span class="lk-var">M</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">h0</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">≤</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">h1</span> <span class="lk-delim">:</span> <span class="lk-var">α</span> <span class="lk-operator">≤</span> <span class="lk-num">1</span><span class="lk-bracket">)</span>
    <span class="lk-bracket">(</span><span class="lk-var">ha</span> <span class="lk-delim">:</span> <span class="lk-delim">|</span><span class="lk-var">a</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hb</span> <span class="lk-delim">:</span> <span class="lk-delim">|</span><span class="lk-var">b</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-delim">|</span><span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">a</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lk-keyword">calc</span> <span class="lk-delim">|</span><span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">a</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-delim">|</span><span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">a</span><span class="lk-delim">|</span> <span class="lk-operator">+</span> <span class="lk-delim">|</span><span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-delim">|</span> <span class="lk-delim">:=</span> <span class="lk-const">abs_add_le</span> <span class="lk-wildcard">_</span> <span class="lk-wildcard">_</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">=</span> <span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-delim">|</span><span class="lk-var">a</span><span class="lk-delim">|</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-delim">|</span><span class="lk-var">b</span><span class="lk-delim">|</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t2"><span class="lk-keyword">by</span><sup class="lean-tac-n">2</sup></span>
        <span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t3"><span class="lk-const">abs_mul</span><span class="lk-separator">,</span><sup class="lean-tac-n">3</sup></span> <span class="lean-tac" id="t4"><span class="lk-const">abs_mul</span><span class="lk-separator">,</span><sup class="lean-tac-n">4</sup></span> <span class="lean-tac" id="t5"><span class="lk-const">abs_of_nonneg</span> <span class="lk-var">h0</span><span class="lk-separator">,</span><sup class="lean-tac-n">5</sup></span> <span class="lean-tac" id="t6"><span class="lk-const">abs_of_nonneg</span> <span class="lk-bracket">(</span><span class="lk-const">sub_nonneg</span><span class="lk-delim">.</span><span class="lk-const">mpr</span> <span class="lk-var">h1</span><span class="lk-bracket">)</span><sup class="lean-tac-n">6</sup></span><span class="lk-bracket">]</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">≤</span> <span class="lk-var">α</span> <span class="lk-operator">*</span> <span class="lk-var">M</span> <span class="lk-operator">+</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">M</span> <span class="lk-delim">:=</span>
        <span class="lk-const">add_le_add</span> <span class="lk-bracket">(</span><span class="lk-const">mul_le_mul_of_nonneg_left</span> <span class="lk-var">ha</span> <span class="lk-var">h0</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-const">mul_le_mul_of_nonneg_left</span> <span class="lk-var">hb</span> <span class="lk-bracket">(</span><span class="lk-const">sub_nonneg</span><span class="lk-delim">.</span><span class="lk-const">mpr</span> <span class="lk-var">h1</span><span class="lk-bracket">)</span><span class="lk-bracket">)</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">=</span> <span class="lk-var">M</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t7"><span class="lk-keyword">by</span><sup class="lean-tac-n">7</sup></span> <span class="lk-keyword">ring</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ |α * a + (1 - α) * b| ≤ M</pre></details></li>
<li value="2"><details><summary><code>by</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ |α * a| + |(1 - α) * b| = α * |a| + (1 - α) * |b|</pre></details></li>
<li value="3"><details><summary><code>abs_mul,</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ |α| * |a| + |(1 - α) * b| = α * |a| + (1 - α) * |b|</pre></details></li>
<li value="4"><details><summary><code>abs_mul,</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ |α| * |a| + |1 - α| * |b| = α * |a| + (1 - α) * |b|</pre></details></li>
<li value="5"><details><summary><code>abs_of_nonneg h0,</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ α * |a| + |1 - α| * |b| = α * |a| + (1 - α) * |b|</pre></details></li>
<li value="6"><details><summary><code>abs_of_nonneg (sub_nonneg.mpr h1)</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ α * |a| + (1 - α) * |b| = α * |a| + (1 - α) * |b|</pre></details></li>
<li value="7"><details><summary><code>by</code></summary><pre class="lean-estado">α : ℝ
a : ℝ
b : ℝ
M : ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
ha : |a| ≤ M
hb : |b| ≤ M
⊢ α * M + (1 - α) * M = M</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-filtro_acotado">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N03-P01 · Acotación.** Con `0 ≤ α ≤ 1`, `|x[n]| ≤ M` para todo `n` y
`|y₀| ≤ M`, se cumple `|y[n]| ≤ M` para todo `n`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">filtro_acotado</span> <span class="lk-bracket">{</span><span class="lk-var">α</span> <span class="lk-var">M</span> <span class="lk-var">y₀</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">}</span> <span class="lk-bracket">{</span><span class="lk-var">x</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-operator">→</span> <span class="lk-const">ℝ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">h0</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">≤</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">h1</span> <span class="lk-delim">:</span> <span class="lk-var">α</span> <span class="lk-operator">≤</span> <span class="lk-num">1</span><span class="lk-bracket">)</span>
    <span class="lk-bracket">(</span><span class="lk-var">hx</span> <span class="lk-delim">:</span> <span class="lk-unknown">∀</span> <span class="lk-var">n</span><span class="lk-separator">,</span> <span class="lk-delim">|</span><span class="lk-var">x</span> <span class="lk-var">n</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hy</span> <span class="lk-delim">:</span> <span class="lk-delim">|</span><span class="lk-var">y₀</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-unknown">∀</span> <span class="lk-var">n</span><span class="lk-separator">,</span> <span class="lk-delim">|</span><span class="lk-const">filtro</span> <span class="lk-var">α</span> <span class="lk-var">x</span> <span class="lk-var">y₀</span> <span class="lk-var">n</span><span class="lk-delim">|</span> <span class="lk-operator">≤</span> <span class="lk-var">M</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">intro</span> <span class="lk-var">n</span><sup class="lean-tac-n">2</sup></span>
  <span class="lk-keyword">induction</span> <span class="lk-var">n</span> <span class="lk-keyword">with</span>
  <span class="lean-tac" id="t3"><span class="lk-delim">|</span> <span class="lk-const">zero</span> <span class="lk-delim">=&gt;</span><sup class="lean-tac-n">3</sup></span> <span class="lk-keyword">exact</span> <span class="lk-const">convexa_acotada</span> <span class="lk-var">h0</span> <span class="lk-var">h1</span> <span class="lk-bracket">(</span><span class="lk-var">hx</span> <span class="lk-num">0</span><span class="lk-bracket">)</span> <span class="lk-var">hy</span>
  <span class="lean-tac" id="t4"><span class="lk-delim">|</span> <span class="lk-const">succ</span> <span class="lk-var">n</span> <span class="lk-var">ih</span> <span class="lk-delim">=&gt;</span><sup class="lean-tac-n">4</sup></span> <span class="lk-keyword">exact</span> <span class="lk-const">convexa_acotada</span> <span class="lk-var">h0</span> <span class="lk-var">h1</span> <span class="lk-bracket">(</span><span class="lk-var">hx</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span><span class="lk-bracket">)</span> <span class="lk-var">ih</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">α : ℝ
M : ℝ
y₀ : ℝ
x : ℕ → ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
hx : ∀ (n : ℕ), |x n| ≤ M
hy : |y₀| ≤ M
⊢ ∀ (n : ℕ), |filtro α x y₀ n| ≤ M</pre></details></li>
<li value="2"><details><summary><code>intro n</code></summary><pre class="lean-estado">α : ℝ
M : ℝ
y₀ : ℝ
x : ℕ → ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
hx : ∀ (n : ℕ), |x n| ≤ M
hy : |y₀| ≤ M
n : ℕ
⊢ |filtro α x y₀ n| ≤ M</pre></details></li>
<li value="3"><details><summary><code>| zero =&gt;</code></summary><pre class="lean-estado">α : ℝ
M : ℝ
y₀ : ℝ
x : ℕ → ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
hx : ∀ (n : ℕ), |x n| ≤ M
hy : |y₀| ≤ M
⊢ |filtro α x y₀ 0| ≤ M</pre></details></li>
<li value="4"><details><summary><code>| succ n ih =&gt;</code></summary><pre class="lean-estado">α : ℝ
M : ℝ
y₀ : ℝ
x : ℕ → ℝ
h0 : 0 ≤ α
h1 : α ≤ 1
hx : ∀ (n : ℕ), |x n| ≤ M
hy : |y₀| ≤ M
n : ℕ
ih : |filtro α x y₀ n| ≤ M
⊢ |filtro α x y₀ (n + 1)| ≤ M</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-filtro_transitorio">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N03-P04 · Transitorio exacto.** Con entrada constante `c`:
`y[n] − c = (1 − α)^(n+1) · (y₀ − c)`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">filtro_transitorio</span> <span class="lk-bracket">(</span><span class="lk-var">α</span> <span class="lk-var">c</span> <span class="lk-var">y₀</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-const">filtro</span> <span class="lk-var">α</span> <span class="lk-bracket">(</span><span class="lk-keyword">fun</span> <span class="lk-wildcard">_</span> <span class="lk-delim">=&gt;</span> <span class="lk-var">c</span><span class="lk-bracket">)</span> <span class="lk-var">y₀</span> <span class="lk-var">n</span> <span class="lk-operator">-</span> <span class="lk-var">c</span> <span class="lk-operator">=</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">^</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-var">y₀</span> <span class="lk-operator">-</span> <span class="lk-var">c</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lk-keyword">induction</span> <span class="lk-var">n</span> <span class="lk-keyword">with</span>
  <span class="lean-tac" id="t2"><span class="lk-delim">|</span> <span class="lk-const">zero</span> <span class="lk-delim">=&gt;</span><sup class="lean-tac-n">2</sup></span> <span class="lean-tac" id="t3"><span class="lk-keyword">simp</span> <span class="lk-bracket">[</span><span class="lk-const">filtro</span><span class="lk-bracket">]</span><sup class="lean-tac-n">3</sup></span><span class="lk-separator">;</span> <span class="lk-keyword">ring</span>
  <span class="lean-tac" id="t4"><span class="lk-delim">|</span> <span class="lk-const">succ</span> <span class="lk-var">n</span> <span class="lk-var">ih</span> <span class="lk-delim">=&gt;</span><sup class="lean-tac-n">4</sup></span>
    <span class="lean-tac" id="t5"><span class="lk-keyword">simp</span> <span class="lk-keyword">only</span> <span class="lk-bracket">[</span><span class="lk-const">filtro</span><span class="lk-bracket">]</span> <span class="lk-keyword">at</span> <span class="lk-var">ih</span> <span class="lk-delim">⊢</span><sup class="lean-tac-n">5</sup></span>
    <span class="lean-tac" id="t7"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t6"><span class="lk-const">pow_succ</span><sup class="lean-tac-n">6</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">7</sup></span>
    <span class="lk-keyword">linear_combination</span> <span class="lk-bracket">(</span><span class="lk-num">1</span> <span class="lk-operator">-</span> <span class="lk-var">α</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">ih</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
n : ℕ
⊢ filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c)</pre></details></li>
<li value="2"><details><summary><code>| zero =&gt;</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
⊢ filtro α (fun x =&gt; c) y₀ 0 - c = (1 - α) ^ (0 + 1) * (y₀ - c)</pre></details></li>
<li value="3"><details><summary><code>simp [filtro]</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
⊢ α * c + (1 - α) * y₀ - c = (1 - α) * (y₀ - c)</pre></details></li>
<li value="4"><details><summary><code>| succ n ih =&gt;</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
n : ℕ
ih : filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c)
⊢ filtro α (fun x =&gt; c) y₀ (n + 1) - c = (1 - α) ^ (n + 1 + 1) * (y₀ - c)</pre></details></li>
<li value="5"><details><summary><code>simp only [filtro] at ih ⊢</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
n : ℕ
ih : filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c)
⊢ α * c + (1 - α) * filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1 + 1) * (y₀ - c)</pre></details></li>
<li value="6"><details><summary><code>pow_succ</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
n : ℕ
ih : filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c)
⊢ α * c + (1 - α) * filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (1 - α) * (y₀ - c)</pre></details></li>
<li value="7"><details><summary><code>rw [pow_succ]</code></summary><pre class="lean-estado">α : ℝ
c : ℝ
y₀ : ℝ
n : ℕ
ih : filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (y₀ - c)
⊢ α * c + (1 - α) * filtro α (fun x =&gt; c) y₀ n - c = (1 - α) ^ (n + 1) * (1 - α) * (y₀ - c)</pre></details></li>
</ol>
</section>
<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real del módulo · SHA-256 del JSON: <code>f4f9bbfd555ce8b8…</code></p>
</div>
```
