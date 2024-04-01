//===----- unittests/Support/Progress.cpp - Progress Bar tests ------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Progress.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Config/config.h"

#include "gtest/gtest.h"
#include <cstdlib>
#include <string>

using namespace llvm;

namespace {

struct TestOutput {
  TestOutput() : TOS(Output) {}
  std::string Output;
  raw_string_ostream TOS;
};

class ProgressBarTest
  : public ::testing::Test,
    // Gross multiple inheritance so we can guarantee that OS is constructed
    // before the ProgressBar itself.
    public TestOutput,
    public ProgressBar {
protected:
  ProgressBarTest()
    : ::testing::Test(), ProgressBar(TOS, "Header", false) {}
};

TEST_F(ProgressBarTest, Update) {
  // Force 60 columns, among other things.
  markUnderTest();

  update(0.25, "Quarter");

  // Don't use EXPECT_EQ because, if it fails, LIT will struggle when all these
  // ANSI control characters get printed out.
  EXPECT_TRUE(TOS.str() ==
              "\x1B[1D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h"
              "                           Header\n"
              "  25% [============---------------------------------------]\n"
              "Quarter\x1B[?25l");

  update(0.75, "Three Quarter");

  EXPECT_TRUE(TOS.str() ==
              "\x1B[1D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h"
              "                           Header\n"
              "  25% [============---------------------------------------]\n"
              "Quarter\x1B[?25l\x1B[8D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h"
              "                           Header\n"
              "  75% [======================================-------------]\n"
              "Three Quarter\x1B[?25l");

  clear();

  EXPECT_TRUE(TOS.str() ==
              "\x1B[1D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h"
              "                           Header\n"
              "  25% [============---------------------------------------]\n"
              "Quarter\x1B[?25l\x1B[8D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h"
              "                           Header\n"
              "  75% [======================================-------------]\n"
              "Three Quarter\x1B[?25l\x1B[14D\x1B[2K\x1B[1A\x1B[2K\x1B[1A\x1B[2K\x1B[?25h");

}

} // end anon namespace
