#include "euidProject3_header.h"

// Original function to find minimum in a float array
float findMinimum(float* arr, int size) {
    float min = arr[0];
    for (int i = 1; i < size; ++i) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}

// Overloaded function to find minimum in an int array
int findMinimum(int* arr, int size) {
    int min = arr[0];
    for (int i = 1; i < size; ++i) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}
