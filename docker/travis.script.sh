#!/bin/bash

# $1: astyle only (OFF, ON)
# $2: documentation only (OFF, ON)
# $3: compiler (gcc, clang)
# $4: moab version (5.1.0, master)

set -e

astyle_only=$1
doc_only=$2
compiler=$3
moab_version=$4

source /root/etc/env.sh ${compiler}

cd ${build_dir}/DAGMC-moab-${moab_version}/DAGMC

# Only run astyle
if [ "${astyle_only}" == "ON" ]; then
  bash docker/run_astyle.sh
  exit 0
fi

# Only build the documentation
if [ "${doc_only}" == "ON" ]; then
  make html
  exit 0
fi

# Run the tests
export TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}
export MW_REG_TEST_MODELS_URL=${MW_REG_TEST_MODELS_URL}
bash docker/run_tests.sh ${compiler} ${moab_version}
