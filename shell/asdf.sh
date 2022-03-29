# shell/asdf.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/asdf.sh {"

# ============================================================================
# init
# ============================================================================

export ASDF_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_DATA_DIR="${ASDF_DIR}"
export ASDF_TOOL_VERSIONS_FILENAME=${XDG_CONFIG_HOME}/asdf/tool-versions

__kz_source ${ASDF_DIR}/asdf.sh

# ============================================================================
# completions
# ============================================================================

fpath=(${ASDF_DIR}/completions $fpath)

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"
