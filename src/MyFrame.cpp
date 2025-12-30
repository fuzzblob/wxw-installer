#include "MyFrame.h"
#include "Log.h"
#include <wx/wx.h>

namespace wxInstaller
{
    MyFrame::MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title)
    {
        // Create a panel to hold the widgets
        auto* panel = new wxPanel(this);
        // Vertical layout for the contents
        auto* mainSizer = new wxBoxSizer(wxVERTICAL);
        mainSizer->SetMinSize(300, 200);

        // add text to main vertical layout
        auto* textSizer = WelcomeTextSizer(panel);
        mainSizer->Add(textSizer, 0, wxEXPAND | wxALL, 10);

        // add buttons to main vertical layout
        auto* buttonSizer = ButtonSizer(panel);
        mainSizer->Add(buttonSizer, 0, wxALIGN_CENTER | wxALL, 10);

        // apply main layout
        panel->SetSizer(mainSizer);

    };

    wxBoxSizer* MyFrame::WelcomeTextSizer(wxPanel* panel)
    {
        // Create the wxStaticText control
        auto* staticText = new wxStaticText(panel, wxID_ANY, "TODO: put README in here");
        // Set up the sizer for the panel
        auto* textSizer = new wxBoxSizer(wxHORIZONTAL);
        textSizer->SetMinSize(300, 160);
        textSizer->Add(staticText, 1, wxEXPAND);
        return textSizer;
    }

    wxBoxSizer* MyFrame::ButtonSizer(wxPanel* panel)
    {
        // horizontal layout to hold the buttons
        auto* buttonSizer = new wxBoxSizer(wxHORIZONTAL);

        // create the Next and Cancel buttons
        auto* buttonNext = new wxButton(panel, wxID_ANY, "Next");
        buttonSizer->Add(buttonNext, 0, wxALL, 5);
        // Bind the button click event
        buttonNext->Bind(wxEVT_BUTTON, &MyFrame::OnButtonClick, this);

        // create Cancel button
        auto* buttonCancel = new wxButton(panel, wxID_ANY, "Cancel");
        buttonSizer->Add(buttonCancel, 0, wxALL, 5);
        // Bind the button click event
        buttonCancel->Bind(wxEVT_BUTTON, &MyFrame::OnButtonClick, this);

        return buttonSizer;
    }

    void MyFrame::OnButtonClick(wxCommandEvent& event)
    {
        Log("Button clicked! Function not implemented...");
    }
};
