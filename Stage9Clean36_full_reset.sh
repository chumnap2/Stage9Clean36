#!/bin/bash
# Stage9Clean36 full reset and build script
# F Prime 3.1.0 Linux canonical setup
# Run inside fprime workspace with fprime-36-venv activated

set -e

# ----------------------------
# Variables
# ----------------------------
WORKSPACE="$HOME/fprime-workspace/fprime-3.1.0"
PROJECT="Stage9Clean36"
BUILD_DIR="$WORKSPACE/build-fprime-automatic-$PROJECT"
PROJECT_DIR="$WORKSPACE/Projects/$PROJECT"
TOOLCHAIN_DIR="$WORKSPACE/cmake/toolchain"
TOOLCHAIN_FILE="$TOOLCHAIN_DIR/$PROJECT.cmake"

# ----------------------------
# 1️⃣ Purge old build directories and project folder
# ----------------------------
echo "📁 Purging old build directories and artifacts..."
rm -rf "$BUILD_DIR"
rm -rf "$WORKSPACE/build-artifacts"
rm -rf "$PROJECT_DIR"
rm -f "$TOOLCHAIN_FILE"

# ----------------------------
# 2️⃣ Create fresh project folder
# ----------------------------
echo "🆕 Creating new project folder..."
mkdir -p "$PROJECT_DIR"

# ----------------------------
# 3️⃣ Create settings.ini
# ----------------------------
echo "📝 Writing settings.ini..."
cat > "$PROJECT_DIR/settings.ini" <<EOF
[framework]
framework_path = $WORKSPACE
project_root   = $WORKSPACE/Projects
platform       = linux
EOF

# ----------------------------
# 4️⃣ Create canonical Linux toolchain (correct location)
# ----------------------------
echo "⚙️ Creating canonical Linux toolchain..."
mkdir -p "$TOOLCHAIN_DIR"
cat > "$TOOLCHAIN_FILE" <<EOF
set(FPRIME_PLATFORM "linux")
set(FPRIME_BUILD_TYPE "Debug")
set(FPRIME_PROJECT_ROOT "$WORKSPACE/Projects")
EOF

# ----------------------------
# 5️⃣ Generate F′ project
# ----------------------------
echo "🛠️ Generating F Prime project..."
fprime-util generate "$PROJECT"

# ----------------------------
# 6️⃣ Build the project
# ----------------------------
echo "🏗️ Building project..."
fprime-util build "$PROJECT"

echo "✅ Stage9Clean36 reset and build complete!"
