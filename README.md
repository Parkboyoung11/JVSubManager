# README
Hướng dẫn cài đặt:

* Cài đặt ruby và rails theo hướng dẫn:
  https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rvm-on-ubuntu-16-04

* Di chuyển tới thư mực Project

* 1. Đổi tên file config/database.example thành config/database.yml. Sau đó, chỉnh sửa username và password của mysql trong file đó

* 2. Chạy các lệnh sau bằng terminal
    bundle install
    rails db:create
    rails db:migrate
    rails db:seed
    rails s

* 3. Truy cập localhost:3000 trên trình duyệt và dăng nhập với tài khoản sau
  username: username
  password: password
