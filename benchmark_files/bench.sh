#!/bin/bash

sequence="100 150 200 300 400 500 600 800 1000 1600"

echo STARTING TEST RUN

echo "$sequence"

for i in $sequence
do
	echo TEST STRING_SIZE=$i
	STRING_SIZE=$i stack build --test
done
