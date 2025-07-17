# hwpldemo

A simple Flutter Todo application with local persistence and pagination.

## 📦 Project Overview

This Flutter project demonstrates:
- Local todo management using **Hive**
- State management with **Provider**
- Pagination (20 items per page)
- Local-only todo creation and deletion

---

## 🚀 Getting Started

Ensure you are using the following Flutter version to run the project:

Flutter 3.32.4 • channel stable
Dart 3.8.1 • DevTools 2.45.1

To run the app:
```bash
flutter pub get
flutter run

lib/
├── main.dart                    # App entry point
│
├── screen/
│   └── dashboard/
│       ├── logic/
│       │   ├── logic.dart              # Provider logic (e.g., PostProvider)
│       │   └── todo_repository.dart    # Handles API & local data
│       │
│       └── model/
│           └── todo_list_screen.dart  # Main UI for displaying todos
│
├── theme/
│   ├── constants.dart           # Common constants like colors, sizes
│   └── theme.dart              # App theming configuration



💡 Features
✅ Paginated list of todos (20 per page)

✅ Add new todos locally (stored using Hive)

✅ Delete todos from local Hive database

✅ Toggle completion status

✅ Retains state across app restarts

✅ Provider-based state management



📦 Dependencies Used
provider

hive

hive_flutter