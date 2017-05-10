OBJS = imgui_impl_glfw_gl3.o
OBJS += ../../imgui.o ../../imgui_demo.o ../../imgui_draw.o
OBJS += ../libs/gl3w/GL/gl3w.o
OBJS += main_d.o main.o

LIBS = -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo
#LIBS += -L/usr/local/lib -lglfw3
LIBS += -L/usr/local/lib -lglfw -lphobos2

CXXFLAGS = -I../../ -I../libs/gl3w -I/usr/local/include
CXXFLAGS += -Wall -Wformat
CFLAGS = $(CXXFLAGS)

EXE = d_opengl3_example

main_d.o: main_d.d
	dmd -betterC -I/Users/edwarac/.dub/packages/derelict-glfw3-4.0.0-alpha.5/derelict-glfw3/source/ -I/Users/edwarac/.dub/packages/derelict-gl3-1.0.22/derelict-gl3/source/ -I/Users/edwarac/.dub/packages/derelict-util-2.1.0/derelict-util/source/ -c main_d.d

$(EXE): $(OBJS)
	$(CXX) -o $(EXE) $(OBJS) $(CXXFLAGS) $(LIBS) /Users/edwarac/.dub/packages/derelict-glfw3-4.0.0-alpha.5/derelict-glfw3/lib/libDerelictGLFW3.a /Users/edwarac/.dub/packages/derelict-gl3-1.0.22/derelict-gl3/lib/libDerelictGL3.a /Users/edwarac/.dub/packages/derelict-util-2.1.0/derelict-util/lib/libDerelictUtil.a