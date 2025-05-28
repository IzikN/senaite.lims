FROM python:2.7

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

# Copy buildout config and requirements
COPY requirements.txt buildout.cfg ./

# Install pip and required packages
RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && buildout bootstrap --buildout-version=2.13.3 --setuptools-version=44.1.1 \
    && buildout

# Copy rest of the project
COPY . .

# Expose Zope/SENAITE default port
EXPOSE 8080

# Default command to run Plone/SENAITE in foreground
CMD ["bin/instance", "fg"]
