# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Create a virtual environment and install dependencies
RUN python -m venv venv \
    && . venv/bin/activate \
    && pip install --no-cache-dir 'setuptools<58.0.0' pip zc.buildout \
    && buildout bootstrap \
    && buildout

# Set the default command
CMD ["/bin/bash"]
