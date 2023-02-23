ROCKS=4 # numero di rocce
SIZE=12 # lato quadrato mappa
RUNS=50  # numero run per esperimento

DIR="./rocksample_results"
ASP_NAME="../asp_rocksample.lp" #beginning of ASP file
mkdir -p $DIR
RK=1;
for TK in 3; do
    for N in 10; do
        echo "N == $((N)) ";

        # # lancia senza usare nessun euristica (neanche legal), si può rimuovere
        # ../release/pomcp --problem rocksample --size 12 --number 8 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=0 --treeknowledge=0;
        # mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))roks_noheur_$((N))part_$((RUNS))runs.xes";

        # # lancia con solo legal actions
        # ../release/pomcp --problem rocksample --size 12 --number 8 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=1 --treeknowledge=1;
        # mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))roks_legal_$((N))part_$((RUNS))runs.xes";

        # usa regole
        ../build/pomcp --problem rocksample --hardcoded=true --size 12 --number 4 --timeout 100000000 --mindouble $((N)) --maxdouble $((N)) --runs 50 --xes 1 --rolloutknowledge=$((RK)) --treeknowledge=$((TK)) --asp $ASP_NAME;
        mv ./log.xes "$DIR/rocksample_$((SIZE))X$((SIZE))_$((ROCKS))rocks_$((N))part_$((RUNS))runs.xes";
    done
done