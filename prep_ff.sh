#!/bin/bash

QMatom=24
natom=1824
init_geom=mini_geom.xyz

MMatom=$( echo "$natom-$QMatom" | bc )
first_atom=$(head -3 $init_geom | tail -1 | awk '{print $1}')
# This prepares the definition of the first atom 
cat > ff.dat << EOF
query a1 "first atom"
supergroup $first_atom
target $first_atom
done
EOF
index=2
for atom in $(tail -5 $init_geom | awk '{print $1}'); do
cat >> ff.dat << EOF
atom $atom
connect 1 $index
EOF
index=$((index + 1))
done
cat >> ff.dat << EOF
endquery

EOF


# Definition of the remaining QM atoms
for i in $(seq 2 $QMatom); do
atom_type=$(head -$( echo "$i+2" | bc ) $init_geom | tail -1 | awk '{print $2}')
cat >> ff.dat << EOF
query a$i "QM atom $i"
supergroup $atom_type
target $atom_type
atom a1
connect 1 2
endquery
EOF
done

