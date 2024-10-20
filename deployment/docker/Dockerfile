FROM python:3.12.4

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files
COPY . .

# Set environment variables
ENV PYTHONPATH=/app

# Run the application
CMD ["uvicorn", "commands.server.main:app", "--host", "0.0.0.0", "--port", "8000"]
