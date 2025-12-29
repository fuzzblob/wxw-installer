#include <wx/wx.h>

class MyFrame : public wxFrame {
public:
    MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title) {
        // Initialize components here
    }
};

class MyApp : public wxApp {
public:
    MyApp() {}
    ~MyApp() {}

    bool OnInit() {
        // Create the main window
        MyFrame* frame = new MyFrame("My First wxWidgets App");
        frame->Show(true);
        return true;
    }
};

IMPLEMENT_APP(MyApp)
