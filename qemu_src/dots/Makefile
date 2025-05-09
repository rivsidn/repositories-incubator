SRCS := $(wildcard *.dot)
OBJS := $(patsubst %.dot,%.png,$(SRCS))

# $(info $(SRCS))
# $(info $(OBJS))

all: $(OBJS)


%.png : %.dot
	dot -Tpng $< -o $@

clean :
	rm *.png
