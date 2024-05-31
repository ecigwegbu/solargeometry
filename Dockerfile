# Solargeometry app Dockerfile
# FROM python:3.10-alpine
FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /app
COPY static/ /app/static/
COPY templates/ /app/templates/
COPY solargeometry.py /app
COPY requirements.txt /app

RUN dnf install -y python3-pip && \
    pip install -r requirements.txt  # flask requests gunicorn python-dotenv

CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:5004", "--log-file", "/tmp/solargeometry-error.log", "--access-logfile", "/tmp/solargeometry-access.log", "solargeometry:app"]

