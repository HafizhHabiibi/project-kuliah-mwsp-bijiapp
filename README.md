# BijiApp – Backend Coffee Shop

BijiApp adalah project backend untuk aplikasi **Coffee Shop** yang dibuat sebagai **Tugas Mata Kuliah Mobile Web Service Praktik**.  
Backend ini berfungsi sebagai REST API yang digunakan oleh aplikasi mobile Flutter.

## Teknologi
- Laravel 12
- Laravel Sanctum (Authentication)
- MySQL
- Flutter (Frontend)

## Cara Menjalankan Backend

1. Clone repository
   git clone https://github.com/HafizhHabiibi/project-kuliah-mwsp-bijiapp.git
   cd project-kuliah-mwsp-bijiapp

2. Install dependency
   composer install

3. Buat file environment
   cp .env.example .env

4. Generate application key
   php artisan key:generate

5. Konfigurasi database pada file .env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=bijiapp
   DB_USERNAME=root
   DB_PASSWORD=

6. Jalankan migrasi database
   php artisan migrate

7. Buat storage link
   php artisan storage:link

8. Jalankan server
   php artisan serve

Backend akan berjalan di http://127.0.0.1:8000

## Catatan
- Pastikan MySQL sudah berjalan
- Database bijiapp sudah dibuat
- Backend harus dijalankan sebelum aplikasi Flutter
