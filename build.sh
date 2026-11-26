cd R
VERSION=$(cat VERSION)
CFLAGS="-std=c17 -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE" ./configure --without-recommended-packages --with-R-shlib --prefix=/local/Appz/R-${VERSION}-b2b
make
make install
cd ..

