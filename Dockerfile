FROM python:3.9-slim

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libssl-dev \
    libffi-dev \
    libldap2-dev \
    libsasl2-dev \
    libpq-dev \
    git \
    curl \
    python3-dev \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Upgrade pip and install setuptools <58 for compatibility
RUN pip install --upgrade pip "setuptools<58" wheel

# Copy buildout files
COPY buildout.cfg .
COPY requirements.txt .

# Install Python requirements (if any)
RUN pip install -r requirements.txt || true

# Install zc.buildout and bootstrap the project
RUN pip install zc.buildout \
    && buildout init \
    && buildout bootstrap --buildout-version=2.13.3 --setuptools-version=57.5.0 \
    && buildout

# Copy the rest of the project
COPY . .

# Expose default Zope port
EXPOSE 8080

# Run Plone/SENAITE in foreground
CMD ["bin/instance", "fg"]
