# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory inside the container
WORKDIR /app

# Copy requirements and source code
COPY setup.py .
COPY simple_flask_app/ ./simple_flask_app/
COPY tests/ ./tests/

# Install dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -e .

# Expose the Flask port
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "-m", "simple_flask_app.app"]
