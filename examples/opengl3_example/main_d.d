import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

extern(C) int gl3wInit();
extern(C) int call_main() { return main(null); }

extern(C) int old_main();

extern(C) __gshared GLFWwindow* window;

extern(C) void error_callback(int error, const (char)* description) nothrow
{
    try { stderr.writefln("Error %d: %s\n", error, description); }
    catch (Exception e){}
}

int main(string[] args)
{
    DerelictGL3.load();
    DerelictGLFW3.load();
    
    // Setup window
    glfwSetErrorCallback(&error_callback);
    if (!glfwInit())
        return 1;
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    version(OSX) { glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); }
    window = glfwCreateWindow(1280, 720, "ImGui OpenGL3 example", null, null);
    glfwMakeContextCurrent(window);
    gl3wInit();
        
    //DerelictGL3.reload();
    return old_main();
}

import std.stdio: writefln, stderr;