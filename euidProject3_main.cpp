#include "euidProject3_header.h"
#include <iostream>

int main() {
    int choice;

    do {
        std::cout << "1. Add Student\n";
        std::cout << "2. Remove Student\n";
        std::cout << "3. Display Students\n";
        std::cout << "4. Search for a Student\n";
        std::cout << "5. Export Results\n";
        std::cout << "6. Quit\n";
        std::cout << "Enter your choice: ";
        std::cin >> choice;

        switch (choice) {
            case Add:
                add_Student();
                break;
            case Remove: {
                int studentID;
                std::cout << "Enter Student ID to remove: ";
                std::cin >> studentID;
                remove_Student(studentID);
                break;
            }
            case Display:
                display();
                break;
            case Search: {
                int studentID;
                std::cout << "Enter Student ID to search: ";
                std::cin >> studentID;
                search(studentID);
                break;
            }
            case Results:
                exportResults();
                break;
            case Quit:
                std::cout << "Exiting program...\n";
                break;
            default:
                std::cout << "Invalid choice, please try again.\n";
        }
    } while (choice != Quit);

    return 0;
}
