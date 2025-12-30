#include "MyApp.h"

namespace wxInstaller
{
    MyApp::MyApp() {};
    MyApp::~MyApp() {};

    bool MyApp::OnInit() {
        // Create the main window
        MyFrame* frame = new MyFrame("My First wxWidgets App");
        frame->Show(true);
        return true;
    };
};

IMPLEMENT_APP(wxInstaller::MyApp)
