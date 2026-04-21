#!/usr/bin/env bats
# test/unit/logging_test.bats — Tests for lib/logging.sh

setup() {
    PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
    export NO_COLOR=1
    export VERBOSE="false"
    export LOG_FILE=""
    source "$PROJECT_ROOT/lib/logging.sh"
}

@test "log_info outputs INFO prefix" {
    run log_info "test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"[INFO]"* ]]
    [[ "$output" == *"test message"* ]]
}

@test "log_success outputs checkmark prefix" {
    run log_success "done"
    [ "$status" -eq 0 ]
    [[ "$output" == *"done"* ]]
}

@test "log_warning outputs to stderr" {
    run log_warning "careful"
    [[ "$output" == *"careful"* ]]
}

@test "log_error outputs to stderr" {
    run log_error "broken"
    [[ "$output" == *"broken"* ]]
}

@test "log_debug is silent when VERBOSE is false" {
    export VERBOSE="false"
    run log_debug "hidden"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "log_debug outputs when VERBOSE is true" {
    export VERBOSE="true"
    # Re-source to reset the guard
    unset _LOGGING_SH_LOADED
    source "$PROJECT_ROOT/lib/logging.sh"
    run log_debug "visible"
    [ "$status" -eq 0 ]
    [[ "$output" == *"visible"* ]]
}

@test "log_info writes to LOG_FILE when set" {
    local tmpfile
    tmpfile=$(mktemp)
    export LOG_FILE="$tmpfile"
    # Re-source to reset the guard
    unset _LOGGING_SH_LOADED
    source "$PROJECT_ROOT/lib/logging.sh"
    log_info "file log test"
    grep -q "file log test" "$tmpfile"
    rm -f "$tmpfile"
}
