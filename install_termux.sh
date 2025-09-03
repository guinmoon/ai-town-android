#!/bin/bash
echo "Updating package list and upgrading installed packages"
apt update && apt upgrade

echo "Installing required dependencies: clang, wget, just, python, cmake, libcurl, git, screen, proot-distro, nodejs-lTS"
apt install clang wget just python cmake libcurl git screen proot-distro nodejs-lts

echo "Installing Debian Linux distribution via proot-distro"
proot-distro install debian

echo "Creating .gyp directory and configuration file for Android NDK path"
mkdir ~/.gyp && echo "{'variables':{'android_ndk_path':''}}" > ~/.gyp/include.gypi

echo "Cloning AI Town Android repository with all submodules"
git clone --recurse-submodules https://github.com/guinmoon/ai-town-android

echo "Changing directory to ai-town-android"
cd ai-town-android

echo "Downloading precompiled convex backend for aarch64 architecture"
wget https://github.com/get-convex/convex-backend/releases/download/precompiled-2025-08-20-c9b561e/convex-local-backend-aarch64-unknown-linux-gnu.zip

echo "Unzipping the downloaded convex backend package"
unzip convex-local-backend-aarch64-unknown-linux-gnu.zip
rm convex-local-backend-aarch64-unknown-linux-gnu.zip 

echo "Installing Node.js dependencies"
npm install

echo "Changing directory to llama.cpp"
cd llama.cpp

echo "Building llama.cpp with CPU-specific configurations"
cmake -B build_cpu  -DCMAKE_C_COMPILER=/data/data/com.termux/files/usr/bin/clang -DCMAKE_CXX_COMPILER=/data/data/com.termux/files/usr/bin/clang++ -DBUILD_SHARED_LIBS=OFF

echo "Compiling llama.cpp with 3 parallel jobs in Release mode"
cmake --build build_cpu --config Release -j3

echo "Making all shell scripts executable in current directory"
chmod +x *.sh

echo "Returning to previous directory"
cd ..