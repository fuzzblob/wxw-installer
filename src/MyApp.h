#pragma once

#include <wx/wx.h>

namespace wxInstaller
{
    class MyApp : public wxApp {
    public:
        MyApp();
        ~MyApp();

        bool OnInit();
    };

    class MyFrame : public wxFrame {
    public:
        MyFrame(const wxString& title) : wxFrame(nullptr, wxID_ANY, title) {
            // Initialize components here

        };
    };
};
