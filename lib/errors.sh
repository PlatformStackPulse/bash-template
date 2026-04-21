#!/usr/bin/env bash
# lib/errors.sh — Standard error codes and error handling utilities
#
# Usage:
#   source lib/errors.sh
#   exit $ERR_INVALID_INPUT
#   error_message $ERR_NOT_FOUND

# Prevent double-sourcing
[[ -n "${_ERRORS_SH_LOADED:-}" ]] && return 0
readonly _ERRORS_SH_LOADED=1

# Standard error codes (10-29 reserved for application errors)
readonly ERR_INVALID_INPUT=10
readonly ERR_NOT_FOUND=11
readonly ERR_PERMISSION=12
readonly ERR_TIMEOUT=13
readonly ERR_CONFIGURATION=14
readonly ERR_DEPENDENCY=15
readonly ERR_CONFLICT=16
readonly ERR_INTEGRATION=17

error_message() {
    local code="$1"
    case "$code" in
        10) echo "Invalid input" ;;
        11) echo "Not found" ;;
        12) echo "Permission denied" ;;
        13) echo "Operation timed out" ;;
        14) echo "Configuration error" ;;
        15) echo "Missing dependency" ;;
        16) echo "Conflict" ;;
        17) echo "Integration error" ;;
        *)  echo "Unknown error (code: $code)" ;;
    esac
}

# Trap handler for unexpected errors (use with: trap 'on_error $LINENO' ERR)
on_error() {
    local line="$1"
    local exit_code=$?
    echo "Error on line $line (exit code: $exit_code)" >&2
    exit "$exit_code"
}
