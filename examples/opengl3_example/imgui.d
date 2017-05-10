extern(C):

// dear imgui, v1.50 WIP
// (headers)

// See imgui.cpp file for documentation.
// See ImGui::ShowTestWindow() in imgui_demo.cpp for demo code.
// Read 'Programmer guide' in imgui.cpp for notes on how to setup ImGui in your codebase.
// Get latest version at https://github.com/ocornut/imgui

//static if(!defined(IMGUI_DISABLE_INCLUDE_IMCONFIG_H) || defined(IMGUI_INCLUDE_IMCONFIG_H))
//import imconfig;       // User-editable configuration file
//}
//#include <stdarg.h>         // va_list
//#include <stddef.h>         // ptrdiff_t, NULL
//#include <string.h>         // memset, memmove, memcpy, strlen, strchr, strcpy, strcmp

enum IMGUI_VERSION = "1.50 WIP";

// Define attributes of all API symbols declarations, e.g. for DLL under Windows.
//#ifndef IMGUI_API
//#define IMGUI_API
//#endif

// Define assertion handler.
//#ifndef IM_ASSERT
//#include <assert.h>
//#define IM_ASSERT(_EXPR)    assert(_EXPR)
//#endif

//// Some compilers support applying printf-style warnings to user functions.
//#if defined(__clang__) || defined(__GNUC__)
//#define IM_PRINTFARGS(FMT) __attribute__((format(printf, FMT, (FMT+1))))
//#else
//#define IM_PRINTFARGS(FMT)
//#endif
//
//#if defined(__clang__)
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wold-style-cast"
//#endif

// Forward declarations
struct ImDrawChannel;               // Temporary storage for outputting drawing commands out of order, used by ImDrawList::ChannelsSplit()
struct ImDrawCmd;                   // A single draw command within a parent ImDrawList (generally maps to 1 GPU draw call)
struct ImDrawData;                  // All draw command lists required to render the frame
struct ImDrawList;                  // A single draw command list (generally one per window)
struct ImDrawVert;                  // A single vertex (20 bytes by default, override layout with IMGUI_OVERRIDE_DRAWVERT_STRUCT_LAYOUT)
struct ImFont;                      // Runtime data for a single font within a parent ImFontAtlas
struct ImFontAtlas;                 // Runtime data for multiple fonts, bake multiple fonts into a single texture, TTF font loader
struct ImFontConfig;                // Configuration data when adding a font or merging fonts
struct ImColor;                     // Helper functions to create a color that can be converted to either u32 or float4
struct ImGuiIO;                     // Main configuration and I/O between your application and ImGui
struct ImGuiOnceUponAFrame;         // Simple helper for running a block of code not more than once a frame, used by IMGUI_ONCE_UPON_A_FRAME macro
struct ImGuiStorage;                // Simple custom key value storage
struct ImGuiStyle;                  // Runtime data for styling/colors
struct ImGuiTextFilter;             // Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
struct ImGuiTextBuffer;             // Text buffer for logging/accumulating text
struct ImGuiTextEditCallbackData;   // Shared state of ImGui::InputText() when using custom ImGuiTextEditCallback (rare/advanced use)
struct ImGuiSizeConstraintCallbackData;// Structure used to constraint window size in custom ways when using custom ImGuiSizeConstraintCallback (rare/advanced use)
struct ImGuiListClipper;            // Helper to manually clip large list of items
struct ImGuiContext;                // ImGui context (opaque)

// Typedefs and Enumerations (declared as int for compatibility and to not pollute the top of this file)
alias ImU32 = uint;                 // 32-bit unsigned integer (typically used to store packed colors)
alias ImGuiID = uint;               // unique ID used by widgets (typically hashed from a stack of string)
alias ImWchar = ushort;             // character for keyboard input/display
alias ImTextureID = void*;          // user data to identify a texture (this is whatever to you want it to be! read the FAQ about ImTextureID in imgui.cpp)
alias ImGuiCol = int;               // a color identifier for styling       // enum ImGuiCol_
alias ImGuiStyleVar = int;          // a variable identifier for styling    // enum ImGuiStyleVar_
alias ImGuiKey = int;               // a key identifier (ImGui-side enum)   // enum ImGuiKey_
alias ImGuiColorEditMode = int;     // color edit mode for ColorEdit*()     // enum ImGuiColorEditMode_
alias ImGuiMouseCursor = int;       // a mouse cursor identifier            // enum ImGuiMouseCursor_
alias ImGuiWindowFlags = int;       // window flags for Begin*()            // enum ImGuiWindowFlags_
alias ImGuiSetCond = int;           // condition flags for Set*()           // enum ImGuiSetCond_
alias ImGuiInputTextFlags = int;    // flags for InputText*()               // enum ImGuiInputTextFlags_
alias ImGuiSelectableFlags = int;   // flags for Selectable()               // enum ImGuiSelectableFlags_
alias ImGuiTreeNodeFlags = int;     // flags for TreeNode*(), Collapsing*() // enum ImGuiTreeNodeFlags_

alias int function(ImGuiTextEditCallbackData *data) ImGuiTextEditCallback;
alias void function(ImGuiSizeConstraintCallbackData* data) ImGuiSizeConstraintCallback;

// Others helpers at bottom of the file:
// class ImVector<>                 // Lightweight std::vector like class.
// IMGUI_ONCE_UPON_A_FRAME          // Execute a block of code once per frame only (convenient for creating UI within deep-nested code that runs multiple times)

struct ImVec2
{
    float x = 0, y = 0;
    version (IM_VEC2_CLASS_EXTRA)
    {   // Define constructor and implicit cast operators in imconfig.h to convert back<>forth from your math types and ImVec2.
        alias IM_VEC2_CLASS_EXTRA = ()=>true; // temporary place holder, need to mix in frim imconfig.h
    }
}

struct ImVec4
{
    float x = 0, y = 0, z = 0, w = 0;
    version (IM_VEC4_CLASS_EXTRA)
    {   // Define constructor and implicit cast operators in imconfig.h to convert back<>forth from your math types and ImVec4.
        alias IM_VEC4_CLASS_EXTRA = ()=>true; // temporary place holder, need to mix in frim imconfig.h
    }
}

// ImGui end-user API
// In a namespace so that user can add extra functions in a separate file (e.g. Value() helpers for your vector or common types)
//namespace ImGui
//{
    // Main
immutable(ImGuiIO)*      GetIO()
{
    return GImGui.IO;
}

immutable(ImGuiStyle)*   GetStyle()
{
    return GImGui.Style;
}

// Same value as passed to your RenderDrawListsFn() function. valid after Render() and until the next call to NewFrame()
immutable(ImDrawData)*   GetDrawData()
{
    return GImGui.RenderDrawData.Valid ? &GImGui.RenderDrawData : null;
}

 //   void          NewFrame();                                 // start a new ImGui frame, you can submit any command from this point until NewFrame()/Render().
void NewFrame()
{
    /+ImGuiContext& g = *GImGui;

    // Check user data
    IM_ASSERT(g.IO.DeltaTime >= 0.0f);               // Need a positive DeltaTime (zero is tolerated but will cause some timing issues)
    IM_ASSERT(g.IO.DisplaySize.x >= 0.0f && g.IO.DisplaySize.y >= 0.0f);
    IM_ASSERT(g.IO.Fonts->Fonts.Size > 0);           // Font Atlas not created. Did you call io.Fonts->GetTexDataAsRGBA32 / GetTexDataAsAlpha8 ?
    IM_ASSERT(g.IO.Fonts->Fonts[0]->IsLoaded());     // Font Atlas not created. Did you call io.Fonts->GetTexDataAsRGBA32 / GetTexDataAsAlpha8 ?
    IM_ASSERT(g.Style.CurveTessellationTol > 0.0f);  // Invalid style setting

    if (!g.Initialized)
    {
        // Initialize on first frame
        g.LogClipboard = (ImGuiTextBuffer*)ImGui::MemAlloc(sizeof(ImGuiTextBuffer));
        IM_PLACEMENT_NEW(g.LogClipboard) ImGuiTextBuffer();

        IM_ASSERT(g.Settings.empty());
        LoadIniSettingsFromDisk(g.IO.IniFilename);
        g.Initialized = true;
    }

    SetCurrentFont(GetDefaultFont());
    IM_ASSERT(g.Font->IsLoaded());

    g.Time += g.IO.DeltaTime;
    g.FrameCount += 1;
    g.Tooltip[0] = '\0';
    g.OverlayDrawList.Clear();
    g.OverlayDrawList.PushTextureID(g.IO.Fonts->TexID);
    g.OverlayDrawList.PushClipRectFullScreen();

    // Mark rendering data as invalid to prevent user who may have a handle on it to use it
    g.RenderDrawData.Valid = false;
    g.RenderDrawData.CmdLists = NULL;
    g.RenderDrawData.CmdListsCount = g.RenderDrawData.TotalVtxCount = g.RenderDrawData.TotalIdxCount = 0;

    // Update inputs state
    if (g.IO.MousePos.x < 0 && g.IO.MousePos.y < 0)
        g.IO.MousePos = ImVec2(-9999.0f, -9999.0f);
    if ((g.IO.MousePos.x < 0 && g.IO.MousePos.y < 0) || (g.IO.MousePosPrev.x < 0 && g.IO.MousePosPrev.y < 0))   // if mouse just appeared or disappeared (negative coordinate) we cancel out movement in MouseDelta
        g.IO.MouseDelta = ImVec2(0.0f, 0.0f);
    else
        g.IO.MouseDelta = g.IO.MousePos - g.IO.MousePosPrev;
    g.IO.MousePosPrev = g.IO.MousePos;
    for (int i = 0; i < IM_ARRAYSIZE(g.IO.MouseDown); i++)
    {
        g.IO.MouseClicked[i] = g.IO.MouseDown[i] && g.IO.MouseDownDuration[i] < 0.0f;
        g.IO.MouseReleased[i] = !g.IO.MouseDown[i] && g.IO.MouseDownDuration[i] >= 0.0f;
        g.IO.MouseDownDurationPrev[i] = g.IO.MouseDownDuration[i];
        g.IO.MouseDownDuration[i] = g.IO.MouseDown[i] ? (g.IO.MouseDownDuration[i] < 0.0f ? 0.0f : g.IO.MouseDownDuration[i] + g.IO.DeltaTime) : -1.0f;
        g.IO.MouseDoubleClicked[i] = false;
        if (g.IO.MouseClicked[i])
        {
            if (g.Time - g.IO.MouseClickedTime[i] < g.IO.MouseDoubleClickTime)
            {
                if (ImLengthSqr(g.IO.MousePos - g.IO.MouseClickedPos[i]) < g.IO.MouseDoubleClickMaxDist * g.IO.MouseDoubleClickMaxDist)
                    g.IO.MouseDoubleClicked[i] = true;
                g.IO.MouseClickedTime[i] = -FLT_MAX;    // so the third click isn't turned into a double-click
            }
            else
            {
                g.IO.MouseClickedTime[i] = g.Time;
            }
            g.IO.MouseClickedPos[i] = g.IO.MousePos;
            g.IO.MouseDragMaxDistanceSqr[i] = 0.0f;
        }
        else if (g.IO.MouseDown[i])
        {
            g.IO.MouseDragMaxDistanceSqr[i] = ImMax(g.IO.MouseDragMaxDistanceSqr[i], ImLengthSqr(g.IO.MousePos - g.IO.MouseClickedPos[i]));
        }
    }
    memcpy(g.IO.KeysDownDurationPrev, g.IO.KeysDownDuration, sizeof(g.IO.KeysDownDuration));
    for (int i = 0; i < IM_ARRAYSIZE(g.IO.KeysDown); i++)
        g.IO.KeysDownDuration[i] = g.IO.KeysDown[i] ? (g.IO.KeysDownDuration[i] < 0.0f ? 0.0f : g.IO.KeysDownDuration[i] + g.IO.DeltaTime) : -1.0f;

    // Calculate frame-rate for the user, as a purely luxurious feature
    g.FramerateSecPerFrameAccum += g.IO.DeltaTime - g.FramerateSecPerFrame[g.FramerateSecPerFrameIdx];
    g.FramerateSecPerFrame[g.FramerateSecPerFrameIdx] = g.IO.DeltaTime;
    g.FramerateSecPerFrameIdx = (g.FramerateSecPerFrameIdx + 1) % IM_ARRAYSIZE(g.FramerateSecPerFrame);
    g.IO.Framerate = 1.0f / (g.FramerateSecPerFrameAccum / (float)IM_ARRAYSIZE(g.FramerateSecPerFrame));

    // Clear reference to active widget if the widget isn't alive anymore
    g.HoveredIdPreviousFrame = g.HoveredId;
    g.HoveredId = 0;
    g.HoveredIdAllowOverlap = false;
    if (!g.ActiveIdIsAlive && g.ActiveIdPreviousFrame == g.ActiveId && g.ActiveId != 0)
        ClearActiveID();
    g.ActiveIdPreviousFrame = g.ActiveId;
    g.ActiveIdIsAlive = false;
    g.ActiveIdIsJustActivated = false;

    // Handle user moving window (at the beginning of the frame to avoid input lag or sheering). Only valid for root windows.
    if (g.MovedWindowMoveId && g.MovedWindowMoveId == g.ActiveId)
    {
        KeepAliveID(g.MovedWindowMoveId);
        IM_ASSERT(g.MovedWindow && g.MovedWindow->RootWindow);
        IM_ASSERT(g.MovedWindow->RootWindow->MoveId == g.MovedWindowMoveId);
        if (g.IO.MouseDown[0])
        {
            if (!(g.MovedWindow->Flags & ImGuiWindowFlags_NoMove))
            {
                g.MovedWindow->PosFloat += g.IO.MouseDelta;
                if (!(g.MovedWindow->Flags & ImGuiWindowFlags_NoSavedSettings) && (g.IO.MouseDelta.x != 0.0f || g.IO.MouseDelta.y != 0.0f))
                    MarkIniSettingsDirty();
            }
            FocusWindow(g.MovedWindow);
        }
        else
        {
            ClearActiveID();
            g.MovedWindow = NULL;
            g.MovedWindowMoveId = 0;
        }
    }
    else
    {
        g.MovedWindow = NULL;
        g.MovedWindowMoveId = 0;
    }

    // Delay saving settings so we don't spam disk too much
    if (g.SettingsDirtyTimer > 0.0f)
    {
        g.SettingsDirtyTimer -= g.IO.DeltaTime;
        if (g.SettingsDirtyTimer <= 0.0f)
            SaveIniSettingsToDisk(g.IO.IniFilename);
    }

    // Find the window we are hovering. Child windows can extend beyond the limit of their parent so we need to derive HoveredRootWindow from HoveredWindow
    g.HoveredWindow = g.MovedWindow ? g.MovedWindow : FindHoveredWindow(g.IO.MousePos, false);
    if (g.HoveredWindow && (g.HoveredWindow->Flags & ImGuiWindowFlags_ChildWindow))
        g.HoveredRootWindow = g.HoveredWindow->RootWindow;
    else
        g.HoveredRootWindow = g.MovedWindow ? g.MovedWindow->RootWindow : FindHoveredWindow(g.IO.MousePos, true);

    if (ImGuiWindow* modal_window = GetFrontMostModalRootWindow())
    {
        g.ModalWindowDarkeningRatio = ImMin(g.ModalWindowDarkeningRatio + g.IO.DeltaTime * 6.0f, 1.0f);
        ImGuiWindow* window = g.HoveredRootWindow;
        while (window && window != modal_window)
            window = window->ParentWindow;
        if (!window)
            g.HoveredRootWindow = g.HoveredWindow = NULL;
    }
    else
    {
        g.ModalWindowDarkeningRatio = 0.0f;
    }

    // Are we using inputs? Tell user so they can capture/discard the inputs away from the rest of their application.
    // When clicking outside of a window we assume the click is owned by the application and won't request capture. We need to track click ownership.
    int mouse_earliest_button_down = -1;
    bool mouse_any_down = false;
    for (int i = 0; i < IM_ARRAYSIZE(g.IO.MouseDown); i++)
    {
        if (g.IO.MouseClicked[i])
            g.IO.MouseDownOwned[i] = (g.HoveredWindow != NULL) || (!g.OpenPopupStack.empty());
        mouse_any_down |= g.IO.MouseDown[i];
        if (g.IO.MouseDown[i])
            if (mouse_earliest_button_down == -1 || g.IO.MouseClickedTime[mouse_earliest_button_down] > g.IO.MouseClickedTime[i])
                mouse_earliest_button_down = i;
    }
    bool mouse_avail_to_imgui = (mouse_earliest_button_down == -1) || g.IO.MouseDownOwned[mouse_earliest_button_down];
    if (g.CaptureMouseNextFrame != -1)
        g.IO.WantCaptureMouse = (g.CaptureMouseNextFrame != 0);
    else
        g.IO.WantCaptureMouse = (mouse_avail_to_imgui && (g.HoveredWindow != NULL || mouse_any_down)) || (g.ActiveId != 0) || (!g.OpenPopupStack.empty());
    g.IO.WantCaptureKeyboard = (g.CaptureKeyboardNextFrame != -1) ? (g.CaptureKeyboardNextFrame != 0) : (g.ActiveId != 0);
    g.IO.WantTextInput = (g.ActiveId != 0 && g.InputTextState.Id == g.ActiveId);
    g.MouseCursor = ImGuiMouseCursor_Arrow;
    g.CaptureMouseNextFrame = g.CaptureKeyboardNextFrame = -1;
    g.OsImePosRequest = ImVec2(1.0f, 1.0f); // OS Input Method Editor showing on top-left of our window by default

    // If mouse was first clicked outside of ImGui bounds we also cancel out hovering.
    if (!mouse_avail_to_imgui)
        g.HoveredWindow = g.HoveredRootWindow = NULL;

    // Scale & Scrolling
    if (g.HoveredWindow && g.IO.MouseWheel != 0.0f && !g.HoveredWindow->Collapsed)
    {
        ImGuiWindow* window = g.HoveredWindow;
        if (g.IO.KeyCtrl)
        {
            if (g.IO.FontAllowUserScaling)
            {
                // Zoom / Scale window
                float new_font_scale = ImClamp(window->FontWindowScale + g.IO.MouseWheel * 0.10f, 0.50f, 2.50f);
                float scale = new_font_scale / window->FontWindowScale;
                window->FontWindowScale = new_font_scale;

                const ImVec2 offset = window->Size * (1.0f - scale) * (g.IO.MousePos - window->Pos) / window->Size;
                window->Pos += offset;
                window->PosFloat += offset;
                window->Size *= scale;
                window->SizeFull *= scale;
            }
        }
        else if (!(window->Flags & ImGuiWindowFlags_NoScrollWithMouse))
        {
            // Scroll
            const int scroll_lines = (window->Flags & ImGuiWindowFlags_ComboBox) ? 3 : 5;
            SetWindowScrollY(window, window->Scroll.y - g.IO.MouseWheel * window->CalcFontSize() * scroll_lines);
        }
    }

    // Pressing TAB activate widget focus
    // NB: Don't discard FocusedWindow if it isn't active, so that a window that go on/off programatically won't lose its keyboard focus.
    if (g.ActiveId == 0 && g.FocusedWindow != NULL && g.FocusedWindow->Active && IsKeyPressedMap(ImGuiKey_Tab, false))
        g.FocusedWindow->FocusIdxTabRequestNext = 0;

    // Mark all windows as not visible
    for (int i = 0; i != g.Windows.Size; i++)
    {
        ImGuiWindow* window = g.Windows[i];
        window->WasActive = window->Active;
        window->Active = false;
        window->Accessed = false;
    }

    // Closing the focused window restore focus to the first active root window in descending z-order
    if (g.FocusedWindow && !g.FocusedWindow->WasActive)
        for (int i = g.Windows.Size-1; i >= 0; i--)
            if (g.Windows[i]->WasActive && !(g.Windows[i]->Flags & ImGuiWindowFlags_ChildWindow))
            {
                FocusWindow(g.Windows[i]);
                break;
            }

    // No window should be open at the beginning of the frame.
    // But in order to allow the user to call NewFrame() multiple times without calling Render(), we are doing an explicit clear.
    g.CurrentWindowStack.resize(0);
    g.CurrentPopupStack.resize(0);
    CloseInactivePopups();

    // Create implicit window - we will only render it if the user has added something to it.
    ImGui::SetNextWindowSize(ImVec2(400,400), ImGuiSetCond_FirstUseEver);
    ImGui::Begin("Debug");+/
}

//    void          Render();                                   // ends the ImGui frame, finalize rendering data, then call your io.RenderDrawListsFn() function if set.
void Render()
{
    /+ImGuiContext& g = *GImGui;
    IM_ASSERT(g.Initialized);   // Forgot to call ImGui::NewFrame()

    if (g.FrameCountEnded != g.FrameCount)
        ImGui::EndFrame();
    g.FrameCountRendered = g.FrameCount;

    // Skip render altogether if alpha is 0.0
    // Note that vertex buffers have been created and are wasted, so it is best practice that you don't create windows in the first place, or consistently respond to Begin() returning false.
    if (g.Style.Alpha > 0.0f)
    {
        // Gather windows to render
        g.IO.MetricsRenderVertices = g.IO.MetricsRenderIndices = g.IO.MetricsActiveWindows = 0;
        for (int i = 0; i < IM_ARRAYSIZE(g.RenderDrawLists); i++)
            g.RenderDrawLists[i].resize(0);
        for (int i = 0; i != g.Windows.Size; i++)
        {
            ImGuiWindow* window = g.Windows[i];
            if (window->Active && window->HiddenFrames <= 0 && (window->Flags & (ImGuiWindowFlags_ChildWindow)) == 0)
            {
                // FIXME: Generalize this with a proper layering system so e.g. user can draw in specific layers, below text, ..
                g.IO.MetricsActiveWindows++;
                if (window->Flags & ImGuiWindowFlags_Popup)
                    AddWindowToRenderList(g.RenderDrawLists[1], window);
                else if (window->Flags & ImGuiWindowFlags_Tooltip)
                    AddWindowToRenderList(g.RenderDrawLists[2], window);
                else
                    AddWindowToRenderList(g.RenderDrawLists[0], window);
            }
        }

        // Flatten layers
        int n = g.RenderDrawLists[0].Size;
        int flattened_size = n;
        for (int i = 1; i < IM_ARRAYSIZE(g.RenderDrawLists); i++)
            flattened_size += g.RenderDrawLists[i].Size;
        g.RenderDrawLists[0].resize(flattened_size);
        for (int i = 1; i < IM_ARRAYSIZE(g.RenderDrawLists); i++)
        {
            ImVector<ImDrawList*>& layer = g.RenderDrawLists[i];
            if (layer.empty())
                continue;
            memcpy(&g.RenderDrawLists[0][n], &layer[0], layer.Size * sizeof(ImDrawList*));
            n += layer.Size;
        }

        // Draw software mouse cursor if requested
        if (g.IO.MouseDrawCursor)
        {
            const ImGuiMouseCursorData& cursor_data = g.MouseCursorData[g.MouseCursor];
            const ImVec2 pos = g.IO.MousePos - cursor_data.HotOffset;
            const ImVec2 size = cursor_data.Size;
            const ImTextureID tex_id = g.IO.Fonts->TexID;
            g.OverlayDrawList.PushTextureID(tex_id);
            g.OverlayDrawList.AddImage(tex_id, pos+ImVec2(1,0), pos+ImVec2(1,0) + size, cursor_data.TexUvMin[1], cursor_data.TexUvMax[1], IM_COL32(0,0,0,48));        // Shadow
            g.OverlayDrawList.AddImage(tex_id, pos+ImVec2(2,0), pos+ImVec2(2,0) + size, cursor_data.TexUvMin[1], cursor_data.TexUvMax[1], IM_COL32(0,0,0,48));        // Shadow
            g.OverlayDrawList.AddImage(tex_id, pos,             pos + size,             cursor_data.TexUvMin[1], cursor_data.TexUvMax[1], IM_COL32(0,0,0,255));       // Black border
            g.OverlayDrawList.AddImage(tex_id, pos,             pos + size,             cursor_data.TexUvMin[0], cursor_data.TexUvMax[0], IM_COL32(255,255,255,255)); // White fill
            g.OverlayDrawList.PopTextureID();
        }
        if (!g.OverlayDrawList.VtxBuffer.empty())
            AddDrawListToRenderList(g.RenderDrawLists[0], &g.OverlayDrawList);

        // Setup draw data
        g.RenderDrawData.Valid = true;
        g.RenderDrawData.CmdLists = (g.RenderDrawLists[0].Size > 0) ? &g.RenderDrawLists[0][0] : NULL;
        g.RenderDrawData.CmdListsCount = g.RenderDrawLists[0].Size;
        g.RenderDrawData.TotalVtxCount = g.IO.MetricsRenderVertices;
        g.RenderDrawData.TotalIdxCount = g.IO.MetricsRenderIndices;

        // Render. If user hasn't set a callback then they may retrieve the draw data via GetDrawData()
        if (g.RenderDrawData.CmdListsCount > 0 && g.IO.RenderDrawListsFn != NULL)
            g.IO.RenderDrawListsFn(&g.RenderDrawData);
    }+/
}

//    void          Shutdown();
// NB: behavior of ImGui after Shutdown() is not tested/guaranteed at the moment. This function is merely here to free heap allocations.
void Shutdown()
{
    /+ImGuiContext& g = *GImGui;

    // The fonts atlas can be used prior to calling NewFrame(), so we clear it even if g.Initialized is FALSE (which would happen if we never called NewFrame)
    if (g.IO.Fonts) // Testing for NULL to allow user to NULLify in case of running Shutdown() on multiple contexts. Bit hacky.
        g.IO.Fonts->Clear();

    // Cleanup of other data are conditional on actually having used ImGui.
    if (!g.Initialized)
        return;

    SaveIniSettingsToDisk(g.IO.IniFilename);

    for (int i = 0; i < g.Windows.Size; i++)
    {
        g.Windows[i]->~ImGuiWindow();
        ImGui::MemFree(g.Windows[i]);
    }
    g.Windows.clear();
    g.WindowsSortBuffer.clear();
    g.CurrentWindow = NULL;
    g.CurrentWindowStack.clear();
    g.FocusedWindow = NULL;
    g.HoveredWindow = NULL;
    g.HoveredRootWindow = NULL;
    g.ActiveIdWindow = NULL;
    g.MovedWindow = NULL;
    for (int i = 0; i < g.Settings.Size; i++)
        ImGui::MemFree(g.Settings[i].Name);
    g.Settings.clear();
    g.ColorModifiers.clear();
    g.StyleModifiers.clear();
    g.FontStack.clear();
    g.OpenPopupStack.clear();
    g.CurrentPopupStack.clear();
    g.SetNextWindowSizeConstraintCallback = NULL;
    g.SetNextWindowSizeConstraintCallbackUserData = NULL;
    for (int i = 0; i < IM_ARRAYSIZE(g.RenderDrawLists); i++)
        g.RenderDrawLists[i].clear();
    g.OverlayDrawList.ClearFreeMemory();
    g.ColorEditModeStorage.Clear();
    if (g.PrivateClipboard)
    {
        ImGui::MemFree(g.PrivateClipboard);
        g.PrivateClipboard = NULL;
    }
    g.InputTextState.Text.clear();
    g.InputTextState.InitialText.clear();
    g.InputTextState.TempTextBuffer.clear();

    if (g.LogFile && g.LogFile != stdout)
    {
        fclose(g.LogFile);
        g.LogFile = NULL;
    }
    if (g.LogClipboard)
    {
        g.LogClipboard->~ImGuiTextBuffer();
        ImGui::MemFree(g.LogClipboard);
    }

    g.Initialized = false;+/
}

//    void          ShowUserGuide();                            // help block


    void          ShowStyleEditor(ImGuiStyle* ref_ = null);    // style editor block. you can pass in a reference ImGuiStyle structure to compare to, revert to and save to (else it uses the default style)
    void          ShowTestWindow(bool* p_open = null);        // test window demonstrating ImGui features
    void          ShowMetricsWindow(bool* p_open = null);     // metrics window for debugging ImGui (browse draw commands, individual vertices, window list, etc.)

    // Window
    bool          Begin(const char* name, bool* p_open = null, ImGuiWindowFlags flags = 0);                                                   // push window to the stack and start appending to it. see .cpp for details. return false when window is collapsed, so you can early out in your code. 'bool* p_open' creates a widget on the upper-right to close the window (which sets your bool to false).
    bool          Begin(const char* name, bool* p_open, const ImVec2& size_on_first_use, float bg_alpha = -1.0f, ImGuiWindowFlags flags = 0); // OBSOLETE. this is the older/longer API. the extra parameters aren't very relevant. call SetNextWindowSize() instead if you want to set a window size. For regular windows, 'size_on_first_use' only applies to the first time EVER the window is created and probably not what you want! might obsolete this API eventually.
    void          End();                                                                                                                      // finish appending to current window, pop it off the window stack.
    bool          BeginChild(const char* str_id, const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags extra_flags = 0);    // begin a scrolling region. size==0.0f: use remaining window size, size<0.0f: use remaining window size minus abs(size). size>0.0f: fixed size. each axis can use a different mode, e.g. ImVec2(0,400).
    bool          BeginChild(ImGuiID id, const ImVec2& size = ImVec2(0,0), bool border = false, ImGuiWindowFlags extra_flags = 0);            // "
    void          EndChild();
    ImVec2        GetContentRegionMax();                                              // current content boundaries (typically window boundaries including scrolling, or current column boundaries), in windows coordinates
    ImVec2        GetContentRegionAvail();                                            // == GetContentRegionMax() - GetCursorPos()
    float         GetContentRegionAvailWidth();                                       //
    ImVec2        GetWindowContentRegionMin();                                        // content boundaries min (roughly (0,0)-Scroll), in window coordinates
    ImVec2        GetWindowContentRegionMax();                                        // content boundaries max (roughly (0,0)+Size-Scroll) where Size can be override with SetNextWindowContentSize(), in window coordinates
    float         GetWindowContentRegionWidth();                                      //
    ImDrawList*   GetWindowDrawList();                                                // get rendering command-list if you want to append your own draw primitives
    ImVec2        GetWindowPos();                                                     // get current window position in screen space (useful if you want to do your own drawing via the DrawList api)
    ImVec2        GetWindowSize();                                                    // get current window size
    float         GetWindowWidth();
    float         GetWindowHeight();
    bool          IsWindowCollapsed();
    void          SetWindowFontScale(float scale);                                    // per-window font scale. Adjust IO.FontGlobalScale if you want to scale all windows

    void          SetNextWindowPos(const ImVec2& pos, ImGuiSetCond cond = 0);         // set next window position. call before Begin()
    void          SetNextWindowPosCenter(ImGuiSetCond cond = 0);                      // set next window position to be centered on screen. call before Begin()
    void          SetNextWindowSize(const ImVec2& size, ImGuiSetCond cond = 0);       // set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
    void          SetNextWindowSizeConstraints(const ImVec2& size_min, const ImVec2& size_max, ImGuiSizeConstraintCallback custom_callback = NULL, void* custom_callback_data = NULL); // set next window size limits. use -1,-1 on either X/Y axis to preserve the current size. Use callback to apply non-trivial programmatic constraints.
    void          SetNextWindowContentSize(const ImVec2& size);                       // set next window content size (enforce the range of scrollbars). set axis to 0.0f to leave it automatic. call before Begin()
    void          SetNextWindowContentWidth(float width);                             // set next window content width (enforce the range of horizontal scrollbar). call before Begin()
    void          SetNextWindowCollapsed(bool collapsed, ImGuiSetCond cond = 0);      // set next window collapsed state. call before Begin()
    void          SetNextWindowFocus();                                               // set next window to be focused / front-most. call before Begin()
    void          SetWindowPos(const ImVec2& pos, ImGuiSetCond cond = 0);             // (not recommended) set current window position - call within Begin()/End(). prefer using SetNextWindowPos(), as this may incur tearing and side-effects.
    void          SetWindowSize(const ImVec2& size, ImGuiSetCond cond = 0);           // (not recommended) set current window size - call within Begin()/End(). set to ImVec2(0,0) to force an auto-fit. prefer using SetNextWindowSize(), as this may incur tearing and minor side-effects.    
    void          SetWindowCollapsed(bool collapsed, ImGuiSetCond cond = 0);          // (not recommended) set current window collapsed state. prefer using SetNextWindowCollapsed().
    void          SetWindowFocus();                                                   // (not recommended) set current window to be focused / front-most. prefer using SetNextWindowFocus().
    void          SetWindowPos(const char* name, const ImVec2& pos, ImGuiSetCond cond = 0);      // set named window position.
    void          SetWindowSize(const char* name, const ImVec2& size, ImGuiSetCond cond = 0);    // set named window size. set axis to 0.0f to force an auto-fit on this axis.
    void          SetWindowCollapsed(const char* name, bool collapsed, ImGuiSetCond cond = 0);   // set named window collapsed state
    void          SetWindowFocus(const char* name);                                              // set named window to be focused / front-most. use NULL to remove focus.

    float         GetScrollX();                                                       // get scrolling amount [0..GetScrollMaxX()]
    float         GetScrollY();                                                       // get scrolling amount [0..GetScrollMaxY()]
    float         GetScrollMaxX();                                                    // get maximum scrolling amount ~~ ContentSize.X - WindowSize.X
    float         GetScrollMaxY();                                                    // get maximum scrolling amount ~~ ContentSize.Y - WindowSize.Y
    void          SetScrollX(float scroll_x);                                         // set scrolling amount [0..GetScrollMaxX()]
    void          SetScrollY(float scroll_y);                                         // set scrolling amount [0..GetScrollMaxY()]
    void          SetScrollHere(float center_y_ratio = 0.5f);                         // adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom.
    void          SetScrollFromPosY(float pos_y, float center_y_ratio = 0.5f);        // adjust scrolling amount to make given position valid. use GetCursorPos() or GetCursorStartPos()+offset to get valid positions.
    void          SetKeyboardFocusHere(int offset = 0);                               // focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget. Use negative 'offset' to access previous widgets.
    void          SetStateStorage(ImGuiStorage* tree);                                // replace tree state storage with our own (if you want to manipulate it yourself, typically clear subsection of it)
    ImGuiStorage* GetStateStorage();

    // Parameters stacks (shared)
    void          PushFont(ImFont* font);                                             // use NULL as a shortcut to push default font
    void          PopFont();
    void          PushStyleColor(ImGuiCol idx, const ImVec4& col);
    void          PopStyleColor(int count = 1);
    void          PushStyleVar(ImGuiStyleVar idx, float val);
    void          PushStyleVar(ImGuiStyleVar idx, const ImVec2& val);
    void          PopStyleVar(int count = 1);
    ImFont*       GetFont();                                                          // get current font
    float         GetFontSize();                                                      // get current font size (= height in pixels) of current font with current scale applied
    ImVec2        GetFontTexUvWhitePixel();                                           // get UV coordinate for a while pixel, useful to draw custom shapes via the ImDrawList API
    ImU32         GetColorU32(ImGuiCol idx, float alpha_mul = 1.0f);                  // retrieve given style color with style alpha applied and optional extra alpha multiplier
    ImU32         GetColorU32(const ImVec4& col);                                     // retrieve given color with style alpha applied

    // Parameters stacks (current window)
    void          PushItemWidth(float item_width);                                    // width of items for the common item+label case, pixels. 0.0f = default to ~2/3 of windows width, >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -1.0f always align width to the right side)
    void          PopItemWidth();
    float         CalcItemWidth();                                                    // width of item given pushed settings and current cursor position
    void          PushTextWrapPos(float wrap_pos_x = 0.0f);                           // word-wrapping for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position in window local space
    void          PopTextWrapPos();
    void          PushAllowKeyboardFocus(bool v);                                     // allow focusing using TAB/Shift-TAB, enabled by default but you can disable it for certain widgets
    void          PopAllowKeyboardFocus();
    void          PushButtonRepeat(bool repeat);                                      // in 'repeat' mode, Button*() functions return repeated true in a typematic manner (uses io.KeyRepeatDelay/io.KeyRepeatRate for now). Note that you can call IsItemActive() after any Button() to tell if the button is held in the current frame.
    void          PopButtonRepeat();

    // Cursor / Layout
    void          Separator();                                                        // horizontal line
    void          SameLine(float pos_x = 0.0f, float spacing_w = -1.0f);              // call between widgets or groups to layout them horizontally
    void          NewLine();                                                          // undo a SameLine()
    void          Spacing();                                                          // add vertical spacing
    void          Dummy(const ImVec2& size);                                          // add a dummy item of given size
    void          Indent(float indent_w = 0.0f);                                      // move content position toward the right, by style.IndentSpacing or indent_w if >0
    void          Unindent(float indent_w = 0.0f);                                    // move content position back to the left, by style.IndentSpacing or indent_w if >0
    void          BeginGroup();                                                       // lock horizontal starting position + capture group bounding box into one "item" (so you can use IsItemHovered() or layout primitives such as SameLine() on whole group, etc.)
    void          EndGroup();
    ImVec2        GetCursorPos();                                                     // cursor position is relative to window position
    float         GetCursorPosX();                                                    // "
    float         GetCursorPosY();                                                    // "
    void          SetCursorPos(const ImVec2& local_pos);                              // "
    void          SetCursorPosX(float x);                                             // "
    void          SetCursorPosY(float y);                                             // "
    ImVec2        GetCursorStartPos();                                                // initial cursor position
    ImVec2        GetCursorScreenPos();                                               // cursor position in absolute screen coordinates [0..io.DisplaySize] (useful to work with ImDrawList API)
    void          SetCursorScreenPos(const ImVec2& pos);                              // cursor position in absolute screen coordinates [0..io.DisplaySize]
    void          AlignFirstTextHeightToWidgets();                                    // call once if the first item on the line is a Text() item and you want to vertically lower it to match subsequent (bigger) widgets
    float         GetTextLineHeight();                                                // height of font == GetWindowFontSize()
    float         GetTextLineHeightWithSpacing();                                     // distance (in pixels) between 2 consecutive lines of text == GetWindowFontSize() + GetStyle().ItemSpacing.y
    float         GetItemsLineHeightWithSpacing();                                    // distance (in pixels) between 2 consecutive lines of standard height widgets == GetWindowFontSize() + GetStyle().FramePadding.y*2 + GetStyle().ItemSpacing.y

    // Columns
    // You can also use SameLine(pos_x) for simplified columning. The columns API is still work-in-progress and rather lacking.
    void          Columns(int count = 1, const char* id = NULL, bool border = true);  // setup number of columns. use an identifier to distinguish multiple column sets. close with Columns(1).
    void          NextColumn();                                                       // next column
    int           GetColumnIndex();                                                   // get current column index
    float         GetColumnOffset(int column_index = -1);                             // get position of column line (in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetcolumnsCount() inclusive. column 0 is usually 0.0f and not resizable unless you call this
    void          SetColumnOffset(int column_index, float offset_x);                  // set position of column line (in pixels, from the left side of the contents region). pass -1 to use current column
    float         GetColumnWidth(int column_index = -1);                              // column width (== GetColumnOffset(GetColumnIndex()+1) - GetColumnOffset(GetColumnOffset())
    int           GetColumnsCount();                                                  // number of columns (what was passed to Columns())

    // ID scopes
    // If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them.
    // You can also use the "##foobar" syntax within widget label to distinguish them from each others. Read "A primer on the use of labels/IDs" in the FAQ for more details.
    void          PushID(const char* str_id);                                         // push identifier into the ID stack. IDs are hash of the *entire* stack!
    void          PushID(const char* str_id_begin, const char* str_id_end);
    void          PushID(const void* ptr_id);
    void          PushID(int int_id);
    void          PopID();
    ImGuiID       GetID(const char* str_id);                                          // calculate unique ID (hash of whole ID stack + given parameter). useful if you want to query into ImGuiStorage yourself. otherwise rarely needed
    ImGuiID       GetID(const char* str_id_begin, const char* str_id_end);
    ImGuiID       GetID(const void* ptr_id);

    // Widgets
    void          Text(const char* fmt, ...) IM_PRINTFARGS(1);
    void          TextV(const char* fmt, va_list args);
    void          TextColored(const ImVec4& col, const char* fmt, ...) IM_PRINTFARGS(2);  // shortcut for PushStyleColor(ImGuiCol_Text, col); Text(fmt, ...); PopStyleColor();
    void          TextColoredV(const ImVec4& col, const char* fmt, va_list args);
    void          TextDisabled(const char* fmt, ...) IM_PRINTFARGS(1);                    // shortcut for PushStyleColor(ImGuiCol_Text, style.Colors[ImGuiCol_TextDisabled]); Text(fmt, ...); PopStyleColor();
    void          TextDisabledV(const char* fmt, va_list args);
    void          TextWrapped(const char* fmt, ...) IM_PRINTFARGS(1);                     // shortcut for PushTextWrapPos(0.0f); Text(fmt, ...); PopTextWrapPos();. Note that this won't work on an auto-resizing window if there's no other widgets to extend the window width, yoy may need to set a size using SetNextWindowSize().
    void          TextWrappedV(const char* fmt, va_list args);
    void          TextUnformatted(const char* text, const char* text_end = NULL);         // doesn't require null terminated string if 'text_end' is specified. no copy done to any bounded stack buffer, recommended for long chunks of text
    void          LabelText(const char* label, const char* fmt, ...) IM_PRINTFARGS(2);    // display text+label aligned the same way as value+label widgets
    void          LabelTextV(const char* label, const char* fmt, va_list args);
    void          Bullet();                                                               // draw a small circle and keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses
    void          BulletText(const char* fmt, ...) IM_PRINTFARGS(1);                      // shortcut for Bullet()+Text()
    void          BulletTextV(const char* fmt, va_list args);
    bool          Button(const char* label, const ImVec2& size = ImVec2(0,0));            // button
    bool          SmallButton(const char* label);                                         // button with FramePadding=(0,0)
    bool          InvisibleButton(const char* str_id, const ImVec2& size);
    void          Image(ImTextureID user_texture_id, const ImVec2& size, const ImVec2& uv0 = ImVec2(0,0), const ImVec2& uv1 = ImVec2(1,1), const ImVec4& tint_col = ImVec4(1,1,1,1), const ImVec4& border_col = ImVec4(0,0,0,0));
    bool          ImageButton(ImTextureID user_texture_id, const ImVec2& size, const ImVec2& uv0 = ImVec2(0,0),  const ImVec2& uv1 = ImVec2(1,1), int frame_padding = -1, const ImVec4& bg_col = ImVec4(0,0,0,0), const ImVec4& tint_col = ImVec4(1,1,1,1));    // <0 frame_padding uses default frame padding settings. 0 for no padding
    bool          Checkbox(const char* label, bool* v);
    bool          CheckboxFlags(const char* label, unsigned int* flags, unsigned int flags_value);
    bool          RadioButton(const char* label, bool active);
    bool          RadioButton(const char* label, int* v, int v_button);
    bool          Combo(const char* label, int* current_item, const char* const* items, int items_count, int height_in_items = -1);
    bool          Combo(const char* label, int* current_item, const char* items_separated_by_zeros, int height_in_items = -1);      // separate items with \0, end item-list with \0\0
    bool          Combo(const char* label, int* current_item, bool (*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int height_in_items = -1);
    bool          ColorButton(const ImVec4& col, bool small_height = false, bool outline_border = true);
    bool          ColorEdit3(const char* label, float col[3]);                            // Hint: 'float col[3]' function argument is same as 'float* col'. You can pass address of first element out of a contiguous set, e.g. &myvector.x
    bool          ColorEdit4(const char* label, float col[4], bool show_alpha = true);    // "
    void          ColorEditMode(ImGuiColorEditMode mode);                                 // FIXME-OBSOLETE: This is inconsistent with most of the API and will be obsoleted/replaced.
    void          PlotLines(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0,0), int stride = sizeof(float));
    void          PlotLines(const char* label, float (*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0,0));
    void          PlotHistogram(const char* label, const float* values, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0,0), int stride = sizeof(float));
    void          PlotHistogram(const char* label, float (*values_getter)(void* data, int idx), void* data, int values_count, int values_offset = 0, const char* overlay_text = NULL, float scale_min = FLT_MAX, float scale_max = FLT_MAX, ImVec2 graph_size = ImVec2(0,0));
    void          ProgressBar(float fraction, const ImVec2& size_arg = ImVec2(-1,0), const char* overlay = NULL);

    // Widgets: Drags (tip: ctrl+click on a drag box to input with keyboard. manually input values aren't clamped, can go off-bounds)
    // For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, remember than a 'float v[3]' function argument is the same as 'float* v'. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
    bool          DragFloat(const char* label, float* v, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);     // If v_min >= v_max we have no bound
    bool          DragFloat2(const char* label, float v[2], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
    bool          DragFloat3(const char* label, float v[3], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
    bool          DragFloat4(const char* label, float v[4], float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", float power = 1.0f);
    bool          DragFloatRange2(const char* label, float* v_current_min, float* v_current_max, float v_speed = 1.0f, float v_min = 0.0f, float v_max = 0.0f, const char* display_format = "%.3f", const char* display_format_max = NULL, float power = 1.0f);
    bool          DragInt(const char* label, int* v, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");                                       // If v_min >= v_max we have no bound
    bool          DragInt2(const char* label, int v[2], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
    bool          DragInt3(const char* label, int v[3], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
    bool          DragInt4(const char* label, int v[4], float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f");
    bool          DragIntRange2(const char* label, int* v_current_min, int* v_current_max, float v_speed = 1.0f, int v_min = 0, int v_max = 0, const char* display_format = "%.0f", const char* display_format_max = NULL);

    // Widgets: Input with Keyboard
    bool          InputText(const char* label, char* buf, size_t buf_size, ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = NULL, void* user_data = NULL);
    bool          InputTextMultiline(const char* label, char* buf, size_t buf_size, const ImVec2& size = ImVec2(0,0), ImGuiInputTextFlags flags = 0, ImGuiTextEditCallback callback = NULL, void* user_data = NULL);
    bool          InputFloat(const char* label, float* v, float step = 0.0f, float step_fast = 0.0f, int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat2(const char* label, float v[2], int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat3(const char* label, float v[3], int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputFloat4(const char* label, float v[4], int decimal_precision = -1, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt(const char* label, int* v, int step = 1, int step_fast = 100, ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt2(const char* label, int v[2], ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt3(const char* label, int v[3], ImGuiInputTextFlags extra_flags = 0);
    bool          InputInt4(const char* label, int v[4], ImGuiInputTextFlags extra_flags = 0);

    // Widgets: Sliders (tip: ctrl+click on a slider to input with keyboard. manually input values aren't clamped, can go off-bounds)
    bool          SliderFloat(const char* label, float* v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);     // adjust display_format to decorate the value with a prefix or a suffix. Use power!=1.0 for logarithmic sliders
    bool          SliderFloat2(const char* label, float v[2], float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
    bool          SliderFloat3(const char* label, float v[3], float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
    bool          SliderFloat4(const char* label, float v[4], float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
    bool          SliderAngle(const char* label, float* v_rad, float v_degrees_min = -360.0f, float v_degrees_max = +360.0f);
    bool          SliderInt(const char* label, int* v, int v_min, int v_max, const char* display_format = "%.0f");
    bool          SliderInt2(const char* label, int v[2], int v_min, int v_max, const char* display_format = "%.0f");
    bool          SliderInt3(const char* label, int v[3], int v_min, int v_max, const char* display_format = "%.0f");
    bool          SliderInt4(const char* label, int v[4], int v_min, int v_max, const char* display_format = "%.0f");
    bool          VSliderFloat(const char* label, const ImVec2& size, float* v, float v_min, float v_max, const char* display_format = "%.3f", float power = 1.0f);
    bool          VSliderInt(const char* label, const ImVec2& size, int* v, int v_min, int v_max, const char* display_format = "%.0f");

    // Widgets: Trees
    bool          TreeNode(const char* label);                                            // if returning 'true' the node is open and the tree id is pushed into the id stack. user is responsible for calling TreePop().
    bool          TreeNode(const char* str_id, const char* fmt, ...) IM_PRINTFARGS(2);    // read the FAQ about why and how to use ID. to align arbitrary text at the same level as a TreeNode() you can use Bullet().
    bool          TreeNode(const void* ptr_id, const char* fmt, ...) IM_PRINTFARGS(2);    // "
    bool          TreeNodeV(const char* str_id, const char* fmt, va_list args);           // "
    bool          TreeNodeV(const void* ptr_id, const char* fmt, va_list args);           // "
    bool          TreeNodeEx(const char* label, ImGuiTreeNodeFlags flags = 0);
    bool          TreeNodeEx(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3);
    bool          TreeNodeEx(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, ...) IM_PRINTFARGS(3);
    bool          TreeNodeExV(const char* str_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args);
    bool          TreeNodeExV(const void* ptr_id, ImGuiTreeNodeFlags flags, const char* fmt, va_list args);
    void          TreePush(const char* str_id = NULL);                                    // ~ Indent()+PushId(). Already called by TreeNode() when returning true, but you can call Push/Pop yourself for layout purpose
    void          TreePush(const void* ptr_id = NULL);                                    // "
    void          TreePop();                                                              // ~ Unindent()+PopId()
    void          TreeAdvanceToLabelPos();                                                // advance cursor x position by GetTreeNodeToLabelSpacing()
    float         GetTreeNodeToLabelSpacing();                                            // horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
    void          SetNextTreeNodeOpen(bool is_open, ImGuiSetCond cond = 0);               // set next TreeNode/CollapsingHeader open state.
    bool          CollapsingHeader(const char* label, ImGuiTreeNodeFlags flags = 0);      // if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
    bool          CollapsingHeader(const char* label, bool* p_open, ImGuiTreeNodeFlags flags = 0); // when 'p_open' isn't NULL, display an additional small close button on upper right of the header

    // Widgets: Selectable / Lists
    bool          Selectable(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0,0));  // size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
    bool          Selectable(const char* label, bool* p_selected, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0,0));
    bool          ListBox(const char* label, int* current_item, const char* const* items, int items_count, int height_in_items = -1);
    bool          ListBox(const char* label, int* current_item, bool (*items_getter)(void* data, int idx, const char** out_text), void* data, int items_count, int height_in_items = -1);
    bool          ListBoxHeader(const char* label, const ImVec2& size = ImVec2(0,0)); // use if you want to reimplement ListBox() will custom data or interactions. make sure to call ListBoxFooter() afterwards.
    bool          ListBoxHeader(const char* label, int items_count, int height_in_items = -1); // "
    void          ListBoxFooter();                                                    // terminate the scrolling region

    // Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
    void          Value(const char* prefix, bool b);
    void          Value(const char* prefix, int v);
    void          Value(const char* prefix, unsigned int v);
    void          Value(const char* prefix, float v, const char* float_format = NULL);
    void          ValueColor(const char* prefix, const ImVec4& v);
    void          ValueColor(const char* prefix, ImU32 v);

    // Tooltips
    void          SetTooltip(const char* fmt, ...) IM_PRINTFARGS(1);                  // set tooltip under mouse-cursor, typically use with ImGui::IsHovered(). last call wins
    void          SetTooltipV(const char* fmt, va_list args);
    void          BeginTooltip();                                                     // use to create full-featured tooltip windows that aren't just text
    void          EndTooltip();

    // Menus
    bool          BeginMainMenuBar();                                                 // create and append to a full screen menu-bar. only call EndMainMenuBar() if this returns true!
    void          EndMainMenuBar();
    bool          BeginMenuBar();                                                     // append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set). only call EndMenuBar() if this returns true!
    void          EndMenuBar();
    bool          BeginMenu(const char* label, bool enabled = true);                  // create a sub-menu entry. only call EndMenu() if this returns true!
    void          EndMenu();
    bool          MenuItem(const char* label, const char* shortcut = NULL, bool selected = false, bool enabled = true);  // return true when activated. shortcuts are displayed for convenience but not processed by ImGui at the moment
    bool          MenuItem(const char* label, const char* shortcut, bool* p_selected, bool enabled = true);              // return true when activated + toggle (*p_selected) if p_selected != NULL

    // Popups
    void          OpenPopup(const char* str_id);                                      // mark popup as open. popups are closed when user click outside, or activate a pressable item, or CloseCurrentPopup() is called within a BeginPopup()/EndPopup() block. popup identifiers are relative to the current ID-stack (so OpenPopup and BeginPopup needs to be at the same level).
    bool          BeginPopup(const char* str_id);                                     // return true if the popup is open, and you can start outputting to it. only call EndPopup() if BeginPopup() returned true!
    bool          BeginPopupModal(const char* name, bool* p_open = NULL, ImGuiWindowFlags extra_flags = 0);               // modal dialog (block interactions behind the modal window, can't close the modal window by clicking outside)
    bool          BeginPopupContextItem(const char* str_id, int mouse_button = 1);                                        // helper to open and begin popup when clicked on last item. read comments in .cpp!
    bool          BeginPopupContextWindow(bool also_over_items = true, const char* str_id = NULL, int mouse_button = 1);  // helper to open and begin popup when clicked on current window.
    bool          BeginPopupContextVoid(const char* str_id = NULL, int mouse_button = 1);                                 // helper to open and begin popup when clicked in void (no window).
    void          EndPopup();
    void          CloseCurrentPopup();                                                // close the popup we have begin-ed into. clicking on a MenuItem or Selectable automatically close the current popup.

    // Logging: all text output from interface is redirected to tty/file/clipboard. By default, tree nodes are automatically opened during logging.
    void          LogToTTY(int max_depth = -1);                                       // start logging to tty
    void          LogToFile(int max_depth = -1, const char* filename = NULL);         // start logging to file
    void          LogToClipboard(int max_depth = -1);                                 // start logging to OS clipboard
    void          LogFinish();                                                        // stop logging (close file, etc.)
    void          LogButtons();                                                       // helper to display buttons for logging to tty/file/clipboard
    void          LogText(const char* fmt, ...) IM_PRINTFARGS(1);                     // pass text data straight to log (without being displayed)

    // Clipping
    void          PushClipRect(const ImVec2& clip_rect_min, const ImVec2& clip_rect_max, bool intersect_with_current_clip_rect);
    void          PopClipRect();

    // Utilities
    bool          IsItemHovered();                                                    // was the last item hovered by mouse?
    bool          IsItemHoveredRect();                                                // was the last item hovered by mouse? even if another item is active or window is blocked by popup while we are hovering this
    bool          IsItemActive();                                                     // was the last item active? (e.g. button being held, text field being edited- items that don't interact will always return false)
    bool          IsItemClicked(int mouse_button = 0);                                // was the last item clicked? (e.g. button/node just clicked on)
    bool          IsItemVisible();                                                    // was the last item visible? (aka not out of sight due to clipping/scrolling.)
    bool          IsAnyItemHovered();
    bool          IsAnyItemActive();
    ImVec2        GetItemRectMin();                                                   // get bounding rect of last item in screen space
    ImVec2        GetItemRectMax();                                                   // "
    ImVec2        GetItemRectSize();                                                  // "
    void          SetItemAllowOverlap();                                              // allow last item to be overlapped by a subsequent item. sometimes useful with invisible buttons, selectables, etc. to catch unused area.
    bool          IsWindowHovered();                                                  // is current window hovered and hoverable (not blocked by a popup) (differentiate child windows from each others)
    bool          IsWindowFocused();                                                  // is current window focused
    bool          IsRootWindowFocused();                                              // is current root window focused (root = top-most parent of a child, otherwise self)
    bool          IsRootWindowOrAnyChildFocused();                                    // is current root window or any of its child (including current window) focused
    bool          IsRootWindowOrAnyChildHovered();                                    // is current root window or any of its child (including current window) hovered and hoverable (not blocked by a popup)
    bool          IsRectVisible(const ImVec2& size);                                  // test if rectangle (of given size, starting from cursor position) is visible / not clipped.
    bool          IsRectVisible(const ImVec2& rect_min, const ImVec2& rect_max);      // test if rectangle (in screen space) is visible / not clipped. to perform coarse clipping on user's side.
    bool          IsPosHoveringAnyWindow(const ImVec2& pos);                          // is given position hovering any active imgui window
    float         GetTime();
    int           GetFrameCount();
    const char*   GetStyleColName(ImGuiCol idx);
    ImVec2        CalcItemRectClosestPoint(const ImVec2& pos, bool on_edge = false, float outward = +0.0f);   // utility to find the closest point the last item bounding rectangle edge. useful to visually link items
    ImVec2        CalcTextSize(const char* text, const char* text_end = NULL, bool hide_text_after_double_hash = false, float wrap_width = -1.0f);
    void          CalcListClipping(int items_count, float items_height, int* out_items_display_start, int* out_items_display_end);    // calculate coarse clipping for large list of evenly sized items. Prefer using the ImGuiListClipper higher-level helper if you can.

    bool          BeginChildFrame(ImGuiID id, const ImVec2& size, ImGuiWindowFlags extra_flags = 0);	// helper to create a child window / scrolling region that looks like a normal widget frame
    void          EndChildFrame();

    ImVec4        ColorConvertU32ToFloat4(ImU32 in);
    ImU32         ColorConvertFloat4ToU32(const ImVec4& in);
    void          ColorConvertRGBtoHSV(float r, float g, float b, float& out_h, float& out_s, float& out_v);
    void          ColorConvertHSVtoRGB(float h, float s, float v, float& out_r, float& out_g, float& out_b);

    // Inputs
    int           GetKeyIndex(ImGuiKey key);                                          // map ImGuiKey_* values into user's key index. == io.KeyMap[key]
    bool          IsKeyDown(int key_index);                                           // key_index into the keys_down[] array, imgui doesn't know the semantic of each entry, uses your own indices!
    bool          IsKeyPressed(int key_index, bool repeat = true);                    // uses user's key indices as stored in the keys_down[] array. if repeat=true. uses io.KeyRepeatDelay / KeyRepeatRate
    bool          IsKeyReleased(int key_index);                                       // "
    bool          IsMouseDown(int button);                                            // is mouse button held
    bool          IsMouseClicked(int button, bool repeat = false);                    // did mouse button clicked (went from !Down to Down)
    bool          IsMouseDoubleClicked(int button);                                   // did mouse button double-clicked. a double-click returns false in IsMouseClicked(). uses io.MouseDoubleClickTime.
    bool          IsMouseReleased(int button);                                        // did mouse button released (went from Down to !Down)
    bool          IsMouseHoveringWindow();                                            // is mouse hovering current window ("window" in API names always refer to current window). disregarding of any consideration of being blocked by a popup. (unlike IsWindowHovered() this will return true even if the window is blocked because of a popup)
    bool          IsMouseHoveringAnyWindow();                                         // is mouse hovering any visible window
    bool          IsMouseHoveringRect(const ImVec2& r_min, const ImVec2& r_max, bool clip = true);  // is mouse hovering given bounding rect (in screen space). clipped by current clipping settings. disregarding of consideration of focus/window ordering/blocked by a popup.
    bool          IsMouseDragging(int button = 0, float lock_threshold = -1.0f);      // is mouse dragging. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
    ImVec2        GetMousePos();                                                      // shortcut to ImGui::GetIO().MousePos provided by user, to be consistent with other calls
    ImVec2        GetMousePosOnOpeningCurrentPopup();                                 // retrieve backup of mouse positioning at the time of opening popup we have BeginPopup() into
    ImVec2        GetMouseDragDelta(int button = 0, float lock_threshold = -1.0f);    // dragging amount since clicking. if lock_threshold < -1.0f uses io.MouseDraggingThreshold
    void          ResetMouseDragDelta(int button = 0);                                //
    ImGuiMouseCursor GetMouseCursor();                                                // get desired cursor type, reset in ImGui::NewFrame(), this updated during the frame. valid before Render(). If you use software rendering by setting io.MouseDrawCursor ImGui will render those for you
    void          SetMouseCursor(ImGuiMouseCursor type);                              // set desired cursor type
    void          CaptureKeyboardFromApp(bool capture = true);                        // manually override io.WantCaptureKeyboard flag next frame (said flag is entirely left for your application handle). e.g. force capture keyboard when your widget is being hovered.
    void          CaptureMouseFromApp(bool capture = true);                           // manually override io.WantCaptureMouse flag next frame (said flag is entirely left for your application handle).

    // Helpers functions to access functions pointers in ImGui::GetIO()
    void*         MemAlloc(size_t sz);
    void          MemFree(void* ptr);
    const char*   GetClipboardText();
    void          SetClipboardText(const char* text);

    // Internal context access - if you want to use multiple context, share context between modules (e.g. DLL). There is a default context created and active by default.
    // All contexts share a same ImFontAtlas by default. If you want different font atlas, you can new() them and overwrite the GetIO().Fonts variable of an ImGui context.
    const char*   GetVersion();
    ImGuiContext* CreateContext(void* (*malloc_fn)(size_t) = NULL, void (*free_fn)(void*) = NULL);
    void          DestroyContext(ImGuiContext* ctx);
    ImGuiContext* GetCurrentContext();
    void          SetCurrentContext(ImGuiContext* ctx);

/+    // Obsolete (will be removed)
#ifndef IMGUI_DISABLE_OBSOLETE_FUNCTIONS
    static inline bool      CollapsingHeader(const char* label, const char* str_id, bool framed = true, bool default_open = false) { (void)str_id; (void)framed; ImGuiTreeNodeFlags default_open_flags = 1<<5; return CollapsingHeader(label, (default_open ? default_open_flags : 0)); } // OBSOLETE 1.49+
    static inline ImFont*   GetWindowFont() { return GetFont(); }                              // OBSOLETE 1.48+
    static inline float     GetWindowFontSize() { return GetFontSize(); }                      // OBSOLETE 1.48+
    static inline void      SetScrollPosHere() { SetScrollHere(); }                            // OBSOLETE 1.42+
    static inline bool      GetWindowCollapsed() { return ImGui::IsWindowCollapsed(); }        // OBSOLETE 1.39+
    static inline bool      IsRectClipped(const ImVec2& size) { return !IsRectVisible(size); } // OBSOLETE 1.39+
#endif+/

//} // namespace ImGui

// Flags for ImGui::Begin()
enum ImGuiWindowFlags_
{
    // Default: 0
    ImGuiWindowFlags_NoTitleBar             = 1 << 0,   // Disable title-bar
    ImGuiWindowFlags_NoResize               = 1 << 1,   // Disable user resizing with the lower-right grip
    ImGuiWindowFlags_NoMove                 = 1 << 2,   // Disable user moving the window
    ImGuiWindowFlags_NoScrollbar            = 1 << 3,   // Disable scrollbars (window can still scroll with mouse or programatically)
    ImGuiWindowFlags_NoScrollWithMouse      = 1 << 4,   // Disable user vertically scrolling with mouse wheel
    ImGuiWindowFlags_NoCollapse             = 1 << 5,   // Disable user collapsing window by double-clicking on it
    ImGuiWindowFlags_AlwaysAutoResize       = 1 << 6,   // Resize every window to its content every frame
    ImGuiWindowFlags_ShowBorders            = 1 << 7,   // Show borders around windows and items
    ImGuiWindowFlags_NoSavedSettings        = 1 << 8,   // Never load/save settings in .ini file
    ImGuiWindowFlags_NoInputs               = 1 << 9,   // Disable catching mouse or keyboard inputs
    ImGuiWindowFlags_MenuBar                = 1 << 10,  // Has a menu-bar
    ImGuiWindowFlags_HorizontalScrollbar    = 1 << 11,  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
    ImGuiWindowFlags_NoFocusOnAppearing     = 1 << 12,  // Disable taking focus when transitioning from hidden to visible state
    ImGuiWindowFlags_NoBringToFrontOnFocus  = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
    ImGuiWindowFlags_AlwaysVerticalScrollbar= 1 << 14,  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
    ImGuiWindowFlags_AlwaysHorizontalScrollbar=1<< 15,  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
    ImGuiWindowFlags_AlwaysUseWindowPadding = 1 << 16,  // Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
    // [Internal]
    ImGuiWindowFlags_ChildWindow            = 1 << 20,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ChildWindowAutoFitX    = 1 << 21,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ChildWindowAutoFitY    = 1 << 22,  // Don't use! For internal use by BeginChild()
    ImGuiWindowFlags_ComboBox               = 1 << 23,  // Don't use! For internal use by ComboBox()
    ImGuiWindowFlags_Tooltip                = 1 << 24,  // Don't use! For internal use by BeginTooltip()
    ImGuiWindowFlags_Popup                  = 1 << 25,  // Don't use! For internal use by BeginPopup()
    ImGuiWindowFlags_Modal                  = 1 << 26,  // Don't use! For internal use by BeginPopupModal()
    ImGuiWindowFlags_ChildMenu              = 1 << 27   // Don't use! For internal use by BeginMenu()
};

// Flags for ImGui::InputText()
enum ImGuiInputTextFlags_
{
    // Default: 0
    ImGuiInputTextFlags_CharsDecimal        = 1 << 0,   // Allow 0123456789.+-*/
    ImGuiInputTextFlags_CharsHexadecimal    = 1 << 1,   // Allow 0123456789ABCDEFabcdef
    ImGuiInputTextFlags_CharsUppercase      = 1 << 2,   // Turn a..z into A..Z
    ImGuiInputTextFlags_CharsNoBlank        = 1 << 3,   // Filter out spaces, tabs
    ImGuiInputTextFlags_AutoSelectAll       = 1 << 4,   // Select entire text when first taking mouse focus
    ImGuiInputTextFlags_EnterReturnsTrue    = 1 << 5,   // Return 'true' when Enter is pressed (as opposed to when the value was modified)
    ImGuiInputTextFlags_CallbackCompletion  = 1 << 6,   // Call user function on pressing TAB (for completion handling)
    ImGuiInputTextFlags_CallbackHistory     = 1 << 7,   // Call user function on pressing Up/Down arrows (for history handling)
    ImGuiInputTextFlags_CallbackAlways      = 1 << 8,   // Call user function every time. User code may query cursor position, modify text buffer.
    ImGuiInputTextFlags_CallbackCharFilter  = 1 << 9,   // Call user function to filter character. Modify data->EventChar to replace/filter input, or return 1 to discard character.
    ImGuiInputTextFlags_AllowTabInput       = 1 << 10,  // Pressing TAB input a '\t' character into the text field
    ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 11,  // In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
    ImGuiInputTextFlags_NoHorizontalScroll  = 1 << 12,  // Disable following the cursor horizontally
    ImGuiInputTextFlags_AlwaysInsertMode    = 1 << 13,  // Insert mode
    ImGuiInputTextFlags_ReadOnly            = 1 << 14,  // Read-only mode
    ImGuiInputTextFlags_Password            = 1 << 15,  // Password mode, display all characters as '*'
    // [Internal]
    ImGuiInputTextFlags_Multiline           = 1 << 20   // For internal use by InputTextMultiline()
};

// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
enum ImGuiTreeNodeFlags_
{
    ImGuiTreeNodeFlags_Selected             = 1 << 0,   // Draw as selected
    ImGuiTreeNodeFlags_Framed               = 1 << 1,   // Full colored frame (e.g. for CollapsingHeader)
    ImGuiTreeNodeFlags_AllowOverlapMode     = 1 << 2,   // Hit testing to allow subsequent widgets to overlap this one
    ImGuiTreeNodeFlags_NoTreePushOnOpen     = 1 << 3,   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
    ImGuiTreeNodeFlags_NoAutoOpenOnLog      = 1 << 4,   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
    ImGuiTreeNodeFlags_DefaultOpen          = 1 << 5,   // Default node to be open
    ImGuiTreeNodeFlags_OpenOnDoubleClick    = 1 << 6,   // Need double-click to open node
    ImGuiTreeNodeFlags_OpenOnArrow          = 1 << 7,   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
    ImGuiTreeNodeFlags_Leaf                 = 1 << 8,   // No collapsing, no arrow (use as a convenience for leaf nodes). 
    ImGuiTreeNodeFlags_Bullet               = 1 << 9,   // Display a bullet instead of arrow
    //ImGuITreeNodeFlags_SpanAllAvailWidth  = 1 << 10,  // FIXME: TODO: Extend hit box horizontally even if not framed
    //ImGuiTreeNodeFlags_NoScrollOnOpen     = 1 << 11,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
    ImGuiTreeNodeFlags_CollapsingHeader     = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoAutoOpenOnLog
};

// Flags for ImGui::Selectable()
enum ImGuiSelectableFlags_
{
    // Default: 0
    ImGuiSelectableFlags_DontClosePopups    = 1 << 0,   // Clicking this don't close parent popup window
    ImGuiSelectableFlags_SpanAllColumns     = 1 << 1,   // Selectable frame can span all columns (text will still fit in current column)
    ImGuiSelectableFlags_AllowDoubleClick   = 1 << 2    // Generate press events on double clicks too
};

// User fill ImGuiIO.KeyMap[] array with indices into the ImGuiIO.KeysDown[512] array
enum ImGuiKey_
{
    ImGuiKey_Tab,       // for tabbing through fields
    ImGuiKey_LeftArrow, // for text edit
    ImGuiKey_RightArrow,// for text edit
    ImGuiKey_UpArrow,   // for text edit
    ImGuiKey_DownArrow, // for text edit
    ImGuiKey_PageUp,
    ImGuiKey_PageDown,
    ImGuiKey_Home,      // for text edit
    ImGuiKey_End,       // for text edit
    ImGuiKey_Delete,    // for text edit
    ImGuiKey_Backspace, // for text edit
    ImGuiKey_Enter,     // for text edit
    ImGuiKey_Escape,    // for text edit
    ImGuiKey_A,         // for text edit CTRL+A: select all
    ImGuiKey_C,         // for text edit CTRL+C: copy
    ImGuiKey_V,         // for text edit CTRL+V: paste
    ImGuiKey_X,         // for text edit CTRL+X: cut
    ImGuiKey_Y,         // for text edit CTRL+Y: redo
    ImGuiKey_Z,         // for text edit CTRL+Z: undo
    ImGuiKey_COUNT
};

// Enumeration for PushStyleColor() / PopStyleColor()
enum ImGuiCol_
{
    ImGuiCol_Text,
    ImGuiCol_TextDisabled,
    ImGuiCol_WindowBg,              // Background of normal windows
    ImGuiCol_ChildWindowBg,         // Background of child windows
    ImGuiCol_PopupBg,               // Background of popups, menus, tooltips windows
    ImGuiCol_Border,
    ImGuiCol_BorderShadow,
    ImGuiCol_FrameBg,               // Background of checkbox, radio button, plot, slider, text input
    ImGuiCol_FrameBgHovered,
    ImGuiCol_FrameBgActive,
    ImGuiCol_TitleBg,
    ImGuiCol_TitleBgCollapsed,
    ImGuiCol_TitleBgActive,
    ImGuiCol_MenuBarBg,
    ImGuiCol_ScrollbarBg,
    ImGuiCol_ScrollbarGrab,
    ImGuiCol_ScrollbarGrabHovered,
    ImGuiCol_ScrollbarGrabActive,
    ImGuiCol_ComboBg,
    ImGuiCol_CheckMark,
    ImGuiCol_SliderGrab,
    ImGuiCol_SliderGrabActive,
    ImGuiCol_Button,
    ImGuiCol_ButtonHovered,
    ImGuiCol_ButtonActive,
    ImGuiCol_Header,
    ImGuiCol_HeaderHovered,
    ImGuiCol_HeaderActive,
    ImGuiCol_Column,
    ImGuiCol_ColumnHovered,
    ImGuiCol_ColumnActive,
    ImGuiCol_ResizeGrip,
    ImGuiCol_ResizeGripHovered,
    ImGuiCol_ResizeGripActive,
    ImGuiCol_CloseButton,
    ImGuiCol_CloseButtonHovered,
    ImGuiCol_CloseButtonActive,
    ImGuiCol_PlotLines,
    ImGuiCol_PlotLinesHovered,
    ImGuiCol_PlotHistogram,
    ImGuiCol_PlotHistogramHovered,
    ImGuiCol_TextSelectedBg,
    ImGuiCol_ModalWindowDarkening,  // darken entire screen when a modal window is active
    ImGuiCol_COUNT
};

// Enumeration for PushStyleVar() / PopStyleVar()
// NB: the enum only refers to fields of ImGuiStyle() which makes sense to be pushed/poped in UI code. Feel free to add others.
enum ImGuiStyleVar_
{
    ImGuiStyleVar_Alpha,               // float
    ImGuiStyleVar_WindowPadding,       // ImVec2
    ImGuiStyleVar_WindowRounding,      // float
    ImGuiStyleVar_WindowMinSize,       // ImVec2
    ImGuiStyleVar_ChildWindowRounding, // float
    ImGuiStyleVar_FramePadding,        // ImVec2
    ImGuiStyleVar_FrameRounding,       // float
    ImGuiStyleVar_ItemSpacing,         // ImVec2
    ImGuiStyleVar_ItemInnerSpacing,    // ImVec2
    ImGuiStyleVar_IndentSpacing,       // float
    ImGuiStyleVar_GrabMinSize,         // float
    ImGuiStyleVar_ButtonTextAlign,     // flags ImGuiAlign_*
    ImGuiStyleVar_Count_
};

// Enumeration for ColorEditMode()
// FIXME-OBSOLETE: Will be replaced by future color/picker api
enum ImGuiColorEditMode_
{
    ImGuiColorEditMode_UserSelect = -2,
    ImGuiColorEditMode_UserSelectShowButton = -1,
    ImGuiColorEditMode_RGB = 0,
    ImGuiColorEditMode_HSV = 1,
    ImGuiColorEditMode_HEX = 2
};

// Enumeration for GetMouseCursor()
enum ImGuiMouseCursor_
{
    ImGuiMouseCursor_None = -1,
    ImGuiMouseCursor_Arrow = 0,
    ImGuiMouseCursor_TextInput,         // When hovering over InputText, etc.
    ImGuiMouseCursor_Move,              // Unused
    ImGuiMouseCursor_ResizeNS,          // Unused
    ImGuiMouseCursor_ResizeEW,          // When hovering over a column
    ImGuiMouseCursor_ResizeNESW,        // Unused
    ImGuiMouseCursor_ResizeNWSE,        // When hovering over the bottom-right corner of a window
    ImGuiMouseCursor_Count_
};

// Condition flags for ImGui::SetWindow***(), SetNextWindow***(), SetNextTreeNode***() functions
// All those functions treat 0 as a shortcut to ImGuiSetCond_Always
enum ImGuiSetCond_
{
    ImGuiSetCond_Always        = 1 << 0, // Set the variable
    ImGuiSetCond_Once          = 1 << 1, // Set the variable once per runtime session (only the first call with succeed)
    ImGuiSetCond_FirstUseEver  = 1 << 2, // Set the variable if the window has no saved data (if doesn't exist in the .ini file)
    ImGuiSetCond_Appearing     = 1 << 3  // Set the variable if the window is appearing after being hidden/inactive (or the first time)
};

struct ImGuiStyle
{
    float       Alpha;                      // Global alpha applies to everything in ImGui
    ImVec2      WindowPadding;              // Padding within a window
    ImVec2      WindowMinSize;              // Minimum window size
    float       WindowRounding;             // Radius of window corners rounding. Set to 0.0f to have rectangular windows
    ImVec2      WindowTitleAlign;           // Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
    float       ChildWindowRounding;        // Radius of child window corners rounding. Set to 0.0f to have rectangular windows
    ImVec2      FramePadding;               // Padding within a framed rectangle (used by most widgets)
    float       FrameRounding;              // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
    ImVec2      ItemSpacing;                // Horizontal and vertical spacing between widgets/lines
    ImVec2      ItemInnerSpacing;           // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label)
    ImVec2      TouchExtraPadding;          // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
    float       IndentSpacing;              // Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
    float       ColumnsMinSpacing;          // Minimum horizontal spacing between two columns
    float       ScrollbarSize;              // Width of the vertical scrollbar, Height of the horizontal scrollbar
    float       ScrollbarRounding;          // Radius of grab corners for scrollbar
    float       GrabMinSize;                // Minimum width/height of a grab box for slider/scrollbar.
    float       GrabRounding;               // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
    ImVec2      ButtonTextAlign;            // Alignment of button text when button is larger than text. Defaults to (0.5f,0.5f) for horizontally+vertically centered.
    ImVec2      DisplayWindowPadding;       // Window positions are clamped to be visible within the display area by at least this amount. Only covers regular windows.
    ImVec2      DisplaySafeAreaPadding;     // If you cannot see the edge of your screen (e.g. on a TV) increase the safe area padding. Covers popups/tooltips as well regular windows.
    bool        AntiAliasedLines;           // Enable anti-aliasing on lines/borders. Disable if you are really tight on CPU/GPU.
    bool        AntiAliasedShapes;          // Enable anti-aliasing on filled shapes (rounded rectangles, circles, etc.)
    float       CurveTessellationTol;       // Tessellation tolerance. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
    ImVec4      Colors[ImGuiCol_COUNT];

    ImGuiStyle();
};

// This is where your app communicate with ImGui. Access via ImGui::GetIO().
// Read 'Programmer guide' section in .cpp file for general usage.
struct ImGuiIO
{
    //------------------------------------------------------------------
    // Settings (fill once)                 // Default value:
    //------------------------------------------------------------------

    ImVec2        DisplaySize;              // <unset>              // Display size, in pixels. For clamping windows positions.
    float         DeltaTime;                // = 1.0f/60.0f         // Time elapsed since last frame, in seconds.
    float         IniSavingRate;            // = 5.0f               // Maximum time between saving positions/sizes to .ini file, in seconds.
    const char*   IniFilename;              // = "imgui.ini"        // Path to .ini file. NULL to disable .ini saving.
    const char*   LogFilename;              // = "imgui_log.txt"    // Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
    float         MouseDoubleClickTime;     // = 0.30f              // Time for a double-click, in seconds.
    float         MouseDoubleClickMaxDist;  // = 6.0f               // Distance threshold to stay in to validate a double-click, in pixels.
    float         MouseDragThreshold;       // = 6.0f               // Distance threshold before considering we are dragging
    int           KeyMap[ImGuiKey_COUNT];   // <unset>              // Map of indices into the KeysDown[512] entries array
    float         KeyRepeatDelay;           // = 0.250f             // When holding a key/button, time before it starts repeating, in seconds (for buttons in Repeat mode, etc.).
    float         KeyRepeatRate;            // = 0.020f             // When holding a key/button, rate at which it repeats, in seconds.
    void*         UserData;                 // = NULL               // Store your own data for retrieval by callbacks.

    ImFontAtlas*  Fonts;                    // <auto>               // Load and assemble one or more fonts into a single tightly packed texture. Output to Fonts array.
    float         FontGlobalScale;          // = 1.0f               // Global scale all fonts
    bool          FontAllowUserScaling;     // = false              // Allow user scaling text of individual window with CTRL+Wheel.
    ImFont*       FontDefault;              // = NULL               // Font to use on NewFrame(). Use NULL to uses Fonts->Fonts[0].
    ImVec2        DisplayFramebufferScale;  // = (1.0f,1.0f)        // For retina display or other situations where window coordinates are different from framebuffer coordinates. User storage only, presently not used by ImGui.
    ImVec2        DisplayVisibleMin;        // <unset> (0.0f,0.0f)  // If you use DisplaySize as a virtual space larger than your screen, set DisplayVisibleMin/Max to the visible area.
    ImVec2        DisplayVisibleMax;        // <unset> (0.0f,0.0f)  // If the values are the same, we defaults to Min=(0.0f) and Max=DisplaySize

    // Advanced/subtle behaviors
    bool          OSXBehaviors;             // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl

    //------------------------------------------------------------------
    // User Functions
    //------------------------------------------------------------------

    // Rendering function, will be called in Render().
    // Alternatively you can keep this to NULL and call GetDrawData() after Render() to get the same pointer.
    // See example applications if you are unsure of how to implement this.
    void        (*RenderDrawListsFn)(ImDrawData* data);

    // Optional: access OS clipboard
    // (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
    const char* (*GetClipboardTextFn)(void* user_data);
    void        (*SetClipboardTextFn)(void* user_data, const char* text);
    void*       ClipboardUserData;

    // Optional: override memory allocations. MemFreeFn() may be called with a NULL pointer.
    // (default to posix malloc/free)
    void*       (*MemAllocFn)(size_t sz);
    void        (*MemFreeFn)(void* ptr);

    // Optional: notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME in Windows)
    // (default to use native imm32 api on Windows)
    void        (*ImeSetInputScreenPosFn)(int x, int y);
    void*       ImeWindowHandle;            // (Windows) Set this to your HWND to get automatic IME cursor positioning.

    //------------------------------------------------------------------
    // Input - Fill before calling NewFrame()
    //------------------------------------------------------------------

    ImVec2      MousePos;                   // Mouse position, in pixels (set to -1,-1 if no mouse / on another screen, etc.)
    bool        MouseDown[5];               // Mouse buttons: left, right, middle + extras. ImGui itself mostly only uses left button (BeginPopupContext** are using right button). Others buttons allows us to track if the mouse is being used by your application + available to user as a convenience via IsMouse** API.
    float       MouseWheel;                 // Mouse wheel: 1 unit scrolls about 5 lines text.
    bool        MouseDrawCursor;            // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor).
    bool        KeyCtrl;                    // Keyboard modifier pressed: Control
    bool        KeyShift;                   // Keyboard modifier pressed: Shift
    bool        KeyAlt;                     // Keyboard modifier pressed: Alt
    bool        KeySuper;                   // Keyboard modifier pressed: Cmd/Super/Windows
    bool        KeysDown[512];              // Keyboard keys that are pressed (in whatever storage order you naturally have access to keyboard data)
    ImWchar     InputCharacters[16+1];      // List of characters input (translated by user from keypress+keyboard state). Fill using AddInputCharacter() helper.

    // Functions
    void AddInputCharacter(ImWchar c);                        // Add new character into InputCharacters[]
    void AddInputCharactersUTF8(const char* utf8_chars);      // Add new characters into InputCharacters[] from an UTF-8 string
    inline void    ClearInputCharacters() { InputCharacters[0] = 0; }   // Clear the text input buffer manually

    //------------------------------------------------------------------
    // Output - Retrieve after calling NewFrame()
    //------------------------------------------------------------------

    bool        WantCaptureMouse;           // Mouse is hovering a window or widget is active (= ImGui will use your mouse input). Use to hide mouse from the rest of your application
    bool        WantCaptureKeyboard;        // Widget is active (= ImGui will use your keyboard input). Use to hide keyboard from the rest of your application
    bool        WantTextInput;              // Some text input widget is active, which will read input characters from the InputCharacters array. Use to activate on screen keyboard if your system needs one
    float       Framerate;                  // Application framerate estimation, in frame per second. Solely for convenience. Rolling average estimation based on IO.DeltaTime over 120 frames
    int         MetricsAllocs;              // Number of active memory allocations
    int         MetricsRenderVertices;      // Vertices output during last call to Render()
    int         MetricsRenderIndices;       // Indices output during last call to Render() = number of triangles * 3
    int         MetricsActiveWindows;       // Number of visible root windows (exclude child windows)
    ImVec2      MouseDelta;                 // Mouse delta. Note that this is zero if either current or previous position are negative, so a disappearing/reappearing mouse won't have a huge delta for one frame.

    //------------------------------------------------------------------
    // [Private] ImGui will maintain those fields. Forward compatibility not guaranteed!
    //------------------------------------------------------------------

    ImVec2      MousePosPrev;               // Previous mouse position temporary storage (nb: not for public use, set to MousePos in NewFrame())
    bool        MouseClicked[5];            // Mouse button went from !Down to Down
    ImVec2      MouseClickedPos[5];         // Position at time of clicking
    float       MouseClickedTime[5];        // Time of last click (used to figure out double-click)
    bool        MouseDoubleClicked[5];      // Has mouse button been double-clicked?
    bool        MouseReleased[5];           // Mouse button went from Down to !Down
    bool        MouseDownOwned[5];          // Track if button was clicked inside a window. We don't request mouse capture from the application if click started outside ImGui bounds.
    float       MouseDownDuration[5];       // Duration the mouse button has been down (0.0f == just clicked)
    float       MouseDownDurationPrev[5];   // Previous time the mouse button has been down
    float       MouseDragMaxDistanceSqr[5]; // Squared maximum distance of how much mouse has traveled from the click point
    float       KeysDownDuration[512];      // Duration the keyboard key has been down (0.0f == just pressed)
    float       KeysDownDurationPrev[512];  // Previous duration the key has been down

      ImGuiIO();
};

//-----------------------------------------------------------------------------
// Helpers
//-----------------------------------------------------------------------------

// Lightweight std::vector<> like class to avoid dragging dependencies (also: windows implementation of STL with debug enabled is absurdly slow, so let's bypass it so our code runs fast in debug).
// Our implementation does NOT call c++ constructors because we don't use them in ImGui. Don't use this class as a straight std::vector replacement in your code!
template<typename T>
class ImVector
{
public:
    int                         Size;
    int                         Capacity;
    T*                          Data;

    typedef T                   value_type;
    typedef value_type*         iterator;
    typedef const value_type*   const_iterator;

    ImVector()                  { Size = Capacity = 0; Data = NULL; }
    ~ImVector()                 { if (Data) ImGui::MemFree(Data); }

    inline bool                 empty() const                   { return Size == 0; }
    inline int                  size() const                    { return Size; }
    inline int                  capacity() const                { return Capacity; }

    inline value_type&          operator[](int i)               { IM_ASSERT(i < Size); return Data[i]; }
    inline const value_type&    operator[](int i) const         { IM_ASSERT(i < Size); return Data[i]; }

    inline void                 clear()                         { if (Data) { Size = Capacity = 0; ImGui::MemFree(Data); Data = NULL; } }
    inline iterator             begin()                         { return Data; }
    inline const_iterator       begin() const                   { return Data; }
    inline iterator             end()                           { return Data + Size; }
    inline const_iterator       end() const                     { return Data + Size; }
    inline value_type&          front()                         { IM_ASSERT(Size > 0); return Data[0]; }
    inline const value_type&    front() const                   { IM_ASSERT(Size > 0); return Data[0]; }
    inline value_type&          back()                          { IM_ASSERT(Size > 0); return Data[Size-1]; }
    inline const value_type&    back() const                    { IM_ASSERT(Size > 0); return Data[Size-1]; }
    inline void                 swap(ImVector<T>& rhs)          { int rhs_size = rhs.Size; rhs.Size = Size; Size = rhs_size; int rhs_cap = rhs.Capacity; rhs.Capacity = Capacity; Capacity = rhs_cap; value_type* rhs_data = rhs.Data; rhs.Data = Data; Data = rhs_data; }

    inline int                  _grow_capacity(int new_size)    { int new_capacity = Capacity ? (Capacity + Capacity/2) : 8; return new_capacity > new_size ? new_capacity : new_size; }

    inline void                 resize(int new_size)            { if (new_size > Capacity) reserve(_grow_capacity(new_size)); Size = new_size; }
    inline void                 reserve(int new_capacity)
    {
        if (new_capacity <= Capacity) return;
        T* new_data = (value_type*)ImGui::MemAlloc((size_t)new_capacity * sizeof(value_type));
        if (Data)
            memcpy(new_data, Data, (size_t)Size * sizeof(value_type));
        ImGui::MemFree(Data);
        Data = new_data;
        Capacity = new_capacity;
    }

    inline void                 push_back(const value_type& v)  { if (Size == Capacity) reserve(_grow_capacity(Size+1)); Data[Size++] = v; }
    inline void                 pop_back()                      { IM_ASSERT(Size > 0); Size--; }

    inline iterator             erase(const_iterator it)        { IM_ASSERT(it >= Data && it < Data+Size); const ptrdiff_t off = it - Data; memmove(Data + off, Data + off + 1, ((size_t)Size - (size_t)off - 1) * sizeof(value_type)); Size--; return Data + off; }
    inline iterator             insert(const_iterator it, const value_type& v)  { IM_ASSERT(it >= Data && it <= Data+Size); const ptrdiff_t off = it - Data; if (Size == Capacity) reserve(Capacity ? Capacity * 2 : 4); if (off < (int)Size) memmove(Data + off + 1, Data + off, ((size_t)Size - (size_t)off) * sizeof(value_type)); Data[off] = v; Size++; return Data + off; }
};

// Helper: execute a block of code at maximum once a frame
// Convenient if you want to quickly create an UI within deep-nested code that runs multiple times every frame.
// Usage:
//   IMGUI_ONCE_UPON_A_FRAME
//   {
//      // code block will be executed one per frame
//   }
// Attention! the macro expands into 2 statement so make sure you don't use it within e.g. an if() statement without curly braces.
#define IMGUI_ONCE_UPON_A_FRAME    static ImGuiOnceUponAFrame imgui_oaf##__LINE__; if (imgui_oaf##__LINE__)
struct ImGuiOnceUponAFrame
{
    ImGuiOnceUponAFrame() { RefFrame = -1; }
    mutable int RefFrame;
    operator bool() const { int current_frame = ImGui::GetFrameCount(); if (RefFrame == current_frame) return false; RefFrame = current_frame; return true; }
};

// Helper: Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
struct ImGuiTextFilter
{
    struct TextRange
    {
        const char* b;
        const char* e;

        TextRange() { b = e = NULL; }
        TextRange(const char* _b, const char* _e) { b = _b; e = _e; }
        const char* begin() const { return b; }
        const char* end() const { return e; }
        bool empty() const { return b == e; }
        char front() const { return *b; }
        static bool is_blank(char c) { return c == ' ' || c == '\t'; }
        void trim_blanks() { while (b < e && is_blank(*b)) b++; while (e > b && is_blank(*(e-1))) e--; }
        void split(char separator, ImVector<TextRange>& out);
    };

    char                InputBuf[256];
    ImVector<TextRange> Filters;
    int                 CountGrep;

    ImGuiTextFilter(const char* default_filter = "");
    ~ImGuiTextFilter() {}
    void                Clear() { InputBuf[0] = 0; Build(); }
    bool                Draw(const char* label = "Filter (inc,-exc)", float width = 0.0f);    // Helper calling InputText+Build
    bool                PassFilter(const char* text, const char* text_end = NULL) const;
    bool                IsActive() const { return !Filters.empty(); }
    void      Build();
};

// Helper: Text buffer for logging/accumulating text
struct ImGuiTextBuffer
{
    ImVector<char>      Buf;

    ImGuiTextBuffer()   { Buf.push_back(0); }
    inline char         operator[](int i) { return Buf.Data[i]; }
    const char*         begin() const { return &Buf.front(); }
    const char*         end() const { return &Buf.back(); }      // Buf is zero-terminated, so end() will point on the zero-terminator
    int                 size() const { return Buf.Size - 1; }
    bool                empty() { return Buf.Size <= 1; }
    void                clear() { Buf.clear(); Buf.push_back(0); }
    const char*         c_str() const { return Buf.Data; }
    void      append(const char* fmt, ...) IM_PRINTFARGS(2);
    void      appendv(const char* fmt, va_list args);
};

// Helper: Simple Key->value storage
// Typically you don't have to worry about this since a storage is held within each Window.
// We use it to e.g. store collapse state for a tree (Int 0/1), store color edit options.
// You can use it as custom user storage for temporary values.
// Declare your own storage if:
// - You want to manipulate the open/close state of a particular sub-tree in your interface (tree node uses Int 0/1 to store their state).
// - You want to store custom debug data easily without adding or editing structures in your code.
// Types are NOT stored, so it is up to you to make sure your Key don't collide with different types.
struct ImGuiStorage
{
    struct Pair
    {
        ImGuiID key;
        union { int val_i; float val_f; void* val_p; };
        Pair(ImGuiID _key, int _val_i) { key = _key; val_i = _val_i; }
        Pair(ImGuiID _key, float _val_f) { key = _key; val_f = _val_f; }
        Pair(ImGuiID _key, void* _val_p) { key = _key; val_p = _val_p; }
    };
    ImVector<Pair>      Data;

    // - Get***() functions find pair, never add/allocate. Pairs are sorted so a query is O(log N)
    // - Set***() functions find pair, insertion on demand if missing.
    // - Sorted insertion is costly, paid once. A typical frame shouldn't need to insert any new pair.
    void      Clear();
    int       GetInt(ImGuiID key, int default_val = 0) const;
    void      SetInt(ImGuiID key, int val);
    bool      GetBool(ImGuiID key, bool default_val = false) const;
    void      SetBool(ImGuiID key, bool val);
    float     GetFloat(ImGuiID key, float default_val = 0.0f) const;
    void      SetFloat(ImGuiID key, float val);
    void*     GetVoidPtr(ImGuiID key) const; // default_val is NULL
    void      SetVoidPtr(ImGuiID key, void* val);

    // - Get***Ref() functions finds pair, insert on demand if missing, return pointer. Useful if you intend to do Get+Set.
    // - References are only valid until a new value is added to the storage. Calling a Set***() function or a Get***Ref() function invalidates the pointer.
    // - A typical use case where this is convenient for quick hacking (e.g. add storage during a live Edit&Continue session if you can't modify existing struct)
    //      float* pvar = ImGui::GetFloatRef(key); ImGui::SliderFloat("var", pvar, 0, 100.0f); some_var += *pvar;
    int*      GetIntRef(ImGuiID key, int default_val = 0);
    bool*     GetBoolRef(ImGuiID key, bool default_val = false);
    float*    GetFloatRef(ImGuiID key, float default_val = 0.0f);
    void**    GetVoidPtrRef(ImGuiID key, void* default_val = NULL);

    // Use on your own storage if you know only integer are being stored (open/close all tree nodes)
    void      SetAllInt(int val);
};

// Shared state of InputText(), passed to callback when a ImGuiInputTextFlags_Callback* flag is used and the corresponding callback is triggered.
struct ImGuiTextEditCallbackData
{
    ImGuiInputTextFlags EventFlag;      // One of ImGuiInputTextFlags_Callback* // Read-only
    ImGuiInputTextFlags Flags;          // What user passed to InputText()      // Read-only
    void*               UserData;       // What user passed to InputText()      // Read-only
    bool                ReadOnly;       // Read-only mode                       // Read-only

    // CharFilter event:
    ImWchar             EventChar;      // Character input                      // Read-write (replace character or set to zero)

    // Completion,History,Always events:
    // If you modify the buffer contents make sure you update 'BufTextLen' and set 'BufDirty' to true.
    ImGuiKey            EventKey;       // Key pressed (Up/Down/TAB)            // Read-only
    char*               Buf;            // Current text buffer                  // Read-write (pointed data only, can't replace the actual pointer)
    int                 BufTextLen;     // Current text length in bytes         // Read-write
    int                 BufSize;        // Maximum text length in bytes         // Read-only
    bool                BufDirty;       // Set if you modify Buf/BufTextLen!!   // Write
    int                 CursorPos;      //                                      // Read-write
    int                 SelectionStart; //                                      // Read-write (== to SelectionEnd when no selection)
    int                 SelectionEnd;   //                                      // Read-write

    // NB: Helper functions for text manipulation. Calling those function loses selection.
    void    DeleteChars(int pos, int bytes_count);
    void    InsertChars(int pos, const char* text, const char* text_end = NULL);
    bool    HasSelection() const { return SelectionStart != SelectionEnd; }
};

// Resizing callback data to apply custom constraint. As enabled by SetNextWindowSizeConstraints(). Callback is called during the next Begin().
// NB: For basic min/max size constraint on each axis you don't need to use the callback! The SetNextWindowSizeConstraints() parameters are enough.
struct ImGuiSizeConstraintCallbackData
{
    void*   UserData;       // Read-only.   What user passed to SetNextWindowSizeConstraints()
    ImVec2  Pos;            // Read-only.	Window position, for reference.
    ImVec2  CurrentSize;    // Read-only.	Current window size.
    ImVec2  DesiredSize;    // Read-write.  Desired size, based on user's mouse position. Write to this field to restrain resizing.
};

// Helpers macros to generate 32-bits encoded colors
#ifdef IMGUI_USE_BGRA_PACKED_COLOR
#define IM_COL32_R_SHIFT    16
#define IM_COL32_G_SHIFT    8
#define IM_COL32_B_SHIFT    0
#define IM_COL32_A_SHIFT    24
#define IM_COL32_A_MASK     0xFF000000
#else
#define IM_COL32_R_SHIFT    0
#define IM_COL32_G_SHIFT    8
#define IM_COL32_B_SHIFT    16
#define IM_COL32_A_SHIFT    24
#define IM_COL32_A_MASK     0xFF000000
#endif
#define IM_COL32(R,G,B,A)    (((ImU32)(A)<<IM_COL32_A_SHIFT) | ((ImU32)(B)<<IM_COL32_B_SHIFT) | ((ImU32)(G)<<IM_COL32_G_SHIFT) | ((ImU32)(R)<<IM_COL32_R_SHIFT))
#define IM_COL32_WHITE       IM_COL32(255,255,255,255)  // Opaque white = 0xFFFFFFFF
#define IM_COL32_BLACK       IM_COL32(0,0,0,255)        // Opaque black
#define IM_COL32_BLACK_TRANS IM_COL32(0,0,0,0)          // Transparent black = 0x00000000

// ImColor() helper to implicity converts colors to either ImU32 (packed 4x1 byte) or ImVec4 (4x1 float)
// Prefer using IM_COL32() macros if you want a guaranteed compile-time ImU32 for usage with ImDrawList API.
// **Avoid storing ImColor! Store either u32 of ImVec4. This is not a full-featured color class.
// **None of the ImGui API are using ImColor directly but you can use it as a convenience to pass colors in either ImU32 or ImVec4 formats.
struct ImColor
{
    ImVec4              Value;

    ImColor()                                                       { Value.x = Value.y = Value.z = Value.w = 0.0f; }
    ImColor(int r, int g, int b, int a = 255)                       { float sc = 1.0f/255.0f; Value.x = (float)r * sc; Value.y = (float)g * sc; Value.z = (float)b * sc; Value.w = (float)a * sc; }
    ImColor(ImU32 rgba)                                             { float sc = 1.0f/255.0f; Value.x = (float)((rgba>>IM_COL32_R_SHIFT)&0xFF) * sc; Value.y = (float)((rgba>>IM_COL32_G_SHIFT)&0xFF) * sc; Value.z = (float)((rgba>>IM_COL32_B_SHIFT)&0xFF) * sc; Value.w = (float)((rgba>>IM_COL32_A_SHIFT)&0xFF) * sc; }
    ImColor(float r, float g, float b, float a = 1.0f)              { Value.x = r; Value.y = g; Value.z = b; Value.w = a; }
    ImColor(const ImVec4& col)                                      { Value = col; }
    inline operator ImU32() const                                   { return ImGui::ColorConvertFloat4ToU32(Value); }
    inline operator ImVec4() const                                  { return Value; }

    inline void    SetHSV(float h, float s, float v, float a = 1.0f){ ImGui::ColorConvertHSVtoRGB(h, s, v, Value.x, Value.y, Value.z); Value.w = a; }

    static ImColor HSV(float h, float s, float v, float a = 1.0f)   { float r,g,b; ImGui::ColorConvertHSVtoRGB(h, s, v, r, g, b); return ImColor(r,g,b,a); }
};

// Helper: Manually clip large list of items.
// If you are submitting lots of evenly spaced items and you have a random access to the list, you can perform coarse clipping based on visibility to save yourself from processing those items at all.
// The clipper calculates the range of visible items and advance the cursor to compensate for the non-visible items we have skipped. 
// ImGui already clip items based on their bounds but it needs to measure text size to do so. Coarse clipping before submission makes this cost and your own data fetching/submission cost null.
// Usage:
//     ImGuiListClipper clipper(1000);  // we have 1000 elements, evenly spaced.
//     while (clipper.Step())
//         for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
//             ImGui::Text("line number %d", i);
// - Step 0: the clipper let you process the first element, regardless of it being visible or not, so we can measure the element height (step skipped if we passed a known height as second arg to constructor).
// - Step 1: the clipper infer height from first element, calculate the actual range of elements to display, and position the cursor before the first element.
// - (Step 2: dummy step only required if an explicit items_height was passed to constructor or Begin() and user call Step(). Does nothing and switch to Step 3.)
// - Step 3: the clipper validate that we have reached the expected Y position (corresponding to element DisplayEnd), advance the cursor to the end of the list and then returns 'false' to end the loop.
struct ImGuiListClipper
{
    float   StartPosY;
    float   ItemsHeight;
    int     ItemsCount, StepNo, DisplayStart, DisplayEnd;

    // items_count:  Use -1 to ignore (you can call Begin later). Use INT_MAX if you don't know how many items you have (in which case the cursor won't be advanced in the final step).
    // items_height: Use -1.0f to be calculated automatically on first step. Otherwise pass in the distance between your items, typically GetTextLineHeightWithSpacing() or GetItemsLineHeightWithSpacing().
    // If you don't specify an items_height, you NEED to call Step(). If you specify items_height you may call the old Begin()/End() api directly, but prefer calling Step().
    ImGuiListClipper(int items_count = -1, float items_height = -1.0f)  { Begin(items_count, items_height); } // NB: Begin() initialize every fields (as we allow user to call Begin/End multiple times on a same instance if they want).
    ~ImGuiListClipper()                                                 { IM_ASSERT(ItemsCount == -1); }      // Assert if user forgot to call End() or Step() until false.

    bool Step();                                              // Call until it returns false. The DisplayStart/DisplayEnd fields will be set and you can process/draw those items.
    void Begin(int items_count, float items_height = -1.0f);  // Automatically called by constructor if you passed 'items_count' or by Step() in Step 1.
    void End();                                               // Automatically called on the last call of Step() that returns false.
};

//-----------------------------------------------------------------------------
// Draw List
// Hold a series of drawing commands. The user provides a renderer for ImDrawData which essentially contains an array of ImDrawList.
//-----------------------------------------------------------------------------

// Draw callbacks for advanced uses.
// NB- You most likely do NOT need to use draw callbacks just to create your own widget or customized UI rendering (you can poke into the draw list for that)
// Draw callback may be useful for example, A) Change your GPU render state, B) render a complex 3D scene inside a UI element (without an intermediate texture/render target), etc.
// The expected behavior from your rendering function is 'if (cmd.UserCallback != NULL) cmd.UserCallback(parent_list, cmd); else RenderTriangles()'
typedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd);

// Typically, 1 command = 1 gpu draw call (unless command is a callback)
struct ImDrawCmd
{
    unsigned int    ElemCount;              // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored in the callee ImDrawList's vtx_buffer[] array, indices in idx_buffer[].
    ImVec4          ClipRect;               // Clipping rectangle (x1, y1, x2, y2)
    ImTextureID     TextureId;              // User-provided texture ID. Set by user in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
    ImDrawCallback  UserCallback;           // If != NULL, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
    void*           UserCallbackData;       // The draw callback code can access this.

    ImDrawCmd() { ElemCount = 0; ClipRect.x = ClipRect.y = -8192.0f; ClipRect.z = ClipRect.w = +8192.0f; TextureId = NULL; UserCallback = NULL; UserCallbackData = NULL; }
};

// Vertex index (override with '#define ImDrawIdx unsigned int' inside in imconfig.h)
#ifndef ImDrawIdx
typedef unsigned short ImDrawIdx;
#endif

// Vertex layout
#ifndef IMGUI_OVERRIDE_DRAWVERT_STRUCT_LAYOUT
struct ImDrawVert
{
    ImVec2  pos;
    ImVec2  uv;
    ImU32   col;
};
#else
// You can override the vertex format layout by defining IMGUI_OVERRIDE_DRAWVERT_STRUCT_LAYOUT in imconfig.h
// The code expect ImVec2 pos (8 bytes), ImVec2 uv (8 bytes), ImU32 col (4 bytes), but you can re-order them or add other fields as needed to simplify integration in your engine.
// The type has to be described within the macro (you can either declare the struct or use a typedef)
IMGUI_OVERRIDE_DRAWVERT_STRUCT_LAYOUT;
#endif

// Draw channels are used by the Columns API to "split" the render list into different channels while building, so items of each column can be batched together.
// You can also use them to simulate drawing layers and submit primitives in a different order than how they will be rendered.
struct ImDrawChannel
{
    ImVector<ImDrawCmd>     CmdBuffer;
    ImVector<ImDrawIdx>     IdxBuffer;
};

// Draw command list
// This is the low-level list of polygons that ImGui functions are filling. At the end of the frame, all command lists are passed to your ImGuiIO::RenderDrawListFn function for rendering.
// At the moment, each ImGui window contains its own ImDrawList but they could potentially be merged in the future.
// If you want to add custom rendering within a window, you can use ImGui::GetWindowDrawList() to access the current draw list and add your own primitives.
// You can interleave normal ImGui:: calls and adding primitives to the current draw list.
// All positions are in screen coordinates (0,0=top-left, 1 pixel per unit). Primitives are always added to the list and not culled (culling is done at render time and at a higher-level by ImGui:: functions).
struct ImDrawList
{
    // This is what you have to render
    ImVector<ImDrawCmd>     CmdBuffer;          // Commands. Typically 1 command = 1 gpu draw call.
    ImVector<ImDrawIdx>     IdxBuffer;          // Index buffer. Each command consume ImDrawCmd::ElemCount of those
    ImVector<ImDrawVert>    VtxBuffer;          // Vertex buffer.

    // [Internal, used while building lists]
    const char*             _OwnerName;         // Pointer to owner window's name for debugging
    unsigned int            _VtxCurrentIdx;     // [Internal] == VtxBuffer.Size
    ImDrawVert*             _VtxWritePtr;       // [Internal] point within VtxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    ImDrawIdx*              _IdxWritePtr;       // [Internal] point within IdxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    ImVector<ImVec4>        _ClipRectStack;     // [Internal]
    ImVector<ImTextureID>   _TextureIdStack;    // [Internal]
    ImVector<ImVec2>        _Path;              // [Internal] current path building
    int                     _ChannelsCurrent;   // [Internal] current channel number (0)
    int                     _ChannelsCount;     // [Internal] number of active channels (1+)
    ImVector<ImDrawChannel> _Channels;          // [Internal] draw channels for columns API (not resized down so _ChannelsCount may be smaller than _Channels.Size)

    ImDrawList()  { _OwnerName = NULL; Clear(); }
    ~ImDrawList() { ClearFreeMemory(); }
    void  PushClipRect(ImVec2 clip_rect_min, ImVec2 clip_rect_max, bool intersect_with_current_clip_rect = false);  // Render-level scissoring. This is passed down to your render function but not used for CPU-side coarse clipping. Prefer using higher-level ImGui::PushClipRect() to affect logic (hit-testing and widget culling)
    void  PushClipRectFullScreen();
    void  PopClipRect();
    void  PushTextureID(const ImTextureID& texture_id);
    void  PopTextureID();

    // Primitives
    void  AddLine(const ImVec2& a, const ImVec2& b, ImU32 col, float thickness = 1.0f);
    void  AddRect(const ImVec2& a, const ImVec2& b, ImU32 col, float rounding = 0.0f, int rounding_corners_flags = ~0, float thickness = 1.0f);   // a: upper-left, b: lower-right, rounding_corners_flags: 4-bits corresponding to which corner to round
    void  AddRectFilled(const ImVec2& a, const ImVec2& b, ImU32 col, float rounding = 0.0f, int rounding_corners_flags = ~0);                     // a: upper-left, b: lower-right
    void  AddRectFilledMultiColor(const ImVec2& a, const ImVec2& b, ImU32 col_upr_left, ImU32 col_upr_right, ImU32 col_bot_right, ImU32 col_bot_left);
    void  AddQuad(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, ImU32 col, float thickness = 1.0f);
    void  AddQuadFilled(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, ImU32 col);
    void  AddTriangle(const ImVec2& a, const ImVec2& b, const ImVec2& c, ImU32 col, float thickness = 1.0f);
    void  AddTriangleFilled(const ImVec2& a, const ImVec2& b, const ImVec2& c, ImU32 col);
    void  AddCircle(const ImVec2& centre, float radius, ImU32 col, int num_segments = 12, float thickness = 1.0f);
    void  AddCircleFilled(const ImVec2& centre, float radius, ImU32 col, int num_segments = 12);
    void  AddText(const ImVec2& pos, ImU32 col, const char* text_begin, const char* text_end = NULL);
    void  AddText(const ImFont* font, float font_size, const ImVec2& pos, ImU32 col, const char* text_begin, const char* text_end = NULL, float wrap_width = 0.0f, const ImVec4* cpu_fine_clip_rect = NULL);
    void  AddImage(ImTextureID user_texture_id, const ImVec2& a, const ImVec2& b, const ImVec2& uv_a = ImVec2(0,0), const ImVec2& uv_b = ImVec2(1,1), ImU32 col = 0xFFFFFFFF);
    void  AddImageQuad(ImTextureID user_texture_id, const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a = ImVec2(0,0), const ImVec2& uv_b = ImVec2(1,0), const ImVec2& uv_c = ImVec2(1,1), const ImVec2& uv_d = ImVec2(0,1), ImU32 col = 0xFFFFFFFF);
    void  AddPolyline(const ImVec2* points, const int num_points, ImU32 col, bool closed, float thickness, bool anti_aliased);
    void  AddConvexPolyFilled(const ImVec2* points, const int num_points, ImU32 col, bool anti_aliased);
    void  AddBezierCurve(const ImVec2& pos0, const ImVec2& cp0, const ImVec2& cp1, const ImVec2& pos1, ImU32 col, float thickness, int num_segments = 0);

    // Stateful path API, add points then finish with PathFill() or PathStroke()
    inline    void  PathClear()                                                 { _Path.resize(0); }
    inline    void  PathLineTo(const ImVec2& pos)                               { _Path.push_back(pos); }
    inline    void  PathLineToMergeDuplicate(const ImVec2& pos)                 { if (_Path.Size == 0 || memcmp(&_Path[_Path.Size-1], &pos, 8) != 0) _Path.push_back(pos); }
    inline    void  PathFillConvex(ImU32 col)                                   { AddConvexPolyFilled(_Path.Data, _Path.Size, col, true); PathClear(); }
    inline    void  PathStroke(ImU32 col, bool closed, float thickness = 1.0f)  { AddPolyline(_Path.Data, _Path.Size, col, closed, thickness, true); PathClear(); }
    void  PathArcTo(const ImVec2& centre, float radius, float a_min, float a_max, int num_segments = 10);
    void  PathArcToFast(const ImVec2& centre, float radius, int a_min_of_12, int a_max_of_12);                                // Use precomputed angles for a 12 steps circle
    void  PathBezierCurveTo(const ImVec2& p1, const ImVec2& p2, const ImVec2& p3, int num_segments = 0);
    void  PathRect(const ImVec2& rect_min, const ImVec2& rect_max, float rounding = 0.0f, int rounding_corners_flags = ~0);   // rounding_corners_flags: 4-bits corresponding to which corner to round

    // Channels
    // - Use to simulate layers. By switching channels to can render out-of-order (e.g. submit foreground primitives before background primitives)
    // - Use to minimize draw calls (e.g. if going back-and-forth between multiple non-overlapping clipping rectangles, prefer to append into separate channels then merge at the end)
    void  ChannelsSplit(int channels_count);
    void  ChannelsMerge();
    void  ChannelsSetCurrent(int channel_index);

    // Advanced
    void  AddCallback(ImDrawCallback callback, void* callback_data);  // Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
    void  AddDrawCmd();                                               // This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible

    // Internal helpers
    // NB: all primitives needs to be reserved via PrimReserve() beforehand!
    void  Clear();
    void  ClearFreeMemory();
    void  PrimReserve(int idx_count, int vtx_count);
    void  PrimRect(const ImVec2& a, const ImVec2& b, ImU32 col);      // Axis aligned rectangle (composed of two triangles)
    void  PrimRectUV(const ImVec2& a, const ImVec2& b, const ImVec2& uv_a, const ImVec2& uv_b, ImU32 col);
    void  PrimQuadUV(const ImVec2& a, const ImVec2& b, const ImVec2& c, const ImVec2& d, const ImVec2& uv_a, const ImVec2& uv_b, const ImVec2& uv_c, const ImVec2& uv_d, ImU32 col);
    inline    void  PrimWriteVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col){ _VtxWritePtr->pos = pos; _VtxWritePtr->uv = uv; _VtxWritePtr->col = col; _VtxWritePtr++; _VtxCurrentIdx++; }
    inline    void  PrimWriteIdx(ImDrawIdx idx)                                 { *_IdxWritePtr = idx; _IdxWritePtr++; }
    inline    void  PrimVtx(const ImVec2& pos, const ImVec2& uv, ImU32 col)     { PrimWriteIdx((ImDrawIdx)_VtxCurrentIdx); PrimWriteVtx(pos, uv, col); }
    void  UpdateClipRect();
    void  UpdateTextureID();
};

// All draw data to render an ImGui frame
struct ImDrawData
{
    bool            Valid;                  // Only valid after Render() is called and before the next NewFrame() is called.
    ImDrawList**    CmdLists;
    int             CmdListsCount;
    int             TotalVtxCount;          // For convenience, sum of all cmd_lists vtx_buffer.Size
    int             TotalIdxCount;          // For convenience, sum of all cmd_lists idx_buffer.Size

    // Functions
    ImDrawData() { Valid = false; CmdLists = NULL; CmdListsCount = TotalVtxCount = TotalIdxCount = 0; }
    void DeIndexAllBuffers();               // For backward compatibility: convert all buffers from indexed to de-indexed, in case you cannot render indexed. Note: this is slow and most likely a waste of resources. Always prefer indexed rendering!
    void ScaleClipRects(const ImVec2& sc);  // Helper to scale the ClipRect field of each ImDrawCmd. Use if your final output buffer is at a different scale than ImGui expects, or if there is a difference between your window resolution and framebuffer resolution.
};

struct ImFontConfig
{
    void*           FontData;                   //          // TTF data
    int             FontDataSize;               //          // TTF data size
    bool            FontDataOwnedByAtlas;       // true     // TTF data ownership taken by the container ImFontAtlas (will delete memory itself). Set to true
    int             FontNo;                     // 0        // Index of font within TTF file
    float           SizePixels;                 //          // Size in pixels for rasterizer
    int             OversampleH, OversampleV;   // 3, 1     // Rasterize at higher quality for sub-pixel positioning. We don't use sub-pixel positions on the Y axis.
    bool            PixelSnapH;                 // false    // Align every glyph to pixel boundary. Useful e.g. if you are merging a non-pixel aligned font with the default font. If enabled, you can set OversampleH/V to 1.
    ImVec2          GlyphExtraSpacing;          // 0, 0     // Extra spacing (in pixels) between glyphs
    const ImWchar*  GlyphRanges;                //          // Pointer to a user-provided list of Unicode range (2 value per range, values are inclusive, zero-terminated list). THE ARRAY DATA NEEDS TO PERSIST AS LONG AS THE FONT IS ALIVE.
    bool            MergeMode;                  // false    // Merge into previous ImFont, so you can combine multiple inputs font into one ImFont (e.g. ASCII font + icons + Japanese glyphs).
    bool            MergeGlyphCenterV;          // false    // When merging (multiple ImFontInput for one ImFont), vertically center new glyphs instead of aligning their baseline

    // [Internal]
    char            Name[32];                               // Name (strictly for debugging)
    ImFont*         DstFont;

    ImFontConfig();
};

// Load and rasterize multiple TTF fonts into a same texture.
// Sharing a texture for multiple fonts allows us to reduce the number of draw calls during rendering.
// We also add custom graphic data into the texture that serves for ImGui.
//  1. (Optional) Call AddFont*** functions. If you don't call any, the default font will be loaded for you.
//  2. Call GetTexDataAsAlpha8() or GetTexDataAsRGBA32() to build and retrieve pixels data.
//  3. Upload the pixels data into a texture within your graphics system.
//  4. Call SetTexID(my_tex_id); and pass the pointer/identifier to your texture. This value will be passed back to you during rendering to identify the texture.
//  5. Call ClearTexData() to free textures memory on the heap.
// NB: If you use a 'glyph_ranges' array you need to make sure that your array persist up until the ImFont is cleared. We only copy the pointer, not the data.
struct ImFontAtlas
{
    ImFontAtlas();
    ~ImFontAtlas();
    ImFont*           AddFont(const ImFontConfig* font_cfg);
    ImFont*           AddFontDefault(const ImFontConfig* font_cfg = NULL);
    ImFont*           AddFontFromFileTTF(const char* filename, float size_pixels, const ImFontConfig* font_cfg = NULL, const ImWchar* glyph_ranges = NULL);
    ImFont*           AddFontFromMemoryTTF(void* ttf_data, int ttf_size, float size_pixels, const ImFontConfig* font_cfg = NULL, const ImWchar* glyph_ranges = NULL);                                        // Transfer ownership of 'ttf_data' to ImFontAtlas, will be deleted after Build()
    ImFont*           AddFontFromMemoryCompressedTTF(const void* compressed_ttf_data, int compressed_ttf_size, float size_pixels, const ImFontConfig* font_cfg = NULL, const ImWchar* glyph_ranges = NULL);  // 'compressed_ttf_data' still owned by caller. Compress with binary_to_compressed_c.cpp
    ImFont*           AddFontFromMemoryCompressedBase85TTF(const char* compressed_ttf_data_base85, float size_pixels, const ImFontConfig* font_cfg = NULL, const ImWchar* glyph_ranges = NULL);              // 'compressed_ttf_data_base85' still owned by caller. Compress with binary_to_compressed_c.cpp with -base85 paramaeter
    void              ClearTexData();             // Clear the CPU-side texture data. Saves RAM once the texture has been copied to graphics memory.
    void              ClearInputData();           // Clear the input TTF data (inc sizes, glyph ranges)
    void              ClearFonts();               // Clear the ImGui-side font data (glyphs storage, UV coordinates)
    void              Clear();                    // Clear all

    // Retrieve texture data
    // User is in charge of copying the pixels into graphics memory, then call SetTextureUserID()
    // After loading the texture into your graphic system, store your texture handle in 'TexID' (ignore if you aren't using multiple fonts nor images)
    // RGBA32 format is provided for convenience and high compatibility, but note that all RGB pixels are white, so 75% of the memory is wasted.
    // Pitch = Width * BytesPerPixels
    void              GetTexDataAsAlpha8(unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = NULL);  // 1 byte per-pixel
    void              GetTexDataAsRGBA32(unsigned char** out_pixels, int* out_width, int* out_height, int* out_bytes_per_pixel = NULL);  // 4 bytes-per-pixel
    void                        SetTexID(void* id)  { TexID = id; }

    // Helpers to retrieve list of common Unicode ranges (2 value per range, values are inclusive, zero-terminated list)
    // NB: Make sure that your string are UTF-8 and NOT in your local code page. See FAQ for details.
    const ImWchar*    GetGlyphRangesDefault();    // Basic Latin, Extended Latin
    const ImWchar*    GetGlyphRangesKorean();     // Default + Korean characters
    const ImWchar*    GetGlyphRangesJapanese();   // Default + Hiragana, Katakana, Half-Width, Selection of 1946 Ideographs
    const ImWchar*    GetGlyphRangesChinese();    // Japanese + full set of about 21000 CJK Unified Ideographs
    const ImWchar*    GetGlyphRangesCyrillic();   // Default + about 400 Cyrillic characters
    const ImWchar*    GetGlyphRangesThai();       // Default + Thai characters

    // Members
    // (Access texture data via GetTexData*() calls which will setup a default font for you.)
    void*                       TexID;              // User data to refer to the texture once it has been uploaded to user's graphic systems. It ia passed back to you during rendering.
    unsigned char*              TexPixelsAlpha8;    // 1 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight
    unsigned int*               TexPixelsRGBA32;    // 4 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight * 4
    int                         TexWidth;           // Texture width calculated during Build().
    int                         TexHeight;          // Texture height calculated during Build().
    int                         TexDesiredWidth;    // Texture width desired by user before Build(). Must be a power-of-two. If have many glyphs your graphics API have texture size restrictions you may want to increase texture width to decrease height.
    ImVec2                      TexUvWhitePixel;    // Texture coordinates to a white pixel
    ImVector<ImFont*>           Fonts;              // Hold all the fonts returned by AddFont*. Fonts[0] is the default font upon calling ImGui::NewFrame(), use ImGui::PushFont()/PopFont() to change the current font.

    // Private
    ImVector<ImFontConfig>      ConfigData;         // Internal data
    bool              Build();            // Build pixels data. This is automatically for you by the GetTexData*** functions.
    void              RenderCustomTexData(int pass, void* rects);
};

// Font runtime data and rendering
// ImFontAtlas automatically loads a default embedded font for you when you call GetTexDataAsAlpha8() or GetTexDataAsRGBA32().
struct ImFont
{
    struct Glyph
    {
        ImWchar                 Codepoint;
        float                   XAdvance;
        float                   X0, Y0, X1, Y1;
        float                   U0, V0, U1, V1;     // Texture coordinates
    };

    // Members: Hot ~62/78 bytes
    float                       FontSize;           // <user set>   // Height of characters, set during loading (don't change after loading)
    float                       Scale;              // = 1.f        // Base font scale, multiplied by the per-window font scale which you can adjust with SetFontScale()
    ImVec2                      DisplayOffset;      // = (0.f,1.f)  // Offset font rendering by xx pixels
    ImVector<Glyph>             Glyphs;             //              // All glyphs.
    ImVector<float>             IndexXAdvance;      //              // Sparse. Glyphs->XAdvance in a directly indexable way (more cache-friendly, for CalcTextSize functions which are often bottleneck in large UI).
    ImVector<unsigned short>    IndexLookup;        //              // Sparse. Index glyphs by Unicode code-point.
    const Glyph*                FallbackGlyph;      // == FindGlyph(FontFallbackChar)
    float                       FallbackXAdvance;   // == FallbackGlyph->XAdvance
    ImWchar                     FallbackChar;       // = '?'        // Replacement glyph if one isn't found. Only set via SetFallbackChar()

    // Members: Cold ~18/26 bytes
    short                       ConfigDataCount;    // ~ 1          // Number of ImFontConfig involved in creating this font. Bigger than 1 when merging multiple font sources into one ImFont.
    ImFontConfig*               ConfigData;         //              // Pointer within ContainerAtlas->ConfigData
    ImFontAtlas*                ContainerAtlas;     //              // What we has been loaded into
    float                       Ascent, Descent;    //              // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    int                         MetricsTotalSurface;//              // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)

    // Methods
    ImFont();
    ~ImFont();
    void              Clear();
    void              BuildLookupTable();
    const Glyph*      FindGlyph(ImWchar c) const;
    void              SetFallbackChar(ImWchar c);
    float                       GetCharAdvance(ImWchar c) const     { return ((int)c < IndexXAdvance.Size) ? IndexXAdvance[(int)c] : FallbackXAdvance; }
    bool                        IsLoaded() const                    { return ContainerAtlas != NULL; }

    // 'max_width' stops rendering after a certain width (could be turned into a 2d size). FLT_MAX to disable.
    // 'wrap_width' enable automatic word-wrapping across multiple lines to fit into given width. 0.0f to disable.
    ImVec2            CalcTextSizeA(float size, float max_width, float wrap_width, const char* text_begin, const char* text_end = NULL, const char** remaining = NULL) const; // utf8
    const char*       CalcWordWrapPositionA(float scale, const char* text, const char* text_end, float wrap_width) const;
    void              RenderChar(ImDrawList* draw_list, float size, ImVec2 pos, ImU32 col, unsigned short c) const;
    void              RenderText(ImDrawList* draw_list, float size, ImVec2 pos, ImU32 col, const ImVec4& clip_rect, const char* text_begin, const char* text_end, float wrap_width = 0.0f, bool cpu_fine_clip = false) const;

    // Private
    void              GrowIndex(int new_size);
    void              AddRemapChar(ImWchar dst, ImWchar src, bool overwrite_dst = true); // Makes 'dst' character/glyph points to 'src' character/glyph. Currently needs to be called AFTER fonts have been built.
};

#if defined(__clang__)
#pragma clang diagnostic pop
#endif

// Include imgui_user.h at the end of imgui.h (convenient for user to only explicitly include vanilla imgui.h)
#ifdef IMGUI_INCLUDE_IMGUI_USER_H
#include "imgui_user.h"
#endif
