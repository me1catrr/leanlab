#!/usr/bin/env bash
# =====================================================================
# reproducir_f01.sh — Reproduce todas las evidencias de F01-P01
#
# Uso (desde la raíz del repositorio):  bash scripts/reproducir_f01.sh
#
# PROOF  lake build + auditoría de axiomas + oráculo ejecutable (Lean)
# TEST   pruebas Julia (Test.jl)
# CROSS  tablas Julia + pytest (NumPy) contra el oráculo Lean
# VISOR  extracción SubVerso + fragmentos del libro
# BENCH  NO se ejecuta aquí (es lento y depende de la máquina):
#        julia --project=julia julia/scripts/bench_f01.jl
#
# Escribe los registros en verification/F01/registros/ y las huellas
# SHA-256 de todos los artefactos en verification/F01/SHA256SUMS.
# =====================================================================
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
V=verification/F01
R=$V/registros
mkdir -p "$R" "$V/oraculo_lean" "$V/julia" "$V/subverso"
# Evita que git suba al repositorio padre desde los paquetes de Lake.
export GIT_CEILING_DIRECTORIES="$ROOT/lean/.lake/packages"

{
  echo "fecha: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "commit: $(git rev-parse HEAD)"
  echo "lean: $(lean --version)"
  echo "lake: $(cd lean && lake --version)"
  echo "julia: $(julia --version)"
  echo "uv: $(uv --version)"
  echo "python: $(uv run --project python python --version)"
  echo "numpy: $(uv run --project python python -c 'import numpy; print(numpy.__version__)')"
  echo "sistema: $(uname -sm)"
} > "$R/versiones.txt"

echo "▸ PROOF: lake build"
(cd lean && lake build LeanlabBook f01_tabla) > "$R/lake_build.log" 2>&1
echo "▸ PROOF: auditoría de axiomas"
(cd lean && lake env lean LeanlabBook/F01/Auditoria.lean) > "$R/axiomas.txt" 2>&1
if grep -Eq 'sorryAx|depends on axioms: \[.*[^]]*(sorry)' "$R/axiomas.txt"; then
  echo "✗ hay sorry en la auditoría"; exit 1
fi
echo "▸ PROOF: oráculo ejecutable"
for t in 4x3 1x1 7x5 3x31; do
  (cd lean && lake exe f01_tabla "${t%x*}" "${t#*x}") > "$V/oraculo_lean/tabla_$t.json"
done

echo "▸ TEST: Julia"
julia --project=julia julia/test/runtests.jl > "$R/julia_test.log" 2>&1

echo "▸ CROSS: tablas Julia y pytest"
julia --project=julia julia/scripts/exportar_tabla.jl > /dev/null
uv run --project python pytest python/tests -v > "$R/pytest.log" 2>&1

echo "▸ VISOR: SubVerso"
(cd lean && lake exe subverso-extract-mod LeanlabBook.F01.Indice "../$V/subverso/Indice.json") > "$R/subverso.log" 2>&1
uv run --project python python scripts/visor_lean.py "$V/subverso/Indice.json" \
  book/fundamentos/_f01-visor-cota.md LeanlabBook.F01.idx LeanlabBook.F01.idx_lt
uv run --project python python scripts/visor_lean.py "$V/subverso/Indice.json" \
  book/fundamentos/_f01-visor-resto.md LeanlabBook.F01.idx_mod LeanlabBook.F01.idx_div \
  LeanlabBook.F01.idx_inj LeanlabBook.F01.idx_surj LeanlabBook.F01.idx1 LeanlabBook.F01.idx1_eq_idx_succ

echo "▸ Fragmentos de código para el libro"
uv run --project python python scripts/fragmento_codigo.py book/fundamentos/_f01-julia.md julia \
  julia/src/F01Indice.jl:indice julia/src/F01Indice.jl:matriz
uv run --project python python scripts/fragmento_codigo.py book/fundamentos/_f01-mutaciones.md julia \
  julia/test/runtests.jl:mutaciones
uv run --project python python scripts/fragmento_codigo.py book/fundamentos/_f01-numpy.md python \
  python/tests/test_f01_cross.py:matriz_numpy

echo "▸ Saneado de rutas locales en los registros"
for f in "$R"/*.log "$R"/*.txt; do
  sed -i.bak -e "s#$ROOT#<repo>#g" -e "s#$HOME#~#g" "$f" && rm -f "$f.bak"
done

echo "▸ Huellas"
(cd "$V" && find . -type f ! -name SHA256SUMS ! -path './registros/*' | sort | xargs shasum -a 256 > SHA256SUMS)
(cd lean && shasum -a 256 LeanlabBook/F01/*.lean lakefile.toml lake-manifest.json lean-toolchain) > "$R/fuentes_lean.sha256"
(shasum -a 256 julia/src/*.jl julia/test/*.jl julia/Project.toml julia/Manifest.toml python/tests/*.py python/pyproject.toml python/uv.lock) > "$R/fuentes_julia_python.sha256"
echo "✓ F01 reproducido. Registros en $R"
