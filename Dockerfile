FROM ubuntu:18.04

MAINTAINER Bruno Lehnen Simões "bruno.lehnen@gmail.com"

RUN apt-get update -y && \
    apt-get install -y python-pip python-dev

COPY ./app /app
WORKDIR /app
RUN pip install flask

ENTRYPOINT ["python"]
CMD ["app.py"]
