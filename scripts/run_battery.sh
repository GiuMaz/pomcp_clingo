# testa pomcp con e senza regole

NUMBER=4 # max dist tra stazioni
RUNS=50  # numero run per esperimento
POMCP="../build/pomcp" # indirizzo eseguibile POMCP
ASP_FILE="../asp_battery_open.lp" # nome file con regole asp
for SIZE in 35 50 75 100; do # SIZE = distanza massima percorso
    DIR="./battery_results/battery_$((SIZE))"
    echo $DIR
    mkdir -p $DIR
    for N in 8 9 10 11 12 13 14 15 16; do
        echo "SIZE == $((SIZE)), N == $((N)) ";
        $POMCP --problem closed --size $((SIZE)) --number $((NUMBER)) --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs $((RUNS)) --xes 1 --rolloutknowledge=0 --treeknowledge=0;
        mv ./log.xes "$DIR/performance_noheur_$((N))part_$((RUNS))runs.xes";
        $POMCP --problem closed --size $((SIZE)) --number $((NUMBER)) --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs $((RUNS)) --xes 1 --rolloutknowledge=1 --treeknowledge=1;
        mv ./log.xes "$DIR/performance_legal_$((N))part_$((RUNS))runs.xes";
        $POMCP --problem closed --size $((SIZE)) --number $((NUMBER)) --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs $((RUNS)) --xes 1 --rolloutknowledge=1 --treeknowledge=3 --smarttreecount 10 --smarttreevalue 50 --asp $ASP_FILE;
        mv ./log.xes "$DIR/performance_withrules_$((N))part_$((RUNS))runs.xes";
    done
done
