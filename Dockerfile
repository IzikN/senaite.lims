FROM python:3.9-slim

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    git \
    curl \
    libssl-dev \
    libffi-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Copy buildout and requirements files
COPY requirements.txt buildout.cfg ./

# Install buildout and Python dependencies
RUN pip install --upgrade pip setuptools<58.0.0 \
    && pip install -r requirements.txt \
    && pip install zc.buildout \
    && buildout bootstrap \
    && buildout

# Copy the rest of the project
COPY . .

EXPOSE 8080

CMD ["bin/instance", "fg"]
