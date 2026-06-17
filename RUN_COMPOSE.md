# RUN_COMPOSE.md – Hướng dẫn chạy Lab 05

Tài liệu này hướng dẫn người khác clone repo sạch và chạy lại stack Compose của Lab 05.

---

## 1. Clone repo

```bash
git clone <repo-url>
cd lab-5-PhamTheHoan10042005
```

---

## 2. Cài dependencies cho Newman/Prism/Spectral (tuỳ chọn)

```bash
npm install
```

---

## 3. Chuẩn bị môi trường

```bash
# Copy .env.example sang .env và chỉnh sửa nếu cần
cp .env.example .env

# Tạo mạng class-net nếu chưa có (Compose yêu cầu external network)
docker network inspect class-net >/dev/null 2>&1 || docker network create class-net
```

---

## 4. Build & chạy stack Docker Compose

```bash
docker compose up -d --build --wait
```

Hoặc dùng Makefile (tự tạo `.env` và `class-net`):

```bash
make compose-up
```

Lệnh trên sẽ tạo các container:

- `fit4110-db-lab05` (PostgreSQL, port 5432)
- `fit4110-ai-lab05` (AI service mock, port 9000)
- `fit4110-api-lab05` (API FastAPI, port 8000)

Theo dõi log:

```bash
docker compose logs -f
```

Sau vài giây, kiểm tra health của mỗi service:

```bash
# API (kèm trạng thái DB/AI nội bộ)
curl http://localhost:8000/health

# AI service
curl http://localhost:9000/health

# DB readiness
docker exec -it fit4110-db-lab05 pg_isready -U lab05 -d iotdb
```

Kiểm tra AI predict:

```bash
curl -X POST http://localhost:9000/predict
```

Tạo reading qua API (lưu vào PostgreSQL và gọi AI nội bộ):

```bash
curl -X POST http://localhost:8000/readings \
  -H "Authorization: Bearer local-dev-token" \
  -H "Content-Type: application/json" \
  -d '{"device_id":"ESP32-LAB-A01","metric":"temperature","value":31.5,"unit":"celsius","timestamp":"2026-05-13T08:30:00+07:00"}'
```

---

## 5. Chạy Newman test trên stack Compose

Đảm bảo stack đang chạy, sau đó:

```bash
npm run test:compose
```

Hoặc:

```bash
make test-compose
```

Report sinh tại:

```text
reports/newman-lab05-compose.xml
reports/newman-lab05-compose.html
```

---

## 6. Dừng stack

```bash
docker compose down
```

Xoá cả volume dữ liệu DB:

```bash
docker compose down -v
```

---

## 7. Lệnh nhanh

```bash
make compose-up
make compose-down
make logs
make health
make test-compose
```

---

## 8. Push image lên registry

```bash
docker tag fit4110/iot-ingestion:v0.1.0-team-iot ghcr.io/<username>/iot-ingestion:v0.1.0-team-iot
docker tag fit4110/ai-service:v0.1.0-team-iot ghcr.io/<username>/ai-service:v0.1.0-team-iot
docker push ghcr.io/<username>/iot-ingestion:v0.1.0-team-iot
docker push ghcr.io/<username>/ai-service:v0.1.0-team-iot
```

---

## 9. Mẹo gỡ lỗi

- `docker compose ps` – xem trạng thái container và health.
- Nếu lỗi `network class-net not found`, chạy `docker network create class-net`.
- Nếu API không start, kiểm tra DB/AI đã healthy: `docker compose logs db ai-service`.
- Nếu port bị chiếm, đổi `APP_PORT` hoặc `AI_PORT` trong `.env`.
