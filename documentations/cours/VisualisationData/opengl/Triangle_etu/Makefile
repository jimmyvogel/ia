CC := g++
CFLAGS := --std=c++98 

LIBS = -lGL -lglut -lm -lGLU -lGLEW -lpthread
LIBSDIR = -L/usr/X11R6/lib 
INCLDIR = -I/usr/include/GL

# Règle de compilation
all : code05_dessin 

code05_dessin : code05_dessin.o shaders_utilities.o 
	$(CC) $(CFLAGS) $(LIBSDIR) -o $@ $^ $(LIBS)


%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLDIR) -o $@ -c $< 


clean:
	rm *.o
