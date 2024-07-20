#!/bin/bash

LLVM_PREFIX=/home/blesel/projects/llvmorg-18.1.5-install

export PATH=${LLVM_PREFIX}/bin:$PATH
export C_INCLUDE_PATH=${LLVM_PREFIX}/include:$C_INCLUDE_PATH
export LD_LIBRARY_PATH=${LLVM_PREFIX}/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=${LLVM_PREFIX}/lib:$LIBRARY_PATH
export LD_RUN_PATH=${LLVM_PREFIX}/lib:$LD_RUN_PATH
export CMAKE_PREFIX_PATH=${LLVM_PREFIX}:$CMAKE_PREFIX_PATH
export CC=${LLVM_PREFIX}/bin/clang
export CXX=${LLVM_PREFIX}/bin/clang++
