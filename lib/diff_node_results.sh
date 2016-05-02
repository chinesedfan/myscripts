#!/usr/bin/env sh

file2=$2

now=`date +%s`
out1=$1
out2=result_${now}_2.out

shift
shift

node ${file2} $* > ${out2}
echo "Comparing..."
diff -u ${out1} ${out2}
echo "...done!"
