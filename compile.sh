#!/usr/bin/tcsh

# The make step requires something like:
# setenv LD_LIBRARY_PATH $LD_LIBRARY_PATH\:$PREFIX/lib\:$PREFIX/lib64
# further steps additionally require:
# setenv PATH $PATH\:$PREFIX/bin

if ($#argv != 1) then
    echo "Usage: $0 PREFIX"
    exit 1
endif

set PREFIX=$argv[1]
set LIBPREFIX=$argv[1]

# GRASS GIS

git clone https://github.com/OSGeo/grass.git

cd grass

./configure \
    LDFLAGS="-L$LIBPREFIX/lib" \
    --prefix=$PREFIX/ \
    --with-zstd-includes=$LIBPREFIX/include \
    --with-zstd-libs=$LIBPREFIX/lib \
    --with-bzlib \
    --with-bzlib-includes=$LIBPREFIX/include \
    --with-bzlib-libs=$LIBPREFIX/lib \
    --with-bzlib \
    --with-bzlib-includes=$LIBPREFIX/include \
    --with-bzlib-libs=$LIBPREFIX/lib \
    --with-readline \
    --with-readline-includes=$LIBPREFIX/include \
    --with-readline-libs=$LIBPREFIX/lib \
    --with-openmp \
    --with-openmp-includes=$LIBPREFIX/include \
    --with-openmp-libs=$LIBPREFIX/lib \
    --with-tiff \
    --with-tiff-includes=$LIBPREFIX/include \
    --with-tiff-libs=$LIBPREFIX/lib \
    --with-freetype \
    --with-freetype-includes=$LIBPREFIX/include/freetype2 \
    --with-freetype-libs=$LIBPREFIX/lib \
    --with-sqlite-includes=$LIBPREFIX/include \
    --with-sqlite-libs=$LIBPREFIX/lib \
    --with-geos \
    --with-geos-includes=$LIBPREFIX/include \
    --with-geos-libs=$LIBPREFIX/lib \
    --with-pdal=$LIBPREFIX/bin/pdal-config \
    --with-proj-includes=$LIBPREFIX/include \
    --with-proj-libs=$LIBPREFIX/lib/ \
    --with-proj-share=$LIBPREFIX/share \
    --with-gdal=$LIBPREFIX/bin/gdal-config

make
make install

# additional runtime dependencies
# conda create --prefix bin/conda --clone /usr/local/apps/miniconda
# conda install --prefix bin/conda numpy
# for scripts:
# eval "$(conda shell.bash hook)"
# conda activate bin/conda
