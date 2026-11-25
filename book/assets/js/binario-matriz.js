/* LEANLAB · Laboratorio de código · Componente «binario → matriz» (MIT).
 *
 * Muestra cómo un vector intercalado se reparte en una matriz canales × muestras.
 * - MULTIPLEXED: la correspondencia (n, c) → k procede de las tablas del oráculo
 *   Lean (lake exe f01_tabla 4 C), copiadas en assets/datos/binario-matriz.json.
 * - VECTORIZED: ilustración DIDÁCTICA calculada en el navegador (k = c·N + n);
 *   no procede de ninguna ejecución verificada.
 * Sin dependencias externas. Accesible con teclado: cada celda es un botón.
 */
(function () {
  "use strict";

  function crear(tag, attrs, hijos) {
    const el = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs || {})) {
      if (k === "class") el.className = v;
      else if (k === "text") el.textContent = v;
      else el.setAttribute(k, v);
    }
    (hijos || []).forEach((h) => el.appendChild(h));
    return el;
  }

  async function montar(raiz) {
    let datos;
    try {
      const resp = await fetch(raiz.dataset.datos);
      datos = await resp.json();
    } catch (e) {
      raiz.appendChild(crear("p", { class: "bm-error", text: "No se han podido cargar los datos del oráculo Lean. La tabla estática del capítulo muestra el mismo ejemplo." }));
      return;
    }
    const N = datos.N;
    const estado = { C: 3, orientacion: "MULTIPLEXED", activo: null };

    const ctrlC = crear("div", { class: "bm-grupo", role: "group", "aria-label": "Número de canales" },
      [crear("span", { class: "bm-etq", text: "Canales" })]);
    const ctrlO = crear("div", { class: "bm-grupo", role: "group", "aria-label": "Disposición del archivo" },
      [crear("span", { class: "bm-etq", text: "Disposición" })]);
    const vector = crear("div", { class: "bm-vector", "aria-label": "Vector del archivo, en orden de lectura" });
    const matriz = crear("div", { class: "bm-matriz", "aria-label": "Matriz canales × muestras" });
    const salida = crear("p", { class: "bm-salida", "aria-live": "polite" });
    const nota = crear("p", { class: "bm-nota" });

    for (const C of [2, 3, 4]) {
      const b = crear("button", { type: "button", class: "bm-boton", text: String(C), "aria-pressed": "false" });
      b.addEventListener("click", () => { estado.C = C; estado.activo = null; pintar(); });
      ctrlC.appendChild(b);
    }
    for (const [o, txt] of [["MULTIPLEXED", "Por muestra (MULTIPLEXED)"], ["VECTORIZED", "Por canal (VECTORIZED)"]]) {
      const b = crear("button", { type: "button", class: "bm-boton", text: txt, "aria-pressed": "false" });
      b.addEventListener("click", () => { estado.orientacion = o; estado.activo = null; pintar(); });
      ctrlO.appendChild(b);
    }
    raiz.append(crear("div", { class: "bm-controles" }, [ctrlC, ctrlO]), vector, matriz, salida, nota);

    function correspondencia() {
      const C = estado.C;
      if (estado.orientacion === "MULTIPLEXED") {
        return datos.tablas_multiplexed[String(C)].map(([n, c, k]) => ({ n, c, k }));   // oráculo Lean
      }
      const filas = [];                                       // didáctico, calculado aquí
      for (let c = 0; c < C; c++) for (let n = 0; n < N; n++) filas.push({ n, c, k: c * N + n });
      return filas;
    }

    function activar(k, filas) {
      estado.activo = k;
      raiz.querySelectorAll("[data-k]").forEach((el) => el.classList.toggle("bm-activa", Number(el.dataset.k) === k));
      const f = filas.find((x) => x.k === k);
      const formula = estado.orientacion === "MULTIPLEXED"
        ? `k = n·C + c = ${f.n}·${estado.C} + ${f.c} = ${f.k}`
        : `k = c·N + n = ${f.c}·${N} + ${f.n} = ${f.k}`;
      salida.textContent = `Posición ${f.k} del archivo → canal ${f.c}, muestra ${f.n}.  ${formula}`;
    }

    function celda(k, c, txt, etiqueta, filas) {
      const b = crear("button", { type: "button", class: `bm-celda bm-c${c}`, "data-k": String(k), "aria-label": etiqueta, text: txt });
      b.addEventListener("mouseenter", () => activar(k, filas));
      b.addEventListener("focus", () => activar(k, filas));
      b.addEventListener("click", () => activar(k, filas));
      return b;
    }

    function pintar() {
      const C = estado.C;
      const filas = correspondencia();
      ctrlC.querySelectorAll("button").forEach((b) => b.setAttribute("aria-pressed", String(Number(b.textContent) === C)));
      ctrlO.querySelectorAll("button").forEach((b, i) =>
        b.setAttribute("aria-pressed", String((i === 0) === (estado.orientacion === "MULTIPLEXED"))));

      vector.replaceChildren();
      const porK = [...filas].sort((a, b) => a.k - b.k);
      porK.forEach((f) => vector.appendChild(celda(f.k, f.c, String(f.k), `Posición ${f.k}: canal ${f.c}, muestra ${f.n}`, filas)));

      matriz.replaceChildren();
      matriz.style.gridTemplateColumns = `auto repeat(${N}, minmax(2.2rem, 1fr))`;
      matriz.appendChild(crear("span", { class: "bm-cab" }));
      for (let n = 0; n < N; n++) matriz.appendChild(crear("span", { class: "bm-cab", text: `t${n}` }));
      for (let c = 0; c < C; c++) {
        matriz.appendChild(crear("span", { class: "bm-cab", text: `canal ${c}` }));
        for (let n = 0; n < N; n++) {
          const f = filas.find((x) => x.n === n && x.c === c);
          matriz.appendChild(celda(f.k, c, String(f.k), `Canal ${c}, muestra ${n}: posición ${f.k}`, filas));
        }
      }
      salida.textContent = "Pasa el cursor o el foco por una celda para ver su correspondencia.";
      nota.textContent = estado.orientacion === "MULTIPLEXED"
        ? `Datos: tabla del oráculo Lean (lake exe f01_tabla ${N} ${C}), SHA-256 ${datos.procedencia[String(C)].sha256.slice(0, 12)}…`
        : "Ilustración didáctica calculada en el navegador: no procede de una ejecución verificada.";
      nota.classList.toggle("bm-didactico", estado.orientacion !== "MULTIPLEXED");
    }

    pintar();
  }

  function iniciar() {
    document.querySelectorAll(".binario-matriz[data-datos]").forEach(montar);
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", iniciar);
  else iniciar();
})();
