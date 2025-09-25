# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Copy project files
COPY setup.py .
COPY requirements.txt .
COPY simple_flask_app/ ./simple_flask_app
COPY tests/ ./tests

# Upgrade pip and install dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && pip install -e .

# Expose Flask port
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "-m", "simple_flask_app"]
