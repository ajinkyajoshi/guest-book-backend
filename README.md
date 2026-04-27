# Guest Book Backend (MySQL)

MySQL 8.0 database service for the Guestbook application with schema initialization and seed data.

## Tech Stack

- MySQL 8.0
- Docker

## Project Structure

```
guest-book-backend/
├── init.sql       # Schema creation + seed data
├── Dockerfile     # MySQL image with init script
└── README.md
```

## Database Schema

### Table: `guest_entries`

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | BIGINT | PK, AUTO_INCREMENT | Unique identifier |
| name | VARCHAR(100) | NOT NULL | Guest name |
| email | VARCHAR(150) | DEFAULT NULL | Optional email |
| message | VARCHAR(500) | NOT NULL | Guest message |
| mood | VARCHAR(10) | DEFAULT '😊' | Emoji mood |
| likes | INT | DEFAULT 0 | Like count |
| pinned | BOOLEAN | DEFAULT FALSE | Pin to top flag |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE | Last update time |

## Seed Data

The `init.sql` script inserts 3 sample entries on first startup:

| Name | Mood | Pinned | Likes |
|------|------|--------|-------|
| Admin | 👋 | Yes | 5 |
| Jane Doe | 😍 | No | 3 |
| John Smith | 🎉 | No | 1 |

> The init script only runs on first container startup (when the data volume is empty). Subsequent restarts preserve existing data.

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `MYSQL_ROOT_PASSWORD` | rootpass | Root user password |
| `MYSQL_DATABASE` | guestbook | Default database |
| `MYSQL_USER` | guestuser | Application user |
| `MYSQL_PASSWORD` | guestpass | Application user password |

> **Note**: For production, use Kubernetes Secrets or AWS Secrets Manager instead of hardcoded values.

## Run Locally

### With Docker

```bash
# Build image
docker build -t guestbook-db .

# Run container
docker run -d --name guestbook-db \
  -p 3306:3306 \
  -v mysql-data:/var/lib/mysql \
  guestbook-db
```

### Connect to MySQL

```bash
# Via Docker exec
docker exec -it guestbook-db mysql -u guestuser -pguestpass guestbook

# Via MySQL client
mysql -h 127.0.0.1 -P 3306 -u guestuser -pguestpass guestbook
```

### Useful Queries

```sql
-- View all entries
SELECT * FROM guest_entries ORDER BY pinned DESC, created_at DESC;

-- Count today's entries
SELECT COUNT(*) FROM guest_entries WHERE DATE(created_at) = CURDATE();

-- Total likes
SELECT SUM(likes) FROM guest_entries;

-- Search entries
SELECT * FROM guest_entries WHERE name LIKE '%keyword%' OR message LIKE '%keyword%';
```

## Kubernetes Deployment

Deployed as a **StatefulSet** in the `guestbook-db` namespace with a 10Gi EBS (gp2) PersistentVolumeClaim.

```bash
kubectl apply -f ../k8s/db/
```

### K8s Resources
- **StatefulSet** — 1 replica with persistent storage
- **Headless Service** — DNS: `mysql.guestbook-db.svc.cluster.local`
- **PVC** — 10Gi gp2 EBS volume
- **Secret** — Database credentials
- **ConfigMap** — init.sql script
- **NetworkPolicy** — Only allows ingress from `guestbook-api` namespace on port 3306

## Data Persistence

| Environment | Storage |
|-------------|---------|
| Docker | Named volume `mysql-data` |
| Docker Compose | Named volume `mysql-data` |
| Kubernetes | PVC with `gp2` StorageClass (EBS) |

## Backup & Restore

```bash
# Backup
docker exec guestbook-db mysqldump -u root -prootpass guestbook > backup.sql

# Restore
docker exec -i guestbook-db mysql -u root -prootpass guestbook < backup.sql
```
