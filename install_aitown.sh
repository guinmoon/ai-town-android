#!/bin/bash
apt update && apt upgrade
apt install clang  cmake libcurl git screen proot-distro nodejs-lts
proot-distro install debian
mkdir ~/.gyp && echo "{'variables':{'android_ndk_path':''}}" > ~/.gyp/include.gypi
npm install
cd llama.cpp
echo "building llama.cpp"
cmake -B build_cpu  -DCMAKE_C_COMPILER=/data/data/com.termux/files/usr/bin/clang -DCMAKE_CXX_COMPILER=/data/data/com.termux/files/usr/bin/clang++ -DBUILD_SHARED_LIBS=OFF
cmake --build build_cpu --config Release -j3

