
# Flutter Expense Tracker - BLoC State Management

This project is a simple yet powerful expense tracking application built using Flutter and the BLoC (Business Logic Component) state management pattern. The app allows users to add, edit, and delete expenses, as well as view a summary of their expenses over time.

## Features

- **Add Expenses**: Users can quickly add new expenses with a description, amount, and category.
- **Edit Expenses**: Modify existing expenses easily.
- **Delete Expenses**: Remove expenses that are no longer needed.
- **View Summary**: Get a quick overview of expenses categorized by date and category.
- **Responsive UI**: The app is designed to work seamlessly on both iOS and Android devices.

## Architecture

This project follows the BLoC (Business Logic Component) pattern for state management, which helps separate the business logic from the UI. The BLoC pattern is highly testable and reusable, making it a great choice for medium to large Flutter applications.

- **Presentation Layer**: Contains UI components like screens and widgets.
- **BLoC Layer**: Manages the state of the application and business logic.
- **Data Layer**: Handles data persistence and retrieval.

### Why BLoC?

BLoC is a predictable state management pattern that ensures all business logic is handled in one place, making the app easier to maintain and scale. It also enhances testability by isolating the business logic from the UI.

## Data Persistence with SharedPreferences

To ensure that user data, such as expenses, persists across app sessions, this application utilizes the `SharedPreferences` package. This allows the app to store and retrieve data locally on the device in a key-value format.

### How SharedPreferences is Used:

- **Initialization**: Upon launching the app, the stored expenses are retrieved from `SharedPreferences` and converted from JSON into a list of `Expense` objects. This initialization ensures that the app is populated with the user's previous expenses immediately.

- **Saving Expenses**: When a new expense is added or an existing one is edited, the list of expenses is updated in memory and then encoded into a JSON string. This JSON string is saved in `SharedPreferences` under a specific key, ensuring that the data is available the next time the app is opened.

- **Deleting Expenses**: Similar to saving, when an expense is deleted, the updated list of expenses is saved back into `SharedPreferences` after removing the specified expense.

Using `SharedPreferences` in this way ensures a lightweight and efficient method for persisting simple data structures like the list of expenses, making the app reliable even when the user closes and reopens it.

## Dependencies

The main dependencies used in this project include:

- **flutter_bloc**: For state management.
- **equatable**: To simplify equality comparisons.
- **intl**: For date and number formatting.
- **shared_preferences**: For storing and retrieving user data persistently.

A full list of dependencies can be found in the `pubspec.yaml` file.

