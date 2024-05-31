FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /app
COPY static/ /app/static/
COPY templates/ /app/templates/
COPY solargeometry.py /app
COPY requirements.txt /app

RUN dnf install -y python3-pip
RUN pip install -r requirements.txt  # flask requests gunicorn python-dotenv

CMD /usr/bin/echo "Hello World"
