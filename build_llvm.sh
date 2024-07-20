#!/usr/bin/env bash
set -e
set -u

# Set these by yourself
LLVM_DIR_NAME=llvmorg-18.1.5 # Name of the llvm source directory (needs to be a subdir of the PREFIX path)
PREFIX=/home/blesel/projects # Where the source, build and install directories should be located

SRC_PATH=${PREFIX}/${LLVM_DIR_NAME}
BUILD_PATH=${PREFIX}/${LLVM_DIR_NAME}-build
INSTALL_PATH=${PREFIX}/${LLVM_DIR_NAME}-install
BOOTSTRAP_PATH=${PREFIX}/${LLVM_DIR_NAME}-bootstrap

# Required software
# module load cmake
# module load ninja
# module load perl


echo -e "LLVM will be installed at ${INSTALL_PATH}"

echo "Press <enter> to continue"
read

echo -e "Building Clang+lld for bootstraping"

mkdir -p ${BOOTSTRAP_PATH}
cd ${BOOTSTRAP_PATH}
echo -e $(pwd)

cmake -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU;NVPTX" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_INSTALL_PREFIX=${BOOTSTRAP_PATH}-install \
    -G "Ninja" ${SRC_PATH}/llvm

ninja -j 48

export PATH=${BOOTSTRAP_PATH}/bin:$PATH


mkdir -p ${BUILD_PATH}
cd ${BUILD_PATH}
echo -e $(pwd)

echo -e "Running CMake"

cmake -DLLVM_ENABLE_PROJECTS="clang;lldb;mlir;polly;lld;clang-tools-extra;pstl;flang" \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt;openmp" \
    -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU;NVPTX" \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_ENABLE_LLD=ON \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} \
    -G "Ninja" ${SRC_PATH}/llvm
    # In case you want to use this build to do llvm development use the follwing lines instead \
    # -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    # -DLLVM_ENABLE_ASSERTIONS=ON \
    # -DLLVM_ENABLE_DUMP=ON \
    # -DLLVM_OPTIMIZED_TABLEGEN=ON \
   
echo -e "Bulding LLVM"
ninja -j 48
ninja install

rm -rf ${BOOTSTRAP_PATH}

# Using the built libcxx
# https://libcxx.llvm.org/UsingLibcxx.html#alternate-libcxx
