# 🍴 Restaurant Management App (Laravel + Flutter)

A full-stack restaurant management system built with **Laravel** (backend + web admin panel) and **Flutter** (customer mobile app).  
This project is designed to polish full-stack skills and follows **industry-standard architecture and GitFlow branching strategy**.

---

## 📌 Features
### Customer App (Flutter)
- Browse menu by categories & featured items
- Add to cart, checkout, and online payment
- Track order status in real time
- Manage profile, saved addresses, and order history
- Submit reviews and ratings

### Admin Panel (Laravel + Filament)
- Role-based access (admin, manager, staff, delivery)
- Manage categories, menu items, and promotions
- Handle customer orders (assign delivery, update status)
- Customer & review management
- Reports (sales, top items, repeat customers)
- Business settings (tax, delivery fee, working hours)

---

## 🏗 Tech Stack
- **Backend**: Laravel 10 (Sanctum, Spatie Roles, Filament/Livewire)
- **Frontend (Mobile)**: Flutter 3 (Riverpod/Bloc for state management)
- **Database**: MySQL
- **API**: REST (JSON)
- **Version Control**: GitFlow branching strategy

---

## ⚙️ Installation

### Laravel Backend
```bash
git clone https://github.com/Smeedsajjad/restaurant-management-laravel-flutter.git
cd restaurant-management-laravel-flutter/backend
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan serve