#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ASE_STUDIO_HOST_ROOT="$root_dir"
export LD_LIBRARY_PATH="$root_dir/../libs${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "$root_dir/ase_studio/launch.sh"
