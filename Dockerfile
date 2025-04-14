# Sử dụng image base chính thức của Nginx
FROM nginx:stable-alpine

# Sao chép các tệp build của Flutter web vào thư mục public của Nginx
COPY build/web /usr/share/nginx/html

# Cấu hình Nginx để phục vụ ứng dụng Flutter
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 