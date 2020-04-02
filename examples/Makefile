EOS_CFLAGS := $(INC_CFLAGS) -Os -g -pipe -Wall -fexceptions -fstack-protector -Wno-unused -Wno-uninitialized \
               -mtune=atom -fasynchronous-unwind-tables

.phony : clean

all : EOS_CFLAGS  += -m32 -march=i686
all : HelloWorld

clean:
	rm -f HelloWorld

HelloWorld: HelloWorld.cpp
	g++ -std=gnu++0x $(EOS_CFLAGS) -o $@ $^ -leos
