[Setting hidden]
bool ShowWindow = false;

auto font = UI::LoadFont("DroidSans.ttf", 60);

/** Render function called every frame intended for `UI`.
*/
void RenderInterface() {
    if (!ShowWindow) return;
    UI::PushFont(font);
    UI::SetNextWindowSize(800, 300, UI::Cond::Always);
    if (UI::Begin(Meta::ExecutingPlugin().Name, ShowWindow, UI::WindowFlags::NoResize | UI::WindowFlags::NoCollapse)) {
        UI::Text("Current Camera: " + tostring(ActiveCam::CurrentCamera()));
        UI::End();
    }
    UI::PopFont();
}

#if SIG_DEVELOPER
/** Render function called every frame intended only for menu items in `UI`.
*/
void RenderMenu() {
    if (UI::MenuItem("\\$f00" + Icons::Stethoscope + "\\$z " + Meta::ExecutingPlugin().Name, "", ShowWindow)) {
        ShowWindow = !ShowWindow;
    }
}
#endif
