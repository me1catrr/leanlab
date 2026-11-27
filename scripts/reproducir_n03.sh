#!/usr/bin/env bash
# =====================================================================
# reproducir_n03.sh — Reproduce todas las evidencias de N03 (filtrado)
#
# Uso (desde la raíz del repositorio):  bash scripts/reproducir_n03.sh
# BENCH aparte: julia --project=julia julia/scripts/bench_n03.jl
# =====================================================================
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
V=verification/N03
R=$V/registros
mkdir -p "$R" "$V/julia" "$V/subverso" "$V/oraculo_lean"
export GIT_CEILING_DIRECTORIES="$ROOT/lean/.lake/packages"

{
  echo "fecha: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "commit_base: $(git rev-parse HEAD)"
  echo "lean: $(lean --version)"
  echo "julia: $(julia --version)"
  echo "dsp.jl: $(julia --project=julia -e 'using DSP; print(pkgversion(DSP))')"
  echo "python: $(uv run --project python python --version)"
  echo "mne/numpy/scipy: $(uv run --project python python -c 'import mne, numpy, scipy; print(mne.__version__, numpy.__version__, scipy.__version__)')"
  echo "sistema: $(uname -sm)"
} > "$R/versiones.txt"

echo "▸ DATOS: señales sintéticas"
uv run --project python python scripts/n03_senales.py > /dev/null
if [ -f "$V/senales.sha256" ]; then
  (cd "$V/senales" && shasum -a 256 -c ../senales.sha256 > /dev/null) \
    || { echo "✗ las señales regeneradas no coinciden con senales.sha256"; exit 1; }
else
  (cd "$V/senales" && shasum -a 256 * > ../senales.sha256)
fi

echo "▸ PROOF: lake build, auditoría y oráculo exacto"
(cd lean && lake build LeanlabBook n03_filtro) > "$R/lake_build.log" 2>&1
(cd lean && lake env lean LeanlabBook/N03/Auditoria.lean) > "$R/axiomas.txt" 2>&1
! grep -q 'sorryAx' "$R/axiomas.txt"
(cd lean && lake exe n03_filtro < "../$V/senales/a1_entrada.txt") > "$V/oraculo_lean/a1.txt"

echo "▸ TEST: Julia"
julia --project=julia julia/test/runtests.jl > "$R/julia_test.log" 2>&1

echo "▸ CROSS: DSP.jl, SciPy, MNE"
julia --project=julia julia/scripts/n03_exportar.jl > /dev/null
uv run --project python python scripts/n03_cross.py > "$R/cross.txt" 2>&1
uv run --project python pytest python/tests -v > "$R/pytest.log" 2>&1

echo "▸ VISOR y fragmentos"
(cd lean && lake exe subverso-extract-mod LeanlabBook.N03.Recurrencia "../$V/subverso/Recurrencia.json") > "$R/subverso.log" 2>&1
uv run --project python python scripts/visor_lean.py "$V/subverso/Recurrencia.json" \
  book/aplicaciones/_n03-visor.md LeanlabBook.N03.filtro LeanlabBook.N03.convexa_acotada \
  LeanlabBook.N03.filtro_acotado LeanlabBook.N03.filtro_transitorio
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n03-un-polo.md julia \
  julia/src/N03Filtrado.jl:un_polo julia/src/N03Filtrado.jl:bloques
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n03-mutaciones.md julia \
  julia/test/n03.jl:mutaciones_n03

echo "▸ Componentes del Laboratorio"
uv run --project python python scripts/laboratorio.py > /dev/null

echo "▸ Saneado de rutas locales en los registros"
for f in "$R"/*.log "$R"/*.txt; do
  sed -i.bak -e "s#$ROOT#<repo>#g" -e "s#$HOME#~#g" "$f" && rm -f "$f.bak"
done

echo "▸ Huellas"
(cd "$V" && find . -type f ! -name SHA256SUMS ! -path './registros/*' ! -path './senales/*' | sort | xargs shasum -a 256 > SHA256SUMS)
echo "✓ N03 reproducido. Registros en $R"
