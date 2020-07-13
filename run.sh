#!/bin/sh

cd app
Rscript ./main.R "$@" || echo "run error code: $?"
