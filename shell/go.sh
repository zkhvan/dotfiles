# shell/go.sh

export KZ_SOURCE="${KZ_SOURCE} -> shell/go.sh {"

# ============================================================================

__kz_has 'go' && {
  PATH=$(go env GOPATH)/bin:${PATH}
}

# ============================================================================

KZ_SOURCE="${KZ_SOURCE} }"
