#!/bin/bash
fun ()
{
  x1=$1
  x2=$2
  command="(s($x1-1) + ($x1^2 + $x2^2))"
  result=$(bc -l <<< $command)
}
echo "Start calculation."
fun $1 $2
echo "The result is $result!" > "result.txt"
echo "Finish calculation."

