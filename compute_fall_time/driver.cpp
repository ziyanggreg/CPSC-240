//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Greg Zhang
//  Author email: ziyangz@csu.fullerton.edu
//
//Program information
//  Program name: Compute Free Fall Time
//  Programming languages: One module in C++, one module in X86
//  Date program began: 2022 Mar 28
//  Date of last update: 2022 Mar 31
//  Date of reorganization of comments: 2022 Mar 31
//  Files in this program: compute_fall_time.asm, driver.cpp, r.sh
//  Status: Finished.
//
//Purpose
//  This file is the driver file that calls the fall_time function, which will look for
//  the amount of time it take for an object to free fall from a user inputted height and display it for the user.
//
//This file
//   File name: driver.cpp
//   Language: C++
//   Compile: g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp
//   Link: g++ -g -m64 -std=c++17 -fno-pie -no-pie -o compute_fall_time.out compute_fall_time.o driver.o
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================
#include <cstdio>

extern "C" double fall_time();

int main()
{
  printf("Welcome to Gravitational Attraction maintained by Greg Zhang.\n This program was last updated on March 30, 2022.\n");
  double time = fall_time();
  printf("\nThe main driver received this number %lf and will simply keep it\n", time);
  printf("An integer zero will now be sent to the operating system. Have a good day. Bye\n");
  return 0;
}
