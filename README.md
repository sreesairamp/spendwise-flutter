# SpendWise 💳

**SpendWise** is a clean, modern, and responsive Flutter mobile application designed for personal expense tracking. Built for a Flutter Mobile Intern application submission, it demonstrates modular architecture, REST API integration, local data persistence, and Material 3 UI design patterns.

---

## 📱 Features & Screens

### 1. 🏠 Home Screen
- **Expense Overview**: Live summary card displaying total expenses ($) and total transaction count.
- **REST API Integration**: Automatically fetches sample transactions from JSONPlaceholder API on launch.
- **API State Handling**: Full loading (`CircularProgressIndicator`) and error handling with retry capability.
- **Recent Activity**: Quick list view of recent expenses.
- **Quick Action**: Direct navigation button to record new expenses.

### 2. 📋 Transactions Screen
- **Complete Expense List**: Built with efficient `ListView.builder`.
- **Real-Time Search**: Filter expenses by merchant name instantly.
- **Category Filter**: Filter expenses by categories (*Food, Shopping, Bills, Transport, Entertainment, Other*).
- **Payment Status Toggle**: Mark expenses as Paid or Pending.
- **Delete Expense**: Delete transactions with confirmation modal dialogs.

### 3. ➕ Add Expense Screen
- **Form Fields**: Merchant Name, Amount ($), Category Dropdown, and Date Picker.
- **Form Validation**: Strict validation for non-empty merchant name and positive decimal amount.
- **Payment Toggle**: Option to record transaction as completed/paid on creation.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK >=3.0.0)
- **Design System**: Material 3 (`useMaterial3: true`)
- **State & Storage**:
  - Local Persistence: [`shared_preferences`](https://pub.dev/packages/shared_preferences)
  - Async Programming: `Future`, `async/await`
- **Networking**: [`http`](https://pub.dev/packages/http) package connecting to [JSONPlaceholder API](https://jsonplaceholder.typicode.com/)
- **Formatting**: [`intl`](https://pub.dev/packages/intl) for date formatting

---

## 🌐 REST API Usage

- Endpoint: `https://jsonplaceholder.typicode.com/posts?_limit=5`
- Service File: [`lib/services/api_service.dart`](lib/services/api_service.dart)
- Functionality: Fetches sample data asynchronously and transforms JSON payloads into `Expense` domain models. Gracefully catches HTTP errors or network timeouts.

---

## 💾 Local Storage

- Service File: [`lib/services/expense_service.dart`](lib/services/expense_service.dart)
- Functionality: Serializes user-created `Expense` objects into JSON arrays and persists them locally via `SharedPreferences`. Automatically reloads saved data when the application re-opens.

---

## 📁 Project Architecture

```
lib/
├── models/
│   └── expense.dart           # Expense data model & JSON converters
├── services/
│   ├── api_service.dart       # REST API service (JSONPlaceholder)
│   └── expense_service.dart   # Local storage service (SharedPreferences)
├── screens/
│   ├── main_screen.dart       # Bottom navigation controller & root state
│   ├── home_screen.dart       # Home tab (summary & recent expenses)
│   ├── transactions_screen.dart # Transactions tab (search, filter, list)
│   └── add_expense_screen.dart  # Add expense form tab with validation
├── widgets/
│   ├── summary_card.dart      # Total summary card widget
│   ├── expense_card.dart      # Transaction item list tile
│   ├── error_view.dart        # API error state & retry widget
│   └── empty_state.dart       # Empty list & no search results placeholder
└── main.dart                  # App entry point & Material 3 theme configuration
```

---

## 🚀 How to Run

1. **Prerequisites**: Ensure Flutter SDK (>=3.0.0) and Dart are installed on your environment.

2. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/spendwise.git
   cd spendwise
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run static analysis**:
   ```bash
   flutter analyze
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```
