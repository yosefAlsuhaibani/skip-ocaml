#!/bin/bash
set -e

echo "Running all tests..."

for src in src/test/*.ml; do
    base=$(basename "$src" .ml)
    bin="./build/$base"
    echo "----------------------------------------"
    echo "Running $bin..."
    if [ -x "$bin" ]; then
        output=$( { "$bin"; } 2>&1 ) || status=$?
        if echo "$output" | grep -q "Error in child: exited with code 2"; then
            echo "$output"
            echo "[EXPECTED FAILURE] $base: Error in child: exited with code 2"
        elif [ -n "$status" ]; then
            echo "$output"
            echo "[FAIL] $base exited with code $status"
            exit 1
        else
            echo "$output"
            echo "[OK] $base"
        fi
    else
        echo "[MISSING] $bin not found or not executable"
        exit 1
    fi
done

echo "All tests passed (including expected failures)."
