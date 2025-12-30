#include "MyFrame.h"
#include <wx/wx.h>

namespace wxInstaller
{
    MyFrame::MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title) {
        // Initialize components here

        // Create a panel to hold the widgets
        wxPanel* panel = new wxPanel(this);

        // Vertical layout for the contents
        auto* mainSizer = new wxBoxSizer(wxVERTICAL);
        // horizontal layout to hold the buttons
        auto* buttonSizer = new wxBoxSizer(wxHORIZONTAL);

        // create the Next and Cancel buttons
        auto* buttonNext = new wxButton(panel, wxID_ANY, "Next");
        buttonSizer->Add(buttonNext, 0, wxALL, 5);
        auto* buttonCancel = new wxButton(panel, wxID_ANY, "Cancel");
        buttonSizer->Add(buttonCancel, 0, wxALL, 5);

        // add buttons to main vertical layout
        mainSizer->Add(buttonSizer, 0, wxALIGN_CENTER | wxALL, 10);
        // apply main layout
        panel->SetSizer(mainSizer);

        // Set the size of the frame
        this->SetSize(300, 200);

        // Bind the button click event
        buttonNext->Bind(wxEVT_BUTTON, &MyFrame::OnButtonClick, this);
    };

    void MyFrame::OnButtonClick(wxCommandEvent& event) {
        wxMessageBox("Button clicked!", "Info", wxOK | wxICON_INFORMATION);
    }
};
