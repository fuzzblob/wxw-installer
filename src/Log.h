#pragma once

#include <iostream>
#include <source_location>
#include <string_view>

namespace wxInstaller
{
    void Log(const std::string_view message,
            const std::source_location location =
                std::source_location::current())
    {
        std::clog << "file: "
                << location.file_name() << "("
                << location.line() << ":"
                << location.column() << ")\n\t"
                << location.function_name() << ":\n\t"
                << "\"" << message << "\"\n";
    }
}