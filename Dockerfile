# # Use an official Python 3.10 image from Docker Hub
# FROM python:3.10-slim-buster

# # Set the working directory
# WORKDIR /app

# # Copy your application code
# COPY . /app

# # Install the dependencies
# RUN pip install -r requirements.txt

# # Expose the port FastAPI will run on
# EXPOSE 5000

# # Command to run the FastAPI app
# CMD ["python3", "app.py"]
# # CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]



# Stage 1: Build stage
FROM python:3.10-slim-bookworm AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# FIX: Copy all application files (including setup.py) before running pip
COPY . /app

# Install dependencies and your local package into a local directory
RUN pip install --no-cache-dir --user -r requirements.txt


# Stage 2: Runtime stage
FROM python:3.10-slim-bookworm AS runner

WORKDIR /app

# Copy the installed dependencies and package from the builder stage
COPY --from=builder /root/.local /root/.local
COPY . /app

# Ensure the local pip binaries and installed packages are in the PATH
ENV PATH=/root/.local/bin:$PATH

EXPOSE 5000

CMD ["python3", "app.py"]
