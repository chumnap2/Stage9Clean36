#!/bin/bash
# Stage9Clean36 full reset and build
# Run inside fprime workspace with fprime-36-venv activated

set -e

echo "📁 Removing old build cache and project folder..."
rm -rf build-fprime-automatic-Stage9Clean36
rm -rf Projects/Stage9Clean36

echo "🆕 Creating new Stage9Clean36 project folder..."
mkdir -p Projects/Stage9Clean36

echo "📝 Creating settings.ini..."
cat > Projects/Stage9Clean36/settings.ini <<EOF
[framework]
framework_path=/home/chumnap/fprime-workspace/fprime-3.1.0
EOF

echo "⚙️ Creating minimal toolchain..."
mkdir -p Projects/cmake/toolchain
cat > Projects/cmake/toolchain/Stage9Clean36.cmake <<EOF
# Minimal Linux toolchain for Stage9Clean36
set(FPRIME_PLATFORM "linux")
set(FPRIME_BUILD_TYPE "Debug")
EOF

echo "🛠️ Generating build cache..."
fprime-util generate Stage9Clean36

echo "🏗️ Building Stage9Clean36..."
fprime-util build Stage9Clean36

echo "✅ Stage9Clean36 reset and build complete!"
