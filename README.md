# Vehicle-Insurance
This project demonstrates an end-to-end MLOps pipeline for vehicle insurance data, covering ingestion from MongoDB Atlas, feature engineering, and model evaluation to deployment on AWS EC2. It features automated workflows using Docker and GitHub Actions, incorporating cloud-based storage via Amazon S3 and rigorous data validation.

[Project Report](https://dhavalantala.github.io/VehicleIsurance/)

# 🚗 Vehicle Insurance MLOps Pipeline

[![Python 3.10](https://img.shields.io/badge/Python-3.10-blue?logo=python&logoColor=white)](https://www.python.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-green?logo=mongodb&logoColor=white)](https://www.mongodb.com/cloud/atlas)
[![AWS](https://img.shields.io/badge/AWS-S3%20%7C%20EC2%20%7C%20ECR-orange?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-blue?logo=docker&logoColor=white)](https://www.docker.com/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-black?logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A production-grade, end-to-end MLOps pipeline for vehicle insurance risk prediction — covering data ingestion from MongoDB Atlas, multi-stage validation and transformation, model training with automated evaluation, S3-backed model registry, and a fully containerized Flask API deployed on AWS EC2 via GitHub Actions CI/CD.

---

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Local Setup](#local-setup)
  - [Environment Variables](#environment-variables)
- [Pipeline Stages](#-pipeline-stages)
- [AWS Infrastructure](#-aws-infrastructure)
- [CI/CD Workflow](#-cicd-workflow)
- [API Reference](#-api-reference)
- [Contributing](#-contributing)

---

## 🏗 Architecture Overview

```
MongoDB Atlas (Raw Data)
        │
        ▼
┌──────────────────────────────────────────────────┐
│               ML Training Pipeline                │
│                                                  │
│  Data Ingestion → Validation → Transformation    │
│          → Model Training → Evaluation           │
└──────────────────────────────────────────────────┘
        │                          │
        ▼                          ▼
  Artifacts (local)         AWS S3 Model Registry
                                   │
                                   ▼
                         ┌─────────────────┐
                         │  Flask REST API  │
                         │   (Prediction)   │
                         └─────────────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    ▼                             ▼
             Docker Image                  AWS EC2 Host
             (AWS ECR)              (Self-hosted GH Runner)
                    │                             │
                    └────── GitHub Actions ───────┘
                              CI/CD Pipeline
```

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.10 |
| Data Store | MongoDB Atlas (M0 Free Tier) |
| Feature Engineering | Pandas, Scikit-learn |
| Model Training | Scikit-learn Estimators |
| Model Registry | AWS S3 |
| API Serving | Flask |
| Containerization | Docker |
| Container Registry | AWS ECR |
| Compute | AWS EC2 |
| CI/CD | GitHub Actions |
| Package Management | pip, conda, pyproject.toml |

---

## 📁 Project Structure

```
vehicle-insurance-mlops/
│
├── src/
│   ├── components/
│   │   ├── data_ingestion.py          # MongoDB → local artifact
│   │   ├── data_validation.py         # Schema & distribution checks
│   │   ├── data_transformation.py     # Feature engineering, encoding
│   │   └── model_trainer.py           # Train, tune, serialize
│   │
│   ├── entity/
│   │   ├── config_entity.py           # Typed pipeline config dataclasses
│   │   ├── artifact_entity.py         # Typed artifact output dataclasses
│   │   ├── estimator.py               # Custom sklearn-compatible estimator
│   │   └── s3_estimator.py            # S3 push/pull wrapper
│   │
│   ├── pipeline/
│   │   ├── training_pipeline.py       # Orchestrates all training stages
│   │   └── prediction_pipeline.py     # Online inference pipeline
│   │
│   ├── aws_storage/                   # S3 read/write utilities
│   ├── configuration/
│   │   └── mongo_db_connections.py    # Singleton MongoDB client
│   ├── data_access/                   # Data fetch & transform from MongoDB
│   ├── exception.py                   # Centralized exception handling
│   ├── logger.py                      # Structured logging
│   └── utils/
│       └── main_utils.py              # Schema validation, serialization helpers
│
├── config/
│   └── schema.yaml                    # Expected column names, dtypes, ranges
│
├── notebook/
│   ├── EDA.ipynb                      # Exploratory Data Analysis
│   ├── Feature_Engg.ipynb             # Feature engineering experiments
│   └── mongoDB_demo.ipynb             # One-time data push to Atlas
│
├── static/                            # CSS, JS assets for web UI
├── templates/                         # Jinja2 HTML templates
├── app.py                             # Flask application entrypoint
├── demo.py                            # Local pipeline smoke test
├── template.py                        # Scaffold project structure
├── requirements.txt
├── setup.py
├── pyproject.toml
├── Dockerfile
├── .dockerignore
└── .github/
    └── workflows/
        └── main.yaml                  # CI/CD pipeline definition
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.10+
- [Anaconda / Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for local container testing)
- Active accounts: [MongoDB Atlas](https://www.mongodb.com/cloud/atlas), [AWS](https://aws.amazon.com/)

### Local Setup

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/vehicle-insurance-mlops.git
cd vehicle-insurance-mlops

# 2. Create and activate virtual environment
conda create -n vehicle python=3.10 -y
conda activate vehicle

# 3. Install dependencies (including local packages via pyproject.toml)
pip install -r requirements.txt

# 4. Verify local packages are importable
pip list | grep vehicle

# 5. Scaffold project directories (first-time only)
python template.py
```

### Environment Variables

The pipeline requires the following secrets at runtime. **Never commit these to source control.**

```bash
# MongoDB Atlas connection string
export MONGODB_URL="mongodb+srv://<username>:<password>@cluster0.xxxxx.mongodb.net"

# AWS credentials
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_DEFAULT_REGION="us-east-1"
```

> **Windows (PowerShell):**
> ```powershell
> $env:MONGODB_URL = "mongodb+srv://..."
> $env:AWS_ACCESS_KEY_ID = "..."
> ```
> Alternatively, set these permanently via System Properties → Environment Variables.

Once set, run the full training pipeline locally:

```bash
python demo.py
```

---

## 🔄 Pipeline Stages

Each stage produces a typed artifact consumed by the next, making the pipeline modular and independently testable.

### 1. Data Ingestion
- Connects to MongoDB Atlas via a singleton client (`mongo_db_connections.py`).
- Fetches raw collection documents and converts them to a Pandas DataFrame.
- Splits into train/test sets and persists locally as CSV artifacts.

### 2. Data Validation
- Validates column presence, data types, and value distributions against `config/schema.yaml`.
- Flags data drift using statistical checks.
- Halts the pipeline on critical schema violations — no silent failures.

### 3. Data Transformation
- Applies feature engineering defined and validated in the `Feature_Engg` notebook.
- Builds an sklearn `Pipeline` with imputation, encoding, and scaling.
- Serializes the fitted transformer as a `.pkl` artifact alongside the processed arrays.

### 4. Model Training
- Trains models defined in `estimator.py` on transformed data.
- Runs cross-validation and logs metrics (accuracy, F1, AUC) to the artifact store.
- Serializes the best-performing model.

### 5. Model Evaluation
- Loads the production model from S3 (if one exists).
- Compares challenger model against champion on a held-out test set.
- Promotes the challenger only if it meets the configured improvement threshold.

### 6. Model Pusher
- Pushes the accepted model to the S3 bucket (`my-model-mlopsproj`, `us-east-1`).
- Tags the artifact with metadata (timestamp, metrics, git SHA) for full lineage tracing.

---

## ☁️ AWS Infrastructure

### IAM Setup
1. Create a dedicated IAM user with `AdministratorAccess` (scope down to specific services for production).
2. Generate access keys and store them as GitHub Secrets — **never in code**.

### S3 Model Registry
```
Bucket: my-model-mlopsproj (us-east-1)
└── models/
    └── vehicle_insurance/
        └── <timestamp>/
            ├── model.pkl
            └── metadata.json
```

### EC2 Deployment
- Instance type: `t2.medium` (minimum recommended)
- OS: Ubuntu 22.04 LTS
- Inbound rule: open port `5080` (custom TCP) for the Flask API
- Acts as a **self-hosted GitHub Actions runner** for zero-cost deployments

### ECR
- Repository stores versioned Docker images built on each push to `main`.
- EC2 pulls and re-deploys the latest image automatically via the CI/CD workflow.

---

## ⚙️ CI/CD Workflow

The GitHub Actions pipeline (`.github/workflows/main.yaml`) triggers on every push to `main`:

```
Push to main
     │
     ▼
 Run Tests
     │
     ▼
 Docker Build
     │
     ▼
 Push to AWS ECR
     │
     ▼
 SSH into EC2 (self-hosted runner)
     │
     ▼
 Pull latest image from ECR
     │
     ▼
 docker run -p 5080:5080 (rolling restart)
```

**Required GitHub Secrets:**

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `AWS_DEFAULT_REGION` | e.g. `us-east-1` |
| `ECR_REPO` | Full ECR repository URI |

Once deployed, the app is accessible at:
```
http://<ec2-public-ip>:5080
```

---

## 📡 API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Web UI for manual prediction |
| `POST` | `/predict` | JSON payload → insurance risk prediction |
| `GET` | `/health` | Liveness check |

**Example prediction request:**
```bash
curl -X POST http://<host>:5000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "age": 35,
    "vehicle_age": 3,
    "annual_premium": 28000,
    "vintage": 180,
    ...
  }'
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome.

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Commit with conventional commits: `git commit -m "feat: add drift detection"`
4. Push and open a Pull Request against `main`

Please ensure all new pipeline components have a corresponding artifact entity and are covered by at least a smoke test in `demo.py`.

---

## 📄 License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
