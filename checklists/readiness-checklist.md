# Readiness Checklist – Lab 05

Đây là danh sách kiểm tra (checklist) để đảm bảo stack Docker Compose của bạn đã sẵn sàng trước khi gửi bài. Hãy tick vào mỗi mục sau khi hoàn thành.

- [x] **Database ready:** container DB đã chạy và phản hồi `pg_isready`. Kiểm tra bằng `docker exec -it fit4110-db-lab05 pg_isready -U lab05 -d iotdb`.
- [x] **AI service ready:** container AI service trả về `200` cho endpoint `/health` và `/predict` hoạt động.
- [x] **API ready:** container API trả `200` cho `/health`, có thể tạo/lấy readings khi token hợp lệ, kết nối được DB và AI qua mạng nội bộ.
- [x] **Environment variables:** `.env` đã được thiết lập đúng (APP_PORT, POSTGRES_USER, AUTH_TOKEN, IMAGE_TAG,…). Không sử dụng secret thật; lưu secret vào `.env` cục bộ, commit `.env.example`.
- [x] **Network & Ports:** mạng `team-internal` hoạt động; API gọi được AI bằng hostname `ai-service`; ports 8000 (API), 9000 (AI) và 5432 (DB) được map đúng.
- [x] **Image tags:** image đã build với tag `v0.1.0-team-iot` theo quy ước lab. Push lên registry (ghcr.io hoặc Docker Hub) trước khi nộp bài.

Ghi chú thêm những vấn đề gặp phải hoặc điều chỉnh tại đây:

```
- Stack gồm 3 service: api, db (PostgreSQL), ai-service (mock FastAPI).
- API lưu readings vào PostgreSQL và gọi AI service qua http://ai-service:9000/predict.
- Newman collection: postman/collections/FIT4110_lab05_iot_compose.postman_collection.json
```
