FROM registry.access.redhat.com/ubi9/ubi

WORKDIR /app
COPY static/ /app/static/
COPY templates/ /app/templates/
COPY solargeometry.py /app
COPY requirements.txt /app

CMD /usr/bin/echo "Hello World"
