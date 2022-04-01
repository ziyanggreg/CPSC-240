//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//Author information
//  Author name: Greg Zhang
//  Author email: ziyangz@csu.fullerton.edu
//
//Program information
//  Program name: Amazing Triangles
//  Programming languages: One module in C++, one module in X86
//  Date program began: 2022 Feb 15
//  Date of last update: 2022 Mar 31
//  Date of reorganization of comments: 2022 Mar 31
//  Files in this program: triangle.asm, driver.cpp, r.sh
//  Status: Finished.
//
//Purpose
//  This file is the driver file that calls the triangle_area function, which will look for
//  the area of a triangle after the user inputs two sides and an angle.
//
//This file
//   File name: driver.cpp
//   Language: C++
//   Compile: g++ -g -c -m64 -std=c++17 -fno-pie -no-pie -o driver.o driver.cpp
//   Link: g++ -g -m64 -std=c++17 -fno-pie -no-pie -o triangle.out triangle.o driver.o
//
//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
//
//
//===== Begin code area ===========================================================================================================
#include <cstdio>

extern "C" double triangle_area();

int main()
{
    printf("Welcome to Amazing Triangles programmed by Greg Zhang on 3/8/2022\n");
    double area = triangle_area();
    printf("\nThe driver received this number %lf and will simply keep it\n", area);
    printf("An integer zero will now be sent to the operating system. Have a good day. Bye\n");
    return 0;
}
