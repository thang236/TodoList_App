# TodoApp

## Introduction
TodoApp is a task management application built for iOS, allowing users to create, manage, and track their daily tasks. It supports features like task creation, date selection, task sorting, and searching through tasks with ease. The app is structured following the MVC architecture to ensure scalability and maintainability.

## Technology Used
- **Swift**: Primary language for the app development.
- **UIKit**: For designing and managing the user interface.
- **MVC Design Pattern**: To structure the app for better code organization and scalability.
- **Cocoapods**: For managing external libraries and dependencies.

## Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/thang236/TodoList_App.git
    ```

3. Install dependencies using Cocoapods:
   Install the pods for the project:
      ```bash
      pod install
      ```

4. Open the `.xcworkspace` file:
    ```bash
    open TodoApp.xcworkspace
    ```

5. Run the project on a simulator or a physical device:
    - Select your target device and click the "Run" button in Xcode.

## Features
- **Authentication**:
  - **Login**: Users can log in to access their tasks.
  - **Register**: New users can sign up to create an account.
  - **Change Password**: Users can change their passwords.
  - **Edit Profile**: Users can update their personal information.
  
- **Task Management**:
  - **Create tasks**: Add new tasks with custom titles and descriptions.
  - **Edit tasks**: Modify existing tasks as needed.
  - **Delete tasks**: Remove tasks once completed or no longer needed.
  - **Date selection**: Choose due dates for tasks using a date picker.
  - **Task search**: Search tasks using a custom search bar for easy access.
  - **Task sorting**: Automatically sort tasks by importance.
  - **Task filtering**: Filter tasks by date to show only relevant tasks.

- **UI/UX**:
  - **Dark/Light mode support**: Switch between dark and light themes.
