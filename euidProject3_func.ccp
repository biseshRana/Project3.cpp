#include "euidProject3_header.h"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <vector>
#include <algorithm>
#include <string>
#include <numeric>

// Forward declarations
int getNumber();
int findMinimum(int* arr, int size);

void add_Student() {
    Student newStudent;
    string lastName, firstName;

    // Get last name
    cout << "Enter last name of the student: ";
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    getline(cin, lastName);

    // Get first name
    cout << "Enter first name of the student: ";
    getline(cin, firstName);

    // Concatenate last name and first name
    newStudent.name = lastName + "," + firstName;

    // Get student ID
    cout << "Enter student ID: ";
    cin >> newStudent.studentID;

    cout << "How many tests did this student take? ";
    cin >> newStudent.numTestsTaken;

    newStudent.testScores = new float[newStudent.numTestsTaken];

    for (int i = 0; i < newStudent.numTestsTaken; ++i) {
        cout << "Enter score #" << i + 1 << ": ";
        cin >> newStudent.testScores[i];
    }

    // Calculate the average score
    float sum = 0;
    for (int i = 0; i < newStudent.numTestsTaken; ++i) {
        sum += newStudent.testScores[i];
    }
    newStudent.averageScore = sum / newStudent.numTestsTaken;

    // Open the file for appending
    ofstream outFile("student.dat", ios::app);
    if (!outFile) {
        cerr << "Error opening file for writing." << endl;
        delete[] newStudent.testScores;
        return;
    }

    // Add a newline character before writing new student data
    outFile << '\n';

    // Write the student data to the file including the number of tests taken
    // Write the student data to the file including the number of tests taken
	outFile << newStudent.name << "," << newStudent.studentID << "," << newStudent.numTestsTaken << ",";
	for (int i = 0; i < newStudent.numTestsTaken; ++i) {
    outFile << newStudent.testScores[i];
    outFile << ","; // Always add a comma after each score
	}
	outFile << endl; // Add a newline character at the end
    outFile.flush(); // Explicitly flush the stream

    outFile.close();

    // Clean up dynamically allocated memory
    delete[] newStudent.testScores;

    cout << "Student data added successfully to student.dat." << endl;
}

void remove_Student(int studentID) {
    ifstream fin("student.dat");
    ofstream fout("temp.dat");
    if (!fin) {
        cerr << "Error opening file for reading." << endl;
        return;
    }

    string line;
    bool found = false;

    while (getline(fin, line)) {
        istringstream iss(line);
        string lastName, firstName, idStr;
        int id;

        // Read the last name, first name, and ID
        if (getline(iss, lastName, ',') && getline(iss, firstName, ',') && getline(iss, idStr, ',')) {
            // Trim potential white space around the ID
            idStr.erase(0, idStr.find_first_not_of(" \n\r\t\f\v"));
            idStr.erase(idStr.find_last_not_of(" \n\r\t\f\v") + 1);

            try {
                id = stoi(idStr);
            } catch (const invalid_argument&) {
                cerr << "Invalid ID format: " << idStr << endl;
                continue; // Skip this line and continue with the next
            }

            // If the ID matches the studentID, set found to true and skip writing the line
            if (id == studentID) {
                found = true;
                continue; // Do not write this line to the temp file
            }
        }
        fout << line << endl; // Write the line to the temporary file
    }

    fin.close();
    fout.close();

    if (found) {
        // Remove the original file and rename the temp file to student.dat
        remove("student.dat");
        rename("temp.dat", "student.dat");
    } else {
        // If student not found, remove the temp file and notify the user
        remove("temp.dat");
        cout << "Student ID " << studentID << " not found." << endl;
    }
}

void display() {
    std::ifstream fin("student.dat");
    if (!fin) {
        std::cerr << "Error opening file for reading.\n";
        return;
    }

    std::string line;
    while (getline(fin, line)) {
        std::istringstream iss(line);
        std::string lastName, firstName, idString, scoreString;

        // Read last name, first name, and ID separately
        std::getline(iss, lastName, ',');
        std::getline(iss, firstName, ',');
        std::getline(iss, idString, ',');

        // Trim potential white space around the ID
        idString.erase(0, idString.find_first_not_of(" \n\r\t\f\v"));
        idString.erase(idString.find_last_not_of(" \n\r\t\f\v") + 1);

        // Output the name and ID
        std::cout << lastName << "," << firstName << " " << idString;

        // Extract the remaining part of the line containing scores
        std::getline(iss, scoreString);

        // Replace commas with spaces in scoreString for correct formatting
        std::replace(scoreString.begin(), scoreString.end(), ',', ' ');

        // Output the scores
        std::cout << scoreString << std::endl;
    }
    fin.close();
}

void search(int searchID) {
    ifstream fin("student.dat");
    if (!fin) {
        cerr << "Error opening file for reading." << endl;
        return;
    }

    string line;
    bool found = false;

    while (getline(fin, line)) {
        istringstream iss(line);

        string lastName, firstName, idStr;
        int id;

        // Read the last name, first name, and ID
        if (getline(iss, lastName, ',') && getline(iss, firstName, ',') && getline(iss, idStr, ',')) {
            // Trim potential white space around the ID
            idStr.erase(0, idStr.find_first_not_of(" \n\r\t\f\v"));
            idStr.erase(idStr.find_last_not_of(" \n\r\t\f\v") + 1);

            try {
                id = stoi(idStr);
            } catch (const invalid_argument&) {
                cerr << "Invalid ID format: " << idStr << endl;
                continue; // Skip this line and continue with the next
            }

            // If the ID matches the searchID, print the student's information
            if (id == searchID) {
                found = true;

                cout << left << setw(30) << lastName + ", " + firstName // Student name
                     << setw(15) << id; // Student ID

                // Extract and print the grades
                string grade;
                while (getline(iss, grade, ',')) {
                    cout << setw(5) << grade;
                }
                cout << endl;
                break; // Student found, exit the loop
            }
        }
    }

    if (!found) {
        cout << "Student ID " << searchID << " not found." << endl;
    }

    fin.close();
}

void exportResults() {
    int numStudents = getNumber();
    std::ifstream fin("student.dat");
    std::ofstream fout("averages.dat");
    if (!fin || !fout) {
        std::cerr << "Error opening files.\n";
        return;
    }

    std::string line;
    while (getline(fin, line)) {
        std::istringstream iss(line);
        std::string lastName, firstName, idStr;
        int studentID;
        std::vector<int> scores;
        std::string scoreStr;

        // Read the last name, first name, and ID
        if (getline(iss, lastName, ',') && getline(iss, firstName, ',') && getline(iss, idStr, ',')) {
            // Trim potential white space around the ID
            idStr.erase(0, idStr.find_first_not_of(" \n\r\t\f\v"));
            idStr.erase(idStr.find_last_not_of(" \n\r\t\f\v") + 1);

            try {
                studentID = stoi(idStr);
            } catch (const std::invalid_argument&) {
                std::cerr << "Invalid ID format: " << idStr << std::endl;
                continue; // Skip this line and continue with the next
            }

            // Extract and store the scores
            while (getline(iss, scoreStr, ',')) {
                scoreStr.erase(0, scoreStr.find_first_not_of(" \n\r\t\f\v"));
                scoreStr.erase(scoreStr.find_last_not_of(" \n\r\t\f\v") + 1);
                try {
                    scores.push_back(stoi(scoreStr));
                } catch (const std::invalid_argument&) {
                    std::cerr << "Invalid score format: " << scoreStr << std::endl;
                    continue; // Skip this score and continue with the next
                }
            }

            // Convert the scores to int array for findMinimum function
            int* scoreArray = new int[scores.size()];
            std::copy(scores.begin(), scores.end(), scoreArray);
            
            // Find minimum score and calculate average
            int minScore = findMinimum(scoreArray, scores.size());
            float sum = std::accumulate(scores.begin(), scores.end(), 0) - minScore;
            float average = scores.size() > 1 ? sum / (scores.size() - 1) : sum;

            fout << studentID << " " << std::fixed << std::setprecision(1) << average << std::endl;

            delete[] scoreArray;
        }
    }

    fin.close();
    fout.close();
}
