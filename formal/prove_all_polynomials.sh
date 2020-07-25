#!/usr/bin/env bash
set -euf -o pipefail

# You can pass the number of processes to spawn at the command line like this:
#   NUM_PROCS=4 ./prove_all_polynomials.sh
NUM_PROCS="${NUM_PROCS:-24}"

for polynomial in {0..255}; do
    printf 'polynomial_0x%02x\n' "$polynomial"
done |
    xargs -P "$NUM_PROCS" -n 1 sby crc8.sby |
    awk '
        {print}
        /^SBY.*DONE (.*)$/ {
            results[$3]=$5 " " $6
        }
        END {
            print "RESULTS:"
            for (task in results) {
                printf("    %s %s\n", task, results[task])
            }
        }
    '
