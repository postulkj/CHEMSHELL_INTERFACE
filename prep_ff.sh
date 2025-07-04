#!/bin/bash

QMatom=24
natom=1824
init_geom=mini_geom.xyz

MMatom=$( echo "$natom-$QMatom" | bc )
# get atom type and make it lower case
first_atom=$(head -3 $init_geom | tail -1 | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
# This prepares the definition of the first atom 
cat > ff.dat << EOF
query a1 "first atom"
supergroup $first_atom
target $first_atom
EOF
index=2
# Loop through 5 last atoms 
for atom in $(tail -5 $init_geom | awk '{print $1}'); do
cat >> ff.dat << EOF
atom ${atom,,}
connect 1 $index
EOF
index=$((index + 1))
done
cat >> ff.dat << EOF
endquery

EOF


# Definition of the remaining QM atoms
for i in $(seq 2 $QMatom); do
    atom_type=$(head -$( echo "$i+2" | bc ) $init_geom | tail -1 | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
cat >> ff.dat << EOF
query a$i "QM atom $i"
supergroup $atom_type
target $atom_type
atom a$(echo "$i-1" | bc)
connect 1 2
endquery
EOF
done

