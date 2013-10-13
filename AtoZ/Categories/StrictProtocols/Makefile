CC = clang

MAIN = hello

SRCS = main.o Test.o

default: $(MAIN)

$(MAIN): $(SRCS)
 $(CC) -O0 -Wall -o $(MAIN) $(SRCS) -framework Foundation -framework Cocoa

clean:
 find . -name "*.o" -exec rm {} \;
 if [ -f "$(MAIN)" ]; then rm $(MAIN); fi

all: default


CC=clang

FRAMEWORKS:=	-framework Foundation\
				"

LIBRARIES:=		-lobjc\
				-all_load

SOURCE=NSObject+StrictProtocols.m

CFLAGS=-Wall -Werror -fobjc-arc -g -v $(SOURCE)
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)
OUT=
# -o main

O_FILES = $(SRC_FILES:%.cc=%.o)

all:
    $(CC) $(CFLAGS) $(LDFLAGS) $(OUT)