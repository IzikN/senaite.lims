FROM python:3.10-slim

WORKDIR /app

COPY . .

RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install -U pip setuptools zc.buildout && \
    buildout bootstrap && \
    buildout

EXPOSE 8080

CMD ["./bin/instance", "fg"]
