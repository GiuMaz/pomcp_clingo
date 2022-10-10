ROCKS=4 # numero di rocce
SIZE=12 # lato quadrato mappa
RUNS=50  # numero run per esperimento

DIR="./rocksample_results"
mkdir -p $DIR
for N in 8 9 10 11 12 13 14 15 16; do
    echo "N == $((N)) ";

    # lancia senza usare nessun euristica (neanche legal), si può rimuovere
    ../release/pomcp --problem rocksample --size 12 --number 8 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=0 --treeknowledge=0;
    mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))roks_noheur_$((N))part_$((RUNS))runs.xes";

    # lancia con solo legal actions
    ../release/pomcp --problem rocksample --size 12 --number 8 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=1 --treeknowledge=1;
    mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))roks_legal_$((N))part_$((RUNS))runs.xes";

    # usa regole
    ../release/pomcp --problem rocksample --size 12 --number 8 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=2 --treeknowledge=3 --smarttreecount 10 --smarttreevalue 20;
    mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))roks_rules_$((N))part_$((RUNS))runs.xes";

done

