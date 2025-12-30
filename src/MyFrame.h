#pragma once

#include <wx/wx.h>

namespace wxInstaller
{
    class MyFrame : public wxFrame {
    public:
        using wxFrame::wxFrame;
        MyFrame(const wxString& title);
    };
};
