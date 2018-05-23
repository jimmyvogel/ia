## Compilation automatique de source C
# Compilteur
CC := g++
#options de compilation
CFLAGS := --std=c++98 
EXEC=molecules
LIBS = -lGL -lglut -lm -lGLU -lGLEW -lpthread
LIBSDIR = -L/usr/X11R6/lib 
INCLDIR = -I/usr/include/GL

# Règle de compilation
all : $(EXEC)

molecules : molecules.o lecture_trajectoire.o shaders_utilities.o xdrfile.o 
	$(CC) $(CFLAGS) $(LIBSDIR) -o $@ $^ $(LIBS)	

xdrfile.o :
	gcc -c -o xdrfile.o xdrfile.c

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLDIR) -o $@ -c $< 


clean:
	rm -rf *.o $(EXEC)
