# LEANLAB · Normas para agentes

**LEANLAB — Scientific Software Verification & Engineering**

Este fichero es la **fuente normativa única** para todos los agentes: Claude Code, Codex y cualquier otro. `CLAUDE.md` lo importa y solo añade lo propio de Claude Code. Si alguna regla de este fichero choca con `LEANLAB_PLAN_MAESTRO.md`, se aplica la más restrictiva y se avisa al usuario.

## 1. Mandato

- **Qué es LEANLAB.** Un proyecto abierto de autoformación avanzada y experimentación metodológica. Responde a una pregunta: **¿cómo sabemos que nuestro código científico es correcto, eficiente, reproducible y adecuado para su propósito?**
- **Lema:** *Specify · Implement · Test · Prove · Compare · Optimize · Understand*.
- **Reparto de papeles:** la IA propone, las herramientas comprueban y el investigador decide.
- **Idioma:** castellano de España, con terminología técnica en inglés.
- **Público:** un investigador de ingeniería mecánica con experiencia en señales, vibraciones y computación científica. LEANLAB no es un curso de programación introductorio ni un segundo motor EEG.
- **Independencia.** LEANLAB es independiente de NeuroMIND. NeuroMIND es su primera aplicación, no su límite. Las aplicaciones futuras (BRINCADIANO, SMARTBRIDGES, docencia de ingeniería) se abordan cuando se autoricen, nunca antes.

## 2. Los cuatro pilares

| Pilar | Nombre | Pregunta | Herramientas |
|---|---|---|---|
| **TEST** | Software testing | ¿Se comporta la implementación como esperamos en los casos ensayados? | Julia `Test`, pytest, Aqua, JET, property-based testing, mutation testing |
| **PROOF** | Formal verification | ¿Qué propiedades podemos demostrar bajo hipótesis explícitas? | Lean 4, Mathlib, auditoría de axiomas |
| **CROSS** | Cross-implementation validation | ¿Coinciden implementaciones independientes dentro de tolerancias justificadas? | Julia, Python/NumPy, MNE-Python, GGIR (futuro) |
| **BENCH** | Performance engineering | ¿Qué recursos consume el algoritmo y por qué? | BenchmarkTools, Profile, hyperfine (diferido), asignaciones, escalabilidad |

Los pilares aportan evidencias distintas y ninguno sustituye a los demás. **Ninguno, ni siquiera PROOF, garantiza por sí solo la validez científica o clínica.**

Distinciones obligatorias:
- **Demostrar no es verificar la implementación.** Un teorema Lean sobre una especificación no demuestra que el código Julia o Python la implemente. La correspondencia entre especificación, modelo Lean y código ejecutable se declara siempre de forma explícita.
- **Aritmética exacta frente a punto flotante.** Lo demostrado sobre ℕ, ℤ, ℚ o ℝ no se traslada sin más a `Float32`, `Float64` ni a `Int` acotado. Hay que considerar redondeo, cancelación, *overflow*, NaN, Inf, denominadores nulos, unidades y tolerancias absolutas y relativas.
- **CROSS no es validación cruzada estadística de modelos.** Se distinguen la validación diferencial, la numérica, la metodológica y la científica o clínica.
- **MNE-Python es una referencia externa independiente, no la verdad.** Que Julia y MNE coincidan no prueba que ambas implementaciones sean correctas.
- **Los oráculos son fuentes complementarias de evidencia, no una jerarquía universal.** Son la solución analítica, los datos sintéticos con resultado conocido, una implementación independiente, una biblioteca de referencia y la experimentación. Cuál conviene depende de la afirmación científica.
- **BENCH no es una competición Julia contra Python.** Hay que separar compilación, ejecución calentada, memoria, I/O, copias y escalabilidad. Precisión, legibilidad, mantenibilidad y reproducibilidad se evalúan aparte. NumPy y MNE usan componentes compilados, así que comparar bibliotecas no equivale a comparar lenguajes. Siempre se valida antes de medir.

## 3. Arquitectura editorial

- **Foundations (F).** Conocimiento general reutilizable. Debe poder estudiarse sin conocer NeuroMIND.
- **Applications (N, B, S…).** Aplicación a proyectos científicos reales con datos sintéticos o públicos.
- **Code Studio.** Experimentación y visualización reproducible. Es una biblioteca pequeña de componentes Quarto, no una aplicación autónoma. Se desarrolla de forma incremental: solo se construye lo que necesita el capítulo activo.

**Identificadores permanentes y su representación editorial.**

| Tipo | Identificador | Se muestra como |
|---|---|---|
| Foundations | `F01` … `F08` | F01/08 |
| NeuroMIND | `N01` … `N10` | N01/10 |
| Propiedad | `F01-P01` | F01 · Property 01 |
| Futuro | `B01` (BRINCADIANO), `S01` (SMARTBRIDGES) | B01/XX, S01/XX |

El total de capítulos sale de una configuración editorial centralizada y es provisional. **Nunca forma parte de un identificador, una ruta, una referencia cruzada ni una ficha.**

## 4. Ecosistema y límites de acceso

| Proyecto | Sitio público | Acceso desde LEANLAB |
|---|---|---|
| LEANLAB | [me1catrr.github.io/leanlab](https://me1catrr.github.io/leanlab/) (este repositorio) | Escritura, dentro del alcance autorizado |
| Demostraciones Lean previas (subrogados, BH y wPLI) | Privadas; pendientes de una versión publicable | **Solo lectura.** Son patrimonio científico: no se modifican ni se recompilan sin autorización, y su historial no se reescribe |
| NeuroMIND | [me1catrr.github.io/NeuroMIND](https://me1catrr.github.io/NeuroMIND/) | Solo lectura. El motor no tiene licencia, así que su código no se redistribuye |
| JuliaDo · ClaudeDo · Resonancia · NeuroRiemann | [juliado](https://me1catrr.github.io/juliado/) · [claudedo](https://me1catrr.github.io/claudedo/) · [resonancia](https://me1catrr.github.io/resonancia/) · [neuroriemann](https://me1catrr.github.io/neuroriemann/) | Solo lectura. Se enlazan; no se duplican |

**Contexto local.** Las rutas en esta máquina, los repositorios privados y los commits de referencia están en `docs/CONTEXTO-LOCAL.md`. Ese fichero está excluido de git y del sitio. Si no existe, el agente debe preguntar en lugar de suponer.

- Los hallazgos sobre otros proyectos se **notifican** al proyecto propietario y **no se corrigen** desde aquí.
- Toda referencia indica repositorio, ruta, símbolo, commit, licencia y configuración exactos.
- LEANLAB no mantiene *forks* científicos divergentes.
- Los cursos se enlazan en la sección pertinente en lugar de repetir su contenido. Los enlaces van en un solo sentido: JuliaDo y ClaudeDo no enlazan a otros cursos.

## 5. Privacidad, licencias y publicación

- **Prohibido en LEANLAB:**
  - datos clínicos y grabaciones reales;
  - nombres de archivos de adquisición o identificadores de sujetos;
  - rutas privadas, secretos y correos;
  - código de repositorios sin licencia compatible.

  En su lugar se usan **datos sintéticos** o **públicos con licencia compatible**.
- No se accede a los datos clínicos de NeuroMIND ni a ningún otro dato de participantes.
- **Licencias previstas** (pendientes de confirmar): MIT para el código original y CC BY-SA 4.0 para el contenido docente original. Que un recurso sea de acceso abierto no implica que pueda redistribuirse; la licencia de cada recurso se revisa una a una.
- **No se publica** en GitHub Pages ni en ningún otro sitio sin autorización explícita. Pages es estático y no ejecuta Lean, Julia ni Python.

## 6. Política de evidencia

**Estado de ejecución.** Cada evidencia tiene exactamente uno de estos estados:

| Estado | Significado |
|---|---|
| `PROPOSED` | Experimento o propiedad por estudiar |
| `ILLUSTRATIVE` | Maqueta o simulación didáctica |
| `REPORTED` | Resultado comunicado, todavía no comprobado |
| `INSPECTED` | Evidencia existente, inspeccionada pero no reejecutada |
| `REPRODUCED` | Resultado reproducido mediante ejecución registrada |
| `FAILED` | Comprobación realizada sin éxito |

**Aceptación científica.** Es una dimensión independiente con cuatro valores: `pendiente`, `requiere revisión`, `aceptada` y `rechazada`. Una evidencia `REPRODUCED` puede seguir pendiente de aceptación.

Reglas:
- **Lean:** prohibidos `sorry`, `admit`, `native_decide` sin justificar y los axiomas propios en resultados aceptados. `#print axioms` es obligatorio. Se registran hipótesis, alcance, dependencias, toolchain y la revisión de Mathlib.
- **Origen de los datos mostrados:**
  - Cifras, perfiles, trazas y objetivos Lean presentados como reales salen de ejecuciones o elaboraciones reales.
  - Las simulaciones JS se rotulan como **didácticas**.
  - Nunca se inventan resultados, sellos de validación, referencias ni DOI.
- **Sin porcentajes globales de verificación.** Se muestra qué propiedades concretas están verificadas y cuáles siguen pendientes.
- **Tolerancias:** se fijan **antes** de comparar. Si cambian después de ver los resultados, se registra una nueva versión del protocolo. Se informa del error máximo, el RMSE y los residuos, no solo de la correlación.
- **Discrepancias:** se clasifican como error, diferencia metodológica, precisión, referencia no comparable o pendiente.
- **Ficha de evidencia normalizada** (detalle en `docs/00-diagnostico.md`). Campos:
  - ID y propiedad;
  - especificación e hipótesis;
  - código y commit;
  - TEST, PROOF, CROSS y BENCH;
  - axiomas y auditoría;
  - correspondencia formal↔implementación;
  - entorno y comando de reproducción;
  - tolerancias y resultados;
  - huellas SHA-256;
  - referencias;
  - limitaciones;
  - estado de ejecución y aceptación.
- **Huellas:** fixtures, evidencias y artefactos llevan SHA-256. Semillas, versiones y comandos quedan registrados.

## 7. Herramientas y papeles

| Herramienta | Papel |
|---|---|
| Cursor · VS Code | Edición, Lean InfoView, objetivos, diagnóstico y navegación. VS Code es la referencia de compatibilidad de la extensión Lean |
| Warp | Ejecución reproducible de Lake, Julia, uv, Quarto y benchmarks |
| Claude Code | Ejecutor principal: implementación, documentación, pruebas y coordinación |
| Codex | Revisión independiente, contraejemplos y auditoría, cuando se autorice |
| ChatGPT | Apoyo a la dirección científica, a las decisiones y a la bibliografía |
| FigureLabs · SVG · D3 | Diagramas y comunicación visual. **Nunca** inventan datos cuantitativos |
| Julia · Lean 4 + Mathlib · Python + uv | Cálculo, demostración y referencia externa |
| Quarto · Typst · LaTeX | Libro HTML, PDF editorial (segunda fase) y publicaciones |
| Git · GitHub | Versionado, trazabilidad, CI y Pages (cuando se autorice) |

**Ninguna IA garantiza la corrección.** Las garantías proceden de las pruebas, del núcleo de Lean, de las especificaciones y de las evidencias reproducibles. Dos agentes de IA no constituyen una revisión científica independiente.

**Versiones observadas el 25-11-2026:**
- Lean 4.36.0, Lake 5.0.0, elan 4.4.0;
- Mathlib v4.36.0 (`fc4f59e5`);
- Julia 1.12.3;
- uv 0.12.23; Python 3.11.4 del sistema, aún sin fijar para LEANLAB;
- Quarto 1.10.19, Typst 0.15.1.

## 8. Flujo de trabajo

1. **Propuesta → revisión → decisión humana.** Se entrega un único informe consolidado con bloqueos, decisiones y siguiente paso. Se evitan los ciclos de revisión.
2. **Sesiones con alcance explícito.** Al cerrar la sesión autorizada, el agente se detiene. No avanza solo a la siguiente.
3. **Nada irreversible sin autorización:** `git init`, *push*, publicación, instalación de dependencias, migraciones y borrados.
4. **Dependencias mínimas.** Se adoptan solo las justificadas por el capítulo activo, con versiones fijadas: `lean-toolchain` y `lake-manifest.json`; `Project.toml` y `Manifest.toml`; `pyproject.toml` y `uv.lock`.
5. **Cada afirmación de un informe lleva una etiqueta:** **[comprobado]** con su comando o ruta, **[propuesta]** o **[pendiente]**.

## 9. Estructura actual

```text
leanlab/
  AGENTS.md · CLAUDE.md      normas para agentes
  README.md                  presentación del repositorio
  LICENSE · LICENSE-CONTENIDO · CITATION.cff
  book/                      libro Quarto (fuentes); se renderiza en book/_book/
    _quarto.yml              configuración del libro
    _editorial.yml           totales editoriales provisionales (F/08, N/10)
    assets/                  tema SCSS, CSS y marca
  lean/                      paquete Lake leanlab_book (Lean 4.36.0, Mathlib v4.36.0, SubVerso)
  julia/                     paquete LeanlabJulia (implementaciones, Test, benchmarks)
  python/                    referencias NumPy y pytest (uv, Python 3.12)
  verification/              fichas de evidencia (F01-P01.yml) y artefactos con SHA256SUMS
  scripts/                   reproducción (reproducir_f01.sh), visor Lean, guardianes
  .github/workflows/         publicación, guardián de publicación y verificación (CI)
```

**Precaución con Lake.** Ejecuta siempre `lake` con `GIT_CEILING_DIRECTORIES=<repo>/lean/.lake/packages`, como hace `scripts/reproducir_f01.sh`. Si la clonación de un paquete falla a medias, git podría subir hasta el repositorio padre y modificarlo.

**No versionados**, porque `.gitignore` los excluye y nunca se publican:
- `docs/`: informes internos de sesión, registro de decisiones y contexto local;
- `materiales/`: maquetas y material de terceros;
- `LEANLAB_PLAN_MAESTRO.md`: documento rector v0.1, que no se modifica.

La estructura objetivo (§11 del Plan Maestro) se crea de forma incremental, sesión a sesión. Las carpetas `lean/`, `julia/` y `python/` llegarán con F01.
