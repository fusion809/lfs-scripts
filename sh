    ATTEMPT_L1=$(echo $(gnuv bash) | sed 's/ /\n/g' | head -n 1)
    ATTEMPT_L2=$(echo $(gnuv bash) | sed 's/ /\n/g' | tail -n 1)

    if [[ $ATTEMPT_L1 == ${ATTEMPT_L2}.[0-9] ]]; then
         VERSION=${ATTEMPT_L1}
    else
         VERSION=${ATTEMPT_L2}
    fi

    printf "$VERSION\n"

