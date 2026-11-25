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
lean/                 demostraciones Lean 4 + Mathlib (PROOF)
julia/                implementaciones, pruebas y benchmarks en Julia (TEST, BENCH)
python/               referencias NumPy y pytest (CROSS)
verification/         fichas de evidencia y artefactos con huellas SHA-256
scripts/              reproducción, visor de demostraciones y guardianes
.github/workflows/    publicación, guardián de publicación y verificación
AGENTS.md, CLAUDE.md  normas para agentes de IA que colaboran en el proyecto
```

## Reproducir y compilar en local

Versiones usadas: Lean 4.36.0 (elan), Julia 1.12.3, uv 0.12.23 (Python 3.12) y Quarto 1.10.19. El apéndice [Preparar el entorno](https://me1catrr.github.io/leanlab/entorno.html) explica la instalación.

```bash
bash scripts/reproducir_f01.sh          # PROOF, TEST, CROSS de F01
quarto render book                      # el libro
bash scripts/check-site.sh book/_book   # comprobaciones antes de publicar
```

## Licencias

- Código original: [MIT](LICENSE).
- Textos y figuras originales: [CC BY-SA 4.0](LICENSE-CONTENIDO).
- Cómo citar: [CITATION.cff](CITATION.cff).
