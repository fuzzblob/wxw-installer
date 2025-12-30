#include "MyFrame.h"
#include <wx/wx.h>

namespace wxInstaller
{
    MyFrame::MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title) {
        // Initialize components here

        // Create a panel to hold the widgets
        wxPanel* panel = new wxPanel(this);

        // Create a button
        wxButton* button = new wxButton(panel, wxID_ANY, "Click Me!", wxDefaultPosition, wxSize(100, 30));

        // Create a sizer to manage the layout
        wxBoxSizer* sizer = new wxBoxSizer(wxVERTICAL);
        sizer->Add(button, 0, wxALIGN_CENTER | wxALL, 10);

        // Set the sizer for the panel
        panel->SetSizer(sizer);

        // Set the size of the frame
        this->SetSize(300, 200);
    };
};
