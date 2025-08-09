# Task Manager App (TaskMaster Pro)

A simple yet professional **TaskMaster Pro** built with Flutter as part of a developer assessment.
It showcases clean architecture, state management, API integration, responsive UI, and theme switching (Light/Dark mode).

---

## Features

### **Authentication**

* Login with Email and Password
* No backend – login succeeds only if:

  ```
  Email: test@test.com
  Password: 123456
  ```
* Form validation included

### **Home Screen (Task List)**

* Fetch tasks from [JSONPlaceholder](https://jsonplaceholder.typicode.com/todos)
* Pull-to-refresh functionality
* Tasks sorted with **Pending** on top and **Completed** below
* Clean, responsive design

### **Task Details**

* Mark tasks as **Complete** / **Incomplete**

### **Add New Task**

* Form with: **Title**
* Local save (SharedPreferences)

### **Dark Mode Support**

* Toggle between **Light** and **Dark** themes
* System theme detection

---

## Technical Details

* **Flutter**: 3.5.4
* **State Management**: **Provider**

  * Chosen for its simplicity, readability, and ease of integration for small to medium apps.
* **HTTP Client**: `http`
* **Architecture**: Modular folder structure for separation of concerns
* **Responsive UI**: Uses `flutter_screenutil`

---

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/dimpal001/taskmaster_pro.git
   cd taskmaster_pro
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **For iOS** – If you face CocoaPods errors, see the [CocoaPods Fix Guide](#cocoapods-fix-guide) below.
