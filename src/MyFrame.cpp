#include "MyFrame.h"

namespace wxInstaller
{
    MyFrame::MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title) {
        // Initialize components here

        // Create a panel to hold the widgets
        wxPanel* panel = new wxPanel(this);

        // Create a button
        wxButton* button = new wxButton(panel, wxID_ANY, "Click Me!", wxDefaultPosition, wxSize(100, 30));
    };
};
