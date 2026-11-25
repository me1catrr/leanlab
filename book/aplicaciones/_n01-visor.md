<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->
```{=html}
<div class="lean-visor">
<section class="lean-decl" id="visor-offset">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Primer byte del valor de la muestra `n` del canal `c` (base cero),
con `b` bytes por valor. -/</span>
<span class="lk-keyword">def</span> <span class="lk-const">offset</span> <span class="lk-bracket">(</span><span class="lk-var">b</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-delim">:=</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">*</span> <span class="lk-var">b</span></code></pre>
</section>
<section class="lean-decl" id="visor-offset_add_le">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N01-P01 · Acotación en bytes.** El valor completo (sus `b` bytes) cabe
en un archivo de `N · C · b` bytes. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">offset_add_le</span> <span class="lk-bracket">{</span><span class="lk-var">N</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">b</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hn</span> <span class="lk-delim">:</span> <span class="lk-var">n</span> <span class="lk-operator">&lt;</span> <span class="lk-var">N</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hc</span> <span class="lk-delim">:</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-const">offset</span> <span class="lk-var">b</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">+</span> <span class="lk-var">b</span> <span class="lk-operator">≤</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">offset</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t3"><span class="lk-keyword">have</span> <span class="lk-var">h</span> <span class="lk-delim">:</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">+</span> <span class="lk-num">1</span> <span class="lk-operator">≤</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lk-const">idx_lt</span> <span class="lk-var">hn</span> <span class="lk-var">hc</span><sup class="lean-tac-n">3</sup></span>
  <span class="lk-keyword">calc</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">*</span> <span class="lk-var">b</span> <span class="lk-operator">+</span> <span class="lk-var">b</span> <span class="lk-operator">=</span> <span class="lk-bracket">(</span><span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">b</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t4"><span class="lk-keyword">by</span><sup class="lean-tac-n">4</sup></span> <span class="lk-keyword">ring</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">≤</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.mul_le_mul_right</span> <span class="lk-var">b</span> <span class="lk-var">h</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
b : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ offset b C n c + b ≤ N * C * b</pre></details></li>
<li value="2"><details><summary><code>unfold offset</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
b : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ idx C n c * b + b ≤ N * C * b</pre></details></li>
<li value="3"><details><summary><code>have h : idx C n c + 1 ≤ N * C := idx_lt hn hc</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
b : ℕ
hn : n &lt; N
hc : c &lt; C
h : idx C n c + 1 ≤ N * C
⊢ idx C n c * b + b ≤ N * C * b</pre></details></li>
<li value="4"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
b : ℕ
hn : n &lt; N
hc : c &lt; C
h : idx C n c + 1 ≤ N * C
⊢ idx C n c * b + b = (idx C n c + 1) * b</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-completas">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Número de muestras completas en un archivo de `L` bytes. -/</span>
<span class="lk-keyword">def</span> <span class="lk-const">completas</span> <span class="lk-bracket">(</span><span class="lk-var">L</span> <span class="lk-var">C</span> <span class="lk-var">b</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-delim">:=</span> <span class="lk-var">L</span> <span class="lk-operator">/</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span></code></pre>
</section>
<section class="lean-decl" id="visor-completas_caben">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N01-P02 (a) · Caben.** Las muestras completas ocupan como mucho `L` bytes. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">completas_caben</span> <span class="lk-bracket">(</span><span class="lk-var">L</span> <span class="lk-var">C</span> <span class="lk-var">b</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">completas</span> <span class="lk-var">L</span> <span class="lk-var">C</span> <span class="lk-var">b</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span> <span class="lk-operator">≤</span> <span class="lk-var">L</span> <span class="lk-delim">:=</span>
  <span class="lk-const">Nat.div_mul_le_self</span> <span class="lk-var">L</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span></code></pre>
</section>
<section class="lean-decl" id="visor-completas_maximas">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N01-P02 (b) · Son todas.** Una muestra más ya no cabe en `L` bytes. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">completas_maximas</span> <span class="lk-bracket">{</span><span class="lk-var">L</span> <span class="lk-var">C</span> <span class="lk-var">b</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">h</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-var">L</span> <span class="lk-operator">&lt;</span> <span class="lk-bracket">(</span><span class="lk-const">completas</span> <span class="lk-var">L</span> <span class="lk-var">C</span> <span class="lk-var">b</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">completas</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t3"><span class="lk-keyword">have</span> <span class="lk-var">h1</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.div_add_mod</span> <span class="lk-var">L</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-operator">*</span> <span class="lk-var">b</span><span class="lk-bracket">)</span><sup class="lean-tac-n">3</sup></span>
  <span class="lean-tac" id="t4"><span class="lk-keyword">have</span> <span class="lk-var">h2</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.mod_lt</span> <span class="lk-var">L</span> <span class="lk-var">h</span><sup class="lean-tac-n">4</sup></span>
  <span class="lk-keyword">nlinarith</span> <span class="lk-bracket">[</span><span class="lk-var">h1</span><span class="lk-separator">,</span> <span class="lk-var">h2</span><span class="lk-bracket">]</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">L : ℕ
C : ℕ
b : ℕ
h : 0 &lt; C * b
⊢ L &lt; (completas L C b + 1) * (C * b)</pre></details></li>
<li value="2"><details><summary><code>unfold completas</code></summary><pre class="lean-estado">L : ℕ
C : ℕ
b : ℕ
h : 0 &lt; C * b
⊢ L &lt; (L / (C * b) + 1) * (C * b)</pre></details></li>
<li value="3"><details><summary><code>have h1 := Nat.div_add_mod L (C * b)</code></summary><pre class="lean-estado">L : ℕ
C : ℕ
b : ℕ
h : 0 &lt; C * b
h1 : C * b * (L / (C * b)) + L % (C * b) = L
⊢ L &lt; (L / (C * b) + 1) * (C * b)</pre></details></li>
<li value="4"><details><summary><code>have h2 := Nat.mod_lt L h</code></summary><pre class="lean-estado">L : ℕ
C : ℕ
b : ℕ
h : 0 &lt; C * b
h1 : C * b * (L / (C * b)) + L % (C * b) = L
h2 : L % (C * b) &lt; C * b
⊢ L &lt; (L / (C * b) + 1) * (C * b)</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-calibrar_asoc">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **N01-P03 · Calibración y unidades en ℝ.** Calibrar (`r`, µV por unidad
cruda) y después pasar a voltios (`s = 10⁻⁶`) equivale a multiplicar por el
factor único `r · s`, como hacen otras bibliotecas. En `Float64`, en cambio,
el resultado puede diferir en el último bit. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">calibrar_asoc</span> <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-var">r</span> <span class="lk-var">s</span> <span class="lk-delim">:</span> <span class="lk-const">ℝ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-bracket">(</span><span class="lk-var">x</span> <span class="lk-operator">*</span> <span class="lk-var">r</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">s</span> <span class="lk-operator">=</span> <span class="lk-var">x</span> <span class="lk-operator">*</span> <span class="lk-bracket">(</span><span class="lk-var">r</span> <span class="lk-operator">*</span> <span class="lk-var">s</span><span class="lk-bracket">)</span> <span class="lk-delim">:=</span> <span class="lk-const">mul_assoc</span> <span class="lk-var">x</span> <span class="lk-var">r</span> <span class="lk-var">s</span></code></pre>
</section>
<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real del módulo · SHA-256 del JSON: <code>f2e3b42e07395fce…</code></p>
</div>
```
