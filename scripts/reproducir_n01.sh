#!/usr/bin/env bash
# =====================================================================
# reproducir_n01.sh — Reproduce todas las evidencias de N01
#
# Uso (desde la raíz del repositorio):  bash scripts/reproducir_n01.sh
#
# DATOS  ficheros BrainVision sintéticos + comprobación de sus huellas
# PROOF  lake build + auditoría de axiomas (Lean)
# TEST   pruebas Julia (incluye F01 y N01)
# CROSS  lecturas Julia + MNE-Python + resultado analítico (pytest)
# VISOR  extracción SubVerso + fragmentos del libro
# BENCH  NO se ejecuta aquí: julia --project=julia julia/scripts/bench_n01.jl
# =====================================================================
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
V=verification/N01
R=$V/registros
mkdir -p "$R" "$V/julia" "$V/subverso"
export GIT_CEILING_DIRECTORIES="$ROOT/lean/.lake/packages"

{
  echo "fecha: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "commit_base: $(git rev-parse HEAD)"
  echo "lean: $(lean --version)"
  echo "julia: $(julia --version)"
  echo "python: $(uv run --project python python --version)"
  echo "mne: $(uv run --project python python -c 'import mne; print(mne.__version__)')"
  echo "numpy: $(uv run --project python python -c 'import numpy; print(numpy.__version__)')"
  echo "sistema: $(uname -sm)"
} > "$R/versiones.txt"

echo "▸ DATOS: ficheros sintéticos"
uv run --project python python scripts/n01_ficheros.py > /dev/null
if [ -f "$V/ficheros.sha256" ]; then
  (cd "$V/ficheros" && shasum -a 256 -c ../ficheros.sha256 > /dev/null) \
    || { echo "✗ los ficheros regenerados no coinciden con ficheros.sha256"; exit 1; }
else
  (cd "$V/ficheros" && shasum -a 256 * > ../ficheros.sha256)
fi

echo "▸ PROOF: lake build y auditoría"
(cd lean && lake build LeanlabBook) > "$R/lake_build.log" 2>&1
(cd lean && lake env lean LeanlabBook/N01/Auditoria.lean) > "$R/axiomas.txt" 2>&1
! grep -q 'sorryAx' "$R/axiomas.txt"

echo "▸ TEST: Julia"
julia --project=julia julia/test/runtests.jl > "$R/julia_test.log" 2>&1

echo "▸ CROSS: Julia, MNE y analítico"
julia --project=julia julia/scripts/n01_exportar.jl > /dev/null
uv run --project python python scripts/n01_cross.py > "$R/cross.txt"
uv run --project python pytest python/tests -v > "$R/pytest.log" 2>&1

echo "▸ VISOR y fragmentos"
(cd lean && lake exe subverso-extract-mod LeanlabBook.N01.Bytes "../$V/subverso/Bytes.json") > "$R/subverso.log" 2>&1
uv run --project python python scripts/visor_lean.py "$V/subverso/Bytes.json" \
  book/aplicaciones/_n01-visor.md LeanlabBook.N01.offset LeanlabBook.N01.offset_add_le \
  LeanlabBook.N01.completas LeanlabBook.N01.completas_caben LeanlabBook.N01.completas_maximas \
  LeanlabBook.N01.calibrar_asoc
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n01-etapas.md julia \
  julia/src/N01BrainVision.jl:etapas
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n01-mutaciones.md julia \
  julia/test/n01.jl:mutaciones_n01

echo "▸ Componentes del Laboratorio"
uv run --project python python scripts/laboratorio.py > /dev/null

echo "▸ Saneado de rutas locales en los registros"
for f in "$R"/*.log "$R"/*.txt; do
  sed -i.bak -e "s#$ROOT#<repo>#g" -e "s#$HOME#~#g" "$f" && rm -f "$f.bak"
done

echo "▸ Huellas"
(cd "$V" && find . -type f ! -name SHA256SUMS ! -path './registros/*' ! -path './ficheros/*' | sort | xargs shasum -a 256 > SHA256SUMS)
echo "✓ N01 reproducido. Registros en $R"
