# 🎓 Student Management System

A full-stack **Student Management App** built with **Flutter** (Frontend) and **Django REST Framework** (Backend). This app helps manage student data, including their personal details, internship records, and project submissions. Admins can also post upcoming internship and placement opportunities.

---

## 📱 Features

### 👨‍🏫 For Students

- Register and login
- View and edit profile
- Add, view, edit, and delete:
  - Internship details (with certificate upload)
  - Projects

### 🧑‍💼 For Admins

- Manage student records
- Post upcoming **internship & placement opportunities**
- Edit/delete any student data

### 🌐 Backend API (Django REST Framework)

- CRUD APIs for students, internships, projects, and opportunities
- Media upload support for certificates

## 💠 Tech Stack

| Frontend       | Backend               |
| -------------- | --------------------- |
| Flutter 3.19.2 | Django REST Framework |
| Provider/Bloc  | Django ORM, SQLite    |
| REST API       |                       |

---

## 🚀 Getting Started

### Backend (Django)

```bash
cd backend/
python -m venv env
env\Scripts\activate  # on Windows
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Frontend (Flutter)

```bash
cd flutter_app/
flutter pub get
flutter run
```

---

## 🧪 API Endpoints

| Endpoint              | Description                  |
| --------------------- | ---------------------------- |
| `/api/students/`      | List & Create students       |
| `/api/students/<id>/` | Retrieve, Update, Delete     |
| `/api/internships/`   | Manage internships           |
| `/api/projects/`      | Manage student projects      |
| `/api/opportunities/` | Add/view admin opportunities |

---

## ✍️ Author

- **Krishna Suthar**\
  [LinkedIn](https://www.linkedin.com/in/krishana-suthar/) • [GitHub](https://github.com/123krissh)

---
