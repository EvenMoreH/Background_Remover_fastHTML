# Use an official Python runtime as the base image
FROM python:3.11-slim

# print logs immediately, and store rembg models in a fixed location
ENV PYTHONUNBUFFERED=1 \
    U2NET_HOME=/models

# Set working directory in the container
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Download the models at build time, so the first upload in a new container isn't slow
# NOTE: keep in sync with MODELS in app/main.py
RUN python -c "from rembg import new_session; [new_session(m) for m in ('isnet-general-use', 'birefnet-general')]"

# Copy the rest of the application
COPY app/ .

EXPOSE 5005

# Command to run the application
CMD ["python", "main.py"]
