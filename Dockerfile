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

# ✅ Copy config files first
COPY requirements.txt buildout.cfg versions.cfg ./

# ✅ Install and run buildout
RUN pip install --upgrade pip \
 && pip install setuptools==58.5.3 wheel==0.37.1 zc.buildout==2.13.3 \
 && buildout bootstrap \
 && buildout

# ✅ Copy the rest of the project AFTER buildout setup
COPY . .

# Expose Zope/SENAITE default port
EXPOSE 8080

# Default command to run Plone/SENAITE in foreground
CMD ["bin/instance", "fg"]
