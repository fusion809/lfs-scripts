function cdg {
    cd $HOME/GitHub/$1
}

function cdgm {
    cdg mine/$1
}

function cdsc {
    cdgm scripts/$1
}

function cdlfs {
    cdsc "lfs-scripts/$1"
}

function cdsh {
    cd $HOME/Shell/$1
}
