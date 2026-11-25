<!-- Generado por scripts/visor_lean.py a partir de SubVerso. No editar a mano. -->
```{=html}
<div class="lean-visor">
<section class="lean-decl" id="visor-idx_mod">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- El canal se recupera con el resto de la división por `C`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx_mod</span> <span class="lk-bracket">{</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">hc</span> <span class="lk-delim">:</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">%</span> <span class="lk-var">C</span> <span class="lk-operator">=</span> <span class="lk-var">c</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">idx</span><sup class="lean-tac-n">2</sup></span>
  <span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t3"><span class="lk-const">Nat.add_comm</span><span class="lk-separator">,</span><sup class="lean-tac-n">3</sup></span> <span class="lean-tac" id="t4"><span class="lk-const">Nat.add_mul_mod_self_right</span><span class="lk-separator">,</span><sup class="lean-tac-n">4</sup></span> <span class="lean-tac" id="t5"><span class="lk-const">Nat.mod_eq_of_lt</span> <span class="lk-var">hc</span><sup class="lean-tac-n">5</sup></span><span class="lk-bracket">]</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ idx C n c % C = c</pre></details></li>
<li value="2"><details><summary><code>unfold idx</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ (n * C + c) % C = c</pre></details></li>
<li value="3"><details><summary><code>Nat.add_comm,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ (c + n * C) % C = c</pre></details></li>
<li value="4"><details><summary><code>Nat.add_mul_mod_self_right,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ c % C = c</pre></details></li>
<li value="5"><details><summary><code>Nat.mod_eq_of_lt hc</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ c = c</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-idx_div">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- La muestra se recupera con el cociente de la división por `C`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx_div</span> <span class="lk-bracket">{</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">hc</span> <span class="lk-delim">:</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">/</span> <span class="lk-var">C</span> <span class="lk-operator">=</span> <span class="lk-var">n</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">idx</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t4"><span class="lk-keyword">have</span> <span class="lk-var">hC</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t3"><span class="lk-keyword">by</span><sup class="lean-tac-n">3</sup></span> <span class="lk-keyword">omega</span><sup class="lean-tac-n">4</sup></span>
  <span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t5"><span class="lk-const">Nat.add_comm</span><span class="lk-separator">,</span><sup class="lean-tac-n">5</sup></span> <span class="lean-tac" id="t6"><span class="lk-const">Nat.add_mul_div_right</span> <span class="lk-wildcard">_</span> <span class="lk-wildcard">_</span> <span class="lk-var">hC</span><span class="lk-separator">,</span><sup class="lean-tac-n">6</sup></span> <span class="lean-tac" id="t7"><span class="lk-const">Nat.div_eq_of_lt</span> <span class="lk-var">hc</span><span class="lk-separator">,</span><sup class="lean-tac-n">7</sup></span> <span class="lean-tac" id="t8"><span class="lk-const">Nat.zero_add</span><sup class="lean-tac-n">8</sup></span><span class="lk-bracket">]</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ idx C n c / C = n</pre></details></li>
<li value="2"><details><summary><code>unfold idx</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ (n * C + c) / C = n</pre></details></li>
<li value="3"><details><summary><code>by</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
⊢ idx C n c / C = n</pre></details></li>
<li value="4"><details><summary><code>have hC : 0 &lt; C := by omega</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
hC : 0 &lt; C
⊢ (n * C + c) / C = n</pre></details></li>
<li value="5"><details><summary><code>Nat.add_comm,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
hC : 0 &lt; C
⊢ (c + n * C) / C = n</pre></details></li>
<li value="6"><details><summary><code>Nat.add_mul_div_right _ _ hC,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
hC : 0 &lt; C
⊢ c / C + n = n</pre></details></li>
<li value="7"><details><summary><code>Nat.div_eq_of_lt hc,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
hC : 0 &lt; C
⊢ 0 + n = n</pre></details></li>
<li value="8"><details><summary><code>Nat.zero_add</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
hc : c &lt; C
hC : 0 &lt; C
⊢ n = n</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-idx_inj">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **Inyectividad.** Dos pares válidos distintos nunca comparten posición. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx_inj</span> <span class="lk-bracket">{</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-var">n&#x27;</span> <span class="lk-var">c&#x27;</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">hc</span> <span class="lk-delim">:</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">hc&#x27;</span> <span class="lk-delim">:</span> <span class="lk-var">c&#x27;</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span><span class="lk-bracket">)</span>
    <span class="lk-bracket">(</span><span class="lk-var">h</span> <span class="lk-delim">:</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">=</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n&#x27;</span> <span class="lk-var">c&#x27;</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-var">n</span> <span class="lk-operator">=</span> <span class="lk-var">n&#x27;</span> <span class="lk-operator">∧</span> <span class="lk-var">c</span> <span class="lk-operator">=</span> <span class="lk-var">c&#x27;</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">constructor</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t3"><span class="lk-delim">·</span><sup class="lean-tac-n">3</sup></span> <span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t4"><span class="lk-delim">←</span> <span class="lk-const">idx_div</span> <span class="lk-bracket">(</span><span class="lk-unknown">n</span> <span class="lk-delim">:=</span> <span class="lk-var">n</span><span class="lk-bracket">)</span> <span class="lk-var">hc</span><span class="lk-separator">,</span><sup class="lean-tac-n">4</sup></span> <span class="lean-tac" id="t5"><span class="lk-delim">←</span> <span class="lk-const">idx_div</span> <span class="lk-bracket">(</span><span class="lk-unknown">n</span> <span class="lk-delim">:=</span> <span class="lk-var">n&#x27;</span><span class="lk-bracket">)</span> <span class="lk-var">hc&#x27;</span><span class="lk-separator">,</span><sup class="lean-tac-n">5</sup></span> <span class="lean-tac" id="t6"><span class="lk-var">h</span><sup class="lean-tac-n">6</sup></span><span class="lk-bracket">]</span>
  <span class="lean-tac" id="t7"><span class="lk-delim">·</span><sup class="lean-tac-n">7</sup></span> <span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t8"><span class="lk-delim">←</span> <span class="lk-const">idx_mod</span> <span class="lk-bracket">(</span><span class="lk-unknown">n</span> <span class="lk-delim">:=</span> <span class="lk-var">n</span><span class="lk-bracket">)</span> <span class="lk-var">hc</span><span class="lk-separator">,</span><sup class="lean-tac-n">8</sup></span> <span class="lean-tac" id="t9"><span class="lk-delim">←</span> <span class="lk-const">idx_mod</span> <span class="lk-bracket">(</span><span class="lk-unknown">n</span> <span class="lk-delim">:=</span> <span class="lk-var">n&#x27;</span><span class="lk-bracket">)</span> <span class="lk-var">hc&#x27;</span><span class="lk-separator">,</span><sup class="lean-tac-n">9</sup></span> <span class="lean-tac" id="t10"><span class="lk-var">h</span><sup class="lean-tac-n">10</sup></span><span class="lk-bracket">]</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ n = n&#x27; ∧ c = c&#x27;</pre></details></li>
<li value="2"><details><summary><code>constructor</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ n = n&#x27;

C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ c = c&#x27;</pre></details></li>
<li value="3"><details><summary><code>·</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ n = n&#x27;</pre></details></li>
<li value="4"><details><summary><code>← idx_div (n := n) hc,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n c / C = n&#x27;</pre></details></li>
<li value="5"><details><summary><code>← idx_div (n := n&#x27;) hc&#x27;,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n c / C = idx C n&#x27; c&#x27; / C</pre></details></li>
<li value="6"><details><summary><code>h</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n&#x27; c&#x27; / C = idx C n&#x27; c&#x27; / C</pre></details></li>
<li value="7"><details><summary><code>·</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ c = c&#x27;</pre></details></li>
<li value="8"><details><summary><code>← idx_mod (n := n) hc,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n c % C = c&#x27;</pre></details></li>
<li value="9"><details><summary><code>← idx_mod (n := n&#x27;) hc&#x27;,</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n c % C = idx C n&#x27; c&#x27; % C</pre></details></li>
<li value="10"><details><summary><code>h</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
n&#x27; : ℕ
c&#x27; : ℕ
hc : c &lt; C
hc&#x27; : c&#x27; &lt; C
h : idx C n c = idx C n&#x27; c&#x27;
⊢ idx C n&#x27; c&#x27; % C = idx C n&#x27; c&#x27; % C</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-idx_surj">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **Cobertura.** Toda posición del vector corresponde a un par válido. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx_surj</span> <span class="lk-bracket">{</span><span class="lk-var">N</span> <span class="lk-var">C</span> <span class="lk-var">k</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">}</span> <span class="lk-bracket">(</span><span class="lk-var">hk</span> <span class="lk-delim">:</span> <span class="lk-var">k</span> <span class="lk-operator">&lt;</span> <span class="lk-var">N</span> <span class="lk-operator">*</span> <span class="lk-var">C</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span>
    <span class="lk-unknown">∃</span> <span class="lk-var">n</span> <span class="lk-var">c</span><span class="lk-separator">,</span> <span class="lk-var">n</span> <span class="lk-operator">&lt;</span> <span class="lk-var">N</span> <span class="lk-operator">∧</span> <span class="lk-var">c</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span> <span class="lk-operator">∧</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">=</span> <span class="lk-var">k</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t5"><span class="lk-keyword">have</span> <span class="lk-var">hC</span> <span class="lk-delim">:</span> <span class="lk-num">0</span> <span class="lk-operator">&lt;</span> <span class="lk-var">C</span> <span class="lk-delim">:=</span> <span class="lk-keyword">by</span>
    <span class="lean-tac" id="t2"><span class="lk-keyword">rcases</span> <span class="lk-const">Nat.eq_zero_or_pos</span> <span class="lk-var">C</span> <span class="lk-keyword">with</span> <span class="lk-var">h</span> <span class="lk-delim">|</span> <span class="lk-var">h</span><sup class="lean-tac-n">2</sup></span>
    <span class="lean-tac" id="t3"><span class="lk-delim">·</span><sup class="lean-tac-n">3</sup></span> <span class="lk-keyword">simp</span> <span class="lk-bracket">[</span><span class="lk-var">h</span><span class="lk-bracket">]</span> <span class="lk-keyword">at</span> <span class="lk-var">hk</span>
    <span class="lean-tac" id="t4"><span class="lk-delim">·</span><sup class="lean-tac-n">4</sup></span> <span class="lk-keyword">exact</span> <span class="lk-var">h</span><sup class="lean-tac-n">5</sup></span>
  <span class="lean-tac" id="t6"><span class="lk-keyword">refine</span> <span class="lk-anonCtor">⟨</span><span class="lk-var">k</span> <span class="lk-operator">/</span> <span class="lk-var">C</span><span class="lk-anonCtor">,</span> <span class="lk-var">k</span> <span class="lk-operator">%</span> <span class="lk-var">C</span><span class="lk-anonCtor">,</span> <span class="lk-operator">?</span><span class="lk-wildcard">_</span><span class="lk-anonCtor">,</span> <span class="lk-const">Nat.mod_lt</span> <span class="lk-var">k</span> <span class="lk-var">hC</span><span class="lk-anonCtor">,</span> <span class="lk-operator">?</span><span class="lk-wildcard">_</span><span class="lk-anonCtor">⟩</span><sup class="lean-tac-n">6</sup></span>
  <span class="lean-tac" id="t7"><span class="lk-delim">·</span><sup class="lean-tac-n">7</sup></span> <span class="lk-keyword">exact</span> <span class="lk-bracket">(</span><span class="lk-const">Nat.div_lt_iff_lt_mul</span> <span class="lk-var">hC</span><span class="lk-bracket">)</span><span class="lk-delim">.</span><span class="lk-const">2</span> <span class="lk-var">hk</span>
  <span class="lean-tac" id="t8"><span class="lk-delim">·</span><sup class="lean-tac-n">8</sup></span> <span class="lean-tac" id="t9"><span class="lk-keyword">unfold</span> <span class="lk-const">idx</span><sup class="lean-tac-n">9</sup></span>
    <span class="lean-tac" id="t11"><span class="lk-keyword">rw</span> <span class="lk-bracket">[</span><span class="lean-tac" id="t10"><span class="lk-const">Nat.mul_comm</span><sup class="lean-tac-n">10</sup></span><span class="lk-bracket">]</span><sup class="lean-tac-n">11</sup></span>
    <span class="lk-keyword">exact</span> <span class="lk-const">Nat.div_add_mod</span> <span class="lk-var">k</span> <span class="lk-var">C</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
⊢ ∃ n c, n &lt; N ∧ c &lt; C ∧ idx C n c = k</pre></details></li>
<li value="2"><details><summary><code>rcases Nat.eq_zero_or_pos C with h | h</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
h : C = 0
⊢ 0 &lt; C

N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
h : C &gt; 0
⊢ 0 &lt; C</pre></details></li>
<li value="3"><details><summary><code>·</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
h : C = 0
⊢ 0 &lt; C</pre></details></li>
<li value="4"><details><summary><code>·</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
h : C &gt; 0
⊢ 0 &lt; C</pre></details></li>
<li value="5"><details><summary><code>have hC : 0 &lt; C := by rcases Nat.eq_zero_or_pos C with h | h · simp…</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ ∃ n c, n &lt; N ∧ c &lt; C ∧ idx C n c = k</pre></details></li>
<li value="6"><details><summary><code>refine ⟨k / C, k % C, ?_, Nat.mod_lt k hC, ?_⟩</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ k / C &lt; N

N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ idx C (k / C) (k % C) = k</pre></details></li>
<li value="7"><details><summary><code>·</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ k / C &lt; N</pre></details></li>
<li value="8"><details><summary><code>·</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ idx C (k / C) (k % C) = k</pre></details></li>
<li value="9"><details><summary><code>unfold idx</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ k / C * C + k % C = k</pre></details></li>
<li value="10"><details><summary><code>Nat.mul_comm</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ C * (k / C) + k % C = k</pre></details></li>
<li value="11"><details><summary><code>rw [Nat.mul_comm]</code></summary><pre class="lean-estado">N : ℕ
C : ℕ
k : ℕ
hk : k &lt; N * C
hC : 0 &lt; C
⊢ C * (k / C) + k % C = k</pre></details></li>
</ol>
</section>
<section class="lean-decl" id="visor-idx1">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- Índice en **base uno**, como en Julia: muestra `n ≥ 1`, canal `c ≥ 1`. -/</span>
<span class="lk-keyword">def</span> <span class="lk-const">idx1</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span> <span class="lk-delim">:=</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">-</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">*</span> <span class="lk-var">C</span> <span class="lk-operator">+</span> <span class="lk-var">c</span></code></pre>
</section>
<section class="lean-decl" id="visor-idx1_eq_idx_succ">
<pre class="lean-codigo"><code><span class="lk-docComment">/-- **Correspondencia base uno ↔ base cero.** Desplazar ambos índices en uno
desplaza la posición en uno: `idx1 C (n+1) (c+1) = idx C n c + 1`. -/</span>
<span class="lk-keyword">theorem</span> <span class="lk-const">idx1_eq_idx_succ</span> <span class="lk-bracket">(</span><span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-delim">:</span> <span class="lk-const">ℕ</span><span class="lk-bracket">)</span> <span class="lk-delim">:</span> <span class="lk-const">idx1</span> <span class="lk-var">C</span> <span class="lk-bracket">(</span><span class="lk-var">n</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-bracket">(</span><span class="lk-var">c</span> <span class="lk-operator">+</span> <span class="lk-num">1</span><span class="lk-bracket">)</span> <span class="lk-operator">=</span> <span class="lk-const">idx</span> <span class="lk-var">C</span> <span class="lk-var">n</span> <span class="lk-var">c</span> <span class="lk-operator">+</span> <span class="lk-num">1</span> <span class="lk-delim">:=</span> <span class="lean-tac" id="t1"><span class="lk-keyword">by</span><sup class="lean-tac-n">1</sup></span>
  <span class="lean-tac" id="t2"><span class="lk-keyword">unfold</span> <span class="lk-const">idx1</span> <span class="lk-const">idx</span><sup class="lean-tac-n">2</sup></span>
  <span class="lean-tac" id="t3"><span class="lk-keyword">simp</span> <span class="lk-keyword">only</span> <span class="lk-bracket">[</span><span class="lk-const">Nat.add_sub_cancel</span><span class="lk-bracket">]</span><sup class="lean-tac-n">3</sup></span>
  <span class="lk-keyword">omega</span></code></pre>
<ol class="lean-estados">
<li value="1"><details><summary><code>by</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
⊢ idx1 C (n + 1) (c + 1) = idx C n c + 1</pre></details></li>
<li value="2"><details><summary><code>unfold idx1 idx</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
⊢ (n + 1 - 1) * C + (c + 1) = n * C + c + 1</pre></details></li>
<li value="3"><details><summary><code>simp only [Nat.add_sub_cancel]</code></summary><pre class="lean-estado">C : ℕ
n : ℕ
c : ℕ
⊢ n * C + (c + 1) = n * C + c + 1</pre></details></li>
</ol>
</section>
<p class="lean-procedencia">Estados extraídos por SubVerso de la elaboración real del módulo · SHA-256 del JSON: <code>aec38f4480e31d0f…</code></p>
</div>
```
