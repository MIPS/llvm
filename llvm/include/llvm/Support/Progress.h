//===--- Progress.h - ANSI Terminal Progress Bar ----------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  This file declares an ANSI Terminal Progress Bar.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_SUPPORT_PROGRESS_H
#define LLVM_SUPPORT_PROGRESS_H

#include "llvm/ADT/Optional.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"

#include <string>
#include <chrono>

namespace llvm {
/// A 3-line progress bar, which looks like:
///
/// \verbatim
///
///                                Header
///        20% [===========----------------------------------]
///       progress message
///
/// \endverbatim
///
/// This is modeled heavily off of the one in LIT.
class ProgressBar {
  // Colors purposefully chosen to be *different* than LIT's so as not to be
  // confusing. For just about everything else, we try to match the behavior
  // pretty closely.
  static const auto HeaderColor = llvm::raw_ostream::YELLOW;
  static const auto BarColor = llvm::raw_ostream::MAGENTA;
  static const unsigned RefreshRate = 50; //< Max refresh rate, in milliseconds.
public:
  ProgressBar(llvm::raw_ostream &OS, llvm::StringRef Header, bool ETA=true)
    : OS(OS), Header(Header), ShowETA(ETA) {}

  /// Update the amount of progress.
  ///
  /// Causes the bar to be Visible if it wasn't already.
  ///
  /// \param Percent A value in the range [0.0f, 1.0f] indicating the
  ///                amount of progress to display.
  /// \param Msg     The message to display underneath the bar.
  void update(float Percent, llvm::StringRef Msg);

  /// Remove the progress bar from the terminal.
  void clear();

protected:

  /// Special case for when the ProgressBar itself is under test
  void markUnderTest() { UnderTest = true; }

private:

  /// The stream being written to.
  llvm::raw_ostream &OS;

  /// Header text to print centered at the top of the bar.
  std::string Header;

  /// Whether to make a guess at estimated completion.
  bool ShowETA;

  /// If `ShowETA && Visible`, contains the time when the progress bar was
  /// first displayed.
  std::chrono::time_point<std::chrono::system_clock> Start;

  /// Contains the time when the progress bar was last displayed. Used to
  /// rate-limit the refresh, to avoid flickering.
  llvm::Optional<std::chrono::time_point<std::chrono::system_clock>> LastUpdate;

  /// Is the progress bar being displayed?
  bool Visible = false;

  /// Total number of characters written out on the last line.
  unsigned Width = 0;

  /// For testing purposes
  bool UnderTest = false;
};

} // namespace llvm

#endif

