#!/usr/bin/tcsh

set PREFIX=/usr/local/usrapps/mitasova/bin

# SQLite

wget https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
tar xvf sqlite-autoconf-3310100.tar.gz
cd sqlite-autoconf-3310100
./configure --prefix=$PREFIX
make
make install

# libTIFF

git clone https://gitlab.com/libtiff/libtiff.git
git checkout v4.1.0
./autogen.sh
./configure --prefix=$PREFIX
make
make install

# PROJ

git clone --depth=1 --branch 6.3.0 https://github.com/OSGeo/PROJ.git

cd PROJ

mkdir build
cd build

cmake \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DSQLITE3_INCLUDE_DIR=$PREFIX/include \
    -DSQLITE3_LIBRARY=$PREFIX/lib/libsqlite3.so \
    ..
make
make install

# GDAL

cp ../../bin/lib64/* ../../bin/lib

git clone https://github.com/OSGeo/gdal.git
cd gdal
git checkout v3.0.4

cd gdal

./configure \
    --prefix=$PREFIX/ \
    --with-proj=$PREFIX/ \
    --with-proj-share=$PREFIX/share \
    --with-sqlite3=$PREFIX \
    --with-geotiff=internal \
    --with-libtiff=internal
make
make install
