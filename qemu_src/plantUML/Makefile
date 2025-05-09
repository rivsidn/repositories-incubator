SRCS := $(wildcard *.puml)
OBJS := $(patsubst %.puml,%.png,$(SRCS))

# $(info $(SRCS))
# $(info $(OBJS))

all: $(OBJS)


%.png : %.puml
	plantuml $<
#	java -jar ~/Downloads/plantuml-lgpl-SNAPSHOT.jar $<

clean :
	rm *.png
