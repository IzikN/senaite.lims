# Use Python 3.10 slim base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install dependencies and pin setuptools to a compatible version
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install -U pip 'setuptools<70' zc.buildout && \
    buildout bootstrap && \
    buildout
