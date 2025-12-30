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
};
