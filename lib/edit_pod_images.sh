#!/usr/bin/env sh

NAME=${1:-imeituan}
ROOT=${2:-/Users/zhong/Desktop/meituan/imeituan}
RELATIVE="Pods/Target Support Files/Pods-${NAME}/Pods-${NAME}-resources.sh"

subl3 "${ROOT}/${RELATIVE}"

