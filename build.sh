#/bin/bash
rm -Rf .build Packages
swift build -Xcc -fblocks -Xswiftc -I/usr/local/include -Xlinker -L/usr/local/lib && make