# Generic cpp makefile for mBuild build process

# default parameters
CC = g++

include make.pre

# All Target
all: $(DEPS) $(SOURCE:%.cpp=%.o) $(TARGET)

# Other Targets
clean:
	-rm *.o
	-rm $(TARGET)

.PHONY: all make.post

%.a: $(SOURCE:%.cpp=%.o)
	ar r $(TARGET) *.o

%.so: $(SOURCE:%.cpp=%.o) $(LDLIBS)
	$(CXX) $(CXXFLAGS) -shared -o $(TARGET) *.o $(LDLIBS)
-include make.post
