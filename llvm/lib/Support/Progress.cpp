//===--- lib/Support/Progress.cpp - ANSI Terminal Progress Bar --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  This file defines an ANSI Terminal Progress Bar.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Progress.h"

#include "llvm/Support/Compiler.h"
#include "llvm/Support/Process.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"

#include <cassert>
#if defined(__unix__) || defined(__unix)
#include <sys/ioctl.h>
#include <unistd.h>
#elif defined(_WIN32)
#include <windows.h>
#endif

#define ENABLE_VIRTUAL_TERMINAL_PROCESSING 0x0004

using namespace llvm;

void ProgressBar::update(float Percent, StringRef Msg) {
  if (!OS.is_displayed() && !LLVM_UNLIKELY(UnderTest))
    return;

  std::string ETAStr = "";
  if (ShowETA) {
    if (!Visible)
      Start = std::chrono::system_clock::now();
    auto Elapsed = std::chrono::duration_cast<std::chrono::seconds>(
         std::chrono::system_clock::now() - Start).count();
    if (Percent > 0.0001 && Elapsed > 1) {
      auto Total = Elapsed / Percent;
      auto ETA = unsigned(Total - Elapsed);
      unsigned HH = ETA / 3600;
      unsigned MM = (ETA / 60) % 60;
      unsigned SS = ETA % 60;
      raw_string_ostream RSO(ETAStr);
      RSO << format(" ETA %02d:%02d:%02d", HH, MM, SS);
      ETAStr = RSO.str();
    }
  }

  if (LastUpdate &&
      std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::system_clock::now() - *LastUpdate).count() <
      RefreshRate && !LLVM_UNLIKELY(UnderTest))
    return;

  clear();

  unsigned terminalColumns = sys::Process::StandardOutColumns();
  if (!sys::Process::StandardOutColumns()) {
#if defined(__unix__) || defined(__unix)
    struct winsize size;
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);
    terminalColumns = size.ws_col;
#elif defined(_WIN32)
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);
    terminalColumns = csbi.srWindow.Right - csbi.srWindow.Left + 1;
#endif
  }

  unsigned TotalWidth = UnderTest ? 60 : terminalColumns;
  unsigned PBWidth = TotalWidth - (1 + 4 + 2 + 1 + ETAStr.size() + 1);
  unsigned PBDone = PBWidth * Percent;

  // Centered header
  (OS.indent((TotalWidth - Header.size()) / 2)
     .changeColor(HeaderColor, /*Bold=*/true)
     << Header).resetColor() << "\n";

  // Progress bar
  OS << format(" %3d%% ", unsigned(100 * Percent));
  (OS.changeColor(BarColor, /*Bold=*/true) << '[').resetColor();
  (OS.changeColor(BarColor, /*Bold=*/true)
   << std::string(PBDone, '=') << std::string(PBWidth - PBDone, '-'))
      .resetColor();
  (OS.changeColor(BarColor, /*Bold=*/true) << ']').resetColor();
  OS << ETAStr << "\n";

  // Footer messaage
  if (Msg.size() < TotalWidth) {
    OS << Msg;
    Width = Msg.size();
  } else {
    OS << Msg.substr(0, TotalWidth - 4) << "... ";
    Width = TotalWidth;
  }

#if defined(__unix) || defined(__unix__)
  // Hide the cursor
  OS << "\033[?25l";
#elif defined(_WIN32)
  // Hide the cursor
  OS << "\x1B[?25l";
#endif

  OS.flush();
  Visible = true;
  LastUpdate = std::chrono::system_clock::now();
}

void ProgressBar::clear() {
  if (!LLVM_UNLIKELY(UnderTest)) {
    if (!Visible)
      return;

    if (!OS.is_displayed())
      return;
  }

#if defined(__unix__) || defined(__unix)
  // Move to beginning of current the line
  OS << "\033[" << (Width + 1)
     << "D"

     // Clear it
     << "\033[2K"

     // Move up a line and clear it
     << "\033[1A\033[2K"

     // Move up a line and clear it
     << "\033[1A\033[2K"

     // Unhide the cursor
     << "\033[?25h";
#elif defined(_WIN32)
  DWORD l_mode;
  HANDLE hStdout = GetStdHandle(STD_OUTPUT_HANDLE);
  GetConsoleMode(hStdout, &l_mode);
  SetConsoleMode(hStdout, l_mode | ENABLE_VIRTUAL_TERMINAL_PROCESSING);
  // Move to beginning of current the line
  OS << "\x1B[" << (Width + 1)
     << "D"

     // Clear it
     << "\x1B[2K"

     // Move up a line and clear it
     << "\x1B[1A\x1B[2K"

     // Move up a line and clear it
     << "\x1B[1A\x1B[2K"

     // Unhide the cursor
     << "\x1B[?25h";
#endif

  OS.flush();
  Visible = false;
}

