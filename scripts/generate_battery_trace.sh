# Genera tracce per apprendimento

NUMBER=4 # max dist tra stazioni
RUNS=1000  # numero run per esperimento
POMCP="../build/pomcp" # indirizzo eseguibile POMCP
ASP_FILE="../asp_battery_open.lp" # nome file con regole asp
for SIZE in 35 50 75 100; do # SIZE = distanza massima percorso
    DIR="./battery_traces/battery_$((SIZE))"
    echo $DIR
    mkdir -p $DIR
    for N in 8 15; do
        echo "SIZE == $((SIZE)), N == $((N)) ";

        # use legal actions
        $POMCP --problem closed --size $((SIZE)) --number $((NUMBER)) --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs $((RUNS)) --xes 1 --rolloutknowledge=1 --treeknowledge=1;
        mv ./log.xes "$DIR/performance_legal_$((N))part_$((RUNS))runs.xes";
    done
done
