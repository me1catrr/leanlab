#!/usr/bin/env bash
# =====================================================================
# reproducir_n02.sh — Reproduce todas las evidencias de N02 (control de calidad)
#
# Uso (desde la raíz del repositorio):  bash scripts/reproducir_n02.sh
# BENCH aparte: julia --project=julia julia/scripts/bench_n02.jl
# =====================================================================
set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"
V=verification/N02
R=$V/registros
mkdir -p "$R" "$V/julia" "$V/subverso"
export GIT_CEILING_DIRECTORIES="$ROOT/lean/.lake/packages"

{
  echo "fecha: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "commit_base: $(git rev-parse HEAD)"
  echo "lean: $(lean --version)"
  echo "julia: $(julia --version)"
  echo "python: $(uv run --project python python --version)"
  echo "mne/numpy/scipy: $(uv run --project python python -c 'import mne, numpy, scipy; print(mne.__version__, numpy.__version__, scipy.__version__)')"
  echo "sistema: $(uname -sm)"
} > "$R/versiones.txt"

echo "▸ DATOS: matrices sintéticas y oráculo exacto"
uv run --project python python scripts/n02_datos.py > /dev/null
if [ -f "$V/datos.sha256" ]; then
  (cd "$V/datos" && shasum -a 256 -c ../datos.sha256 > /dev/null) \
    || { echo "✗ los datos regenerados no coinciden con datos.sha256"; exit 1; }
else
  (cd "$V/datos" && shasum -a 256 * > ../datos.sha256)
fi

echo "▸ PROOF: lake build y auditoría"
(cd lean && lake build LeanlabBook) > "$R/lake_build.log" 2>&1
(cd lean && lake env lean LeanlabBook/N02/Auditoria.lean) > "$R/axiomas.txt" 2>&1
! grep -q 'sorryAx' "$R/axiomas.txt"

echo "▸ TEST: Julia"
julia --project=julia julia/test/runtests.jl > "$R/julia_test.log" 2>&1

echo "▸ CROSS: Julia, NumPy/SciPy, MNE y oráculo"
julia --project=julia julia/scripts/n02_exportar.jl > /dev/null
uv run --project python python scripts/n02_cross.py > "$R/cross.txt" 2>&1
uv run --project python pytest python/tests -v > "$R/pytest.log" 2>&1

echo "▸ VISOR y fragmentos"
(cd lean && lake exe subverso-extract-mod LeanlabBook.N02.Samuelson "../$V/subverso/Samuelson.json") > "$R/subverso.log" 2>&1
uv run --project python python scripts/visor_lean.py "$V/subverso/Samuelson.json" \
  book/aplicaciones/_n02-visor.md LeanlabBook.N02.samuelson_desv LeanlabBook.N02.z_le_tres \
  LeanlabBook.N02.once_canales_basta
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n02-qc.md julia \
  julia/src/N02Calidad.jl:control_calidad
uv run --project python python scripts/fragmento_codigo.py book/aplicaciones/_n02-mutaciones.md julia \
  julia/test/n02.jl:mutaciones_n02

echo "▸ Componentes del Laboratorio"
uv run --project python python scripts/laboratorio.py > /dev/null

echo "▸ Saneado de rutas locales en los registros"
for f in "$R"/*.log "$R"/*.txt; do
  sed -i.bak -e "s#$ROOT#<repo>#g" -e "s#$HOME#~#g" "$f" && rm -f "$f.bak"
done

echo "▸ Huellas"
(cd "$V" && find . -type f ! -name SHA256SUMS ! -path './registros/*' ! -path './datos/*' | sort | xargs shasum -a 256 > SHA256SUMS)
echo "✓ N02 reproducido. Registros en $R"
