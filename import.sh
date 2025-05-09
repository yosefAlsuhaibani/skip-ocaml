#!/bin/bash

# -----------------------------------------------------------------------------
# TEMPORARY IMPORT SCRIPT FOR SKIP RUNTIME SOURCE
#
# I needed to get something working quickly with the Skip runtime, but making
# proper changes to the runtime and shipping an updated version is not exactly
# quick or convenient. So instead, I created a branch on my fork of the Skip
# repo (pikatchu/ocaml) and iterated directly on the runtime there.
#
# This script simply imports the runtime source files from that modified
# version into this project, so I can build and experiment without needing to
# publish and version a full new release of the runtime.
#
# Clearly, this is not how things should work long term. Long term, we should:
# - Modify the Skip runtime to accommodate other languages more cleanly
# - Use it as a proper dependency in this library
#
# But hey — this got me started, and that’s what mattered for now.
# -----------------------------------------------------------------------------

set -euo pipefail

# Paths - adjust as needed
SKIP_DIR="/home/julienv/skip/skiplang/prelude/target/host/release"
BUILD_ID="4107294a6d5e7b81"
BUILD_DIR="$SKIP_DIR/build/std-$BUILD_ID"
OUT_DIR="$BUILD_DIR/out"
SKIP_LL_SRC="$SKIP_DIR/deps/test-f1c54591ab302db5.ll"

# Source code directory for runtime
RUNTIME_SRC_DIR="/home/julienv/skip/skiplang/prelude/runtime"

# Backtrace static lib
BACKTRACE_LIB_SRC="$OUT_DIR/libbacktrace/lib/libbacktrace.a"

# Target directory
TARGET_DIR="./external"
RUNTIME_TARGET_DIR="$TARGET_DIR/runtime"

# Ensure target directories exist
mkdir -p "$TARGET_DIR"
mkdir -p "$RUNTIME_TARGET_DIR"

# Copy skip.ll
echo "Importing skip.ll..."
cp "$SKIP_LL_SRC" "$TARGET_DIR/skip.ll"

# Copy all runtime source files
echo "Importing runtime source files..."
cp "$RUNTIME_SRC_DIR"/*.cpp "$RUNTIME_TARGET_DIR/"
cp "$RUNTIME_SRC_DIR"/*.c "$RUNTIME_TARGET_DIR/"
cp "$RUNTIME_SRC_DIR"/*.h "$RUNTIME_TARGET_DIR/"

# Generate dummy backtrace source
echo "Generating dummy_backtrace.cpp..."
cat > "$RUNTIME_TARGET_DIR/dummy_backtrace.cpp" <<EOF
extern "C" {

struct backtrace_state {};

backtrace_state* backtrace_create_state(const char* filename, int threaded,
                                        void* (*error_callback)(void*, const char*, int),
                                        void* data) {
    return nullptr;
}

int backtrace_full(backtrace_state* state, int skip,
                   int (*callback)(void* data, void* pc, const char* filename, int lineno, const char* function),
                   void* error_callback, void* data) {
    return 0;
}

}
EOF

echo "Import complete."
