<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->
```{=html}
<div class="lean-visor">
<section class="lean-decl" id="visor-idx">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Índice lineal en base cero de la muestra `n` del canal `c`
en un registro MULTIPLEXED con `C` canales. -/</span>
<span class="lk-keyword">def</span> <span class="lk-const">idx</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-delim">:=</span> <span class="lk-var">n</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">+</span> <span class="lk-var">c</span></code></pre>
</section>
<section class="lean-decl" id="visor-idx_lt">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **F01-P01 · Acotación.** Si `n &lt; N` y `c &lt; C`, el índice cae dentro del
vector de longitud `N * C`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx_lt</span> <span class="lk-bracket">{</span><span class="lk-var">N</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">hn</span> <span class="lk-delim">:</span> <span class="lk-var">n</span> <span class="lk-operator">&lt;</span> <span class="lk-var">N</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hc</span> <span class="lk-delim">:</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">idx</span><sup class="lean-tac-n">2</sup></span>
  <span class="lk-keyword">calc</span> <span class="lk-var">n</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">+</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">n</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">+</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t3"><span class="lk-keyword">by</span><sup class="lean-tac-n">3</sup></span> <span class="lk-keyword">omega</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">=</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t4"><span class="lk-keyword">by</span><sup class="lean-tac-n">4</sup></span> <span class="lk-keyword">ring</span>
    <span class="lk-wildcard">_</span> <span class="lk-operator">≤</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lk-const">Nat.mul_le_mul_right</span> <span class="lk-var">C</span> <span class="lk-var">hn</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ idx C n c &lt; N * C</pre></details></li>
<li value="2"><details><summary><code>unfold idx</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ n * C + c &lt; N * C</pre></details></li>
<li value="3"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ n * C + c &lt; n * C + C</pre></details></li>
<li value="4"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
n : ℕ
c : ℕ
hn : n &lt; N
hc : c &lt; C
⊢ n * C + C = (n + 1) * C</pre></details></li>
</ol>
</section>
<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real del módulo · SHA-256 del JSON: <code>aec38f4480e31d0f…</code></p>
</div>
```
