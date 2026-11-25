# LEANLAB

**Scientific Software Verification & Engineering**

¿Cómo sabemos que nuestro código científico es correcto, eficiente, reproducible y adecuado para su propósito?

LEANLAB es un libro abierto de autoformación que responde combinando cuatro tipos de evidencia:

| Pilar | Nombre | Pregunta |
|---|---|---|
| **TEST** | Software testing | ¿Se comporta la implementación como esperamos en los casos ensayados? |
| **PROOF** | Formal verification | ¿Qué propiedades podemos demostrar bajo hipótesis explícitas? (Lean 4 + Mathlib) |
| **CROSS** | Cross-implementation validation | ¿Coinciden implementaciones independientes dentro de tolerancias justificadas? |
| **BENCH** | Performance engineering | ¿Qué recursos consume el algoritmo y por qué? |

📖 **Libro:** <https://me1catrr.github.io/leanlab/>

> **Estado: versión editorial 0.1, en construcción.** Esta edición contiene la presentación, la declaración metodológica, el itinerario y la hoja de ruta. Todavía no hay capítulos ni resultados publicados.

## Estructura

```text
book/                 fuentes Quarto del libro (se renderiza en book/_book/)
scripts/              guardián de publicación y comprobación del sitio
.github/workflows/    publicación en GitHub Pages y guardián de publicación
AGENTS.md, CLAUDE.md  normas para agentes de IA que colaboran en el proyecto
```

## Compilar en local

Requisito: [Quarto](https://quarto.org/) 1.10.19.

```bash
quarto render book
bash scripts/check-site.sh book/_book
```

## Licencias

- Código original: [MIT](LICENSE).
- Textos y figuras originales: [CC BY-SA 4.0](LICENSE-CONTENIDO).
- Cómo citar: [CITATION.cff](CITATION.cff).
