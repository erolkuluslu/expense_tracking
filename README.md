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

## Dependencies

The main dependencies used in this project include:

- **flutter_bloc**: For state management.
- **equatable**: To simplify equality comparisons.
- **intl**: For date and number formatting.

A full list of dependencies can be found in the `pubspec.yaml` file.


## Credits

This code was sourced from  [HeyFlutter․com YouTube channel](https://www.youtube.com/@HeyFlutter) and contributed by me with adding new functionalities.
