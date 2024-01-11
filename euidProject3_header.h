#ifndef EUIDPROJECT3_HEADER_H
#define EUIDPROJECT3_HEADER_H

#include <iostream> // for cout and cin
#include <fstream>  // for ifstream and ofstream
#include <string>   // for string class
#include <cstdlib>  // for exit function

using namespace std; // allows us to use std elements without the prefix

const int NUM_TESTS = 5;

enum MenuOption { Add = 1, Remove, Display, Search, Results, Quit };

struct Student {
    string name;       // no need for 'std::' prefix due to using directive above
    int studentID;
    int numTestsTaken;
    float* testScores;
    float averageScore;
};

// Function prototypes
void add_Student();
void remove_Student(int studentID);
void display();
void search(int studentID);
void exportResults();
int findMinimum(int* arr, int size);

#endif //EUIDPROJECT3_HEADER_H
