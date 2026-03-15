#!/bin/bash
set -e

# ========================================
# Stage9Clean36 full setup & build script
# F´ 3.1.0 + Python 3.10 + Stage9 deployment
# ========================================

WORKSPACE=~/fprime-workspace
FRAMEWORK=$WORKSPACE/fprime-3.1.0
DEPLOYMENT=Stage9Clean36
VENV=$WORKSPACE/fprime-3.10-venv

echo "=============================="
echo "Stage9Clean36 F´ full setup"
echo "=============================="

# 1️⃣ Install Python 3.10 system packages
echo "Installing system packages..."
sudo apt update
sudo apt install -y python3.10 python3.10-venv python3.10-dev git build-essential cmake

# 2️⃣ Remove old venv & create new one
echo "Creating Python 3.10 virtual environment..."
rm -rf $VENV
python3.10 -m venv $VENV
source $VENV/bin/activate

# 3️⃣ Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# 4️⃣ Clone F´ tools if missing
if [ ! -d "$WORKSPACE/fprime-tools" ]; then
    echo "Cloning F´ tools..."
    git clone -b v3.1.0 https://github.com/nasa/fprime-tools.git $WORKSPACE/fprime-tools
fi

# 5️⃣ Install F´ Python tools into venv
echo "Installing F´ Python tools..."
cd $WORKSPACE/fprime-tools
python setup.py install

# 6️⃣ Verify fprime-util
echo "Verifying fprime-util..."
which fprime-util
fprime-util --version

# 7️⃣ Clean Stage9 deployment
cd $WORKSPACE/Stage9Clean36
echo "Cleaning old build files..."
rm -rf build build-fprime-automatic* Deployments/Linux Deployments/$DEPLOYMENT
mkdir -p Deployments/$DEPLOYMENT

# 8️⃣ Create deployment CMakeLists.txt
cat <<EOF > Deployments/$DEPLOYMENT/CMakeLists.txt
add_fprime_subdirectory(.)
EOF

# 9️⃣ Create deployment settings.ini
cat <<EOF > Deployments/$DEPLOYMENT/settings.ini
[fprime]
framework_path=$FRAMEWORK
deployment=$DEPLOYMENT
EOF

# 🔹 Create Top module
mkdir -p Top/${DEPLOYMENT}Top
cat <<EOF > Top/${DEPLOYMENT}Top/Stage9Clean36Top.fpp
module ${DEPLOYMENT}Top
{
    components:
        LinuxMain
        Stage9MotorBridge
        ExampleComponent
}
EOF

cat <<EOF > Top/${DEPLOYMENT}Top/CMakeLists.txt
add_fprime_subdirectory(.)
EOF

# 🔹 Create Components
for comp in LinuxMain Stage9MotorBridge ExampleComponent; do
    mkdir -p Components/$comp
    echo "component $comp { }" > Components/$comp/$comp.fpp
    echo "add_fprime_subdirectory(.)" > Components/$comp/CMakeLists.txt
done

# 🔹 Create deployment FPP file
cat <<EOF > Deployments/$DEPLOYMENT/${DEPLOYMENT}.fpp
deployment $DEPLOYMENT Deployments/$DEPLOYMENT
{
    components:
        ${DEPLOYMENT}Top
}
EOF

# 🔹 Create top-level CMakeLists.txt
cat <<EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.18)
include(\$ENV{FPRIME_FRAMEWORK_PATH}/cmake/FPrime.cmake)
add_fprime_subdirectory(Top/${DEPLOYMENT}Top)
add_fprime_subdirectory(Components/LinuxMain)
add_fprime_subdirectory(Components/Stage9MotorBridge)
add_fprime_subdirectory(Components/ExampleComponent)
add_fprime_subdirectory(Deployments/$DEPLOYMENT)
EOF

# 10️⃣ Generate and build deployment
cd Deployments/$DEPLOYMENT
echo "Generating F´ project..."
fprime-util generate -v

echo "Building Linux deployment..."
fprime-util build -d Linux

echo "=============================="
echo "DONE: Stage9Clean36 fully built"
echo "Activate venv: source $VENV/bin/activate"
echo "=============================="
