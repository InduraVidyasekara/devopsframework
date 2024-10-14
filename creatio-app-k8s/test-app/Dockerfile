FROM python:3.9-slim
COPY app.py /app/app.py
WORKDIR /app
RUN apt-get upgrade && apt-get update

RUN pip install flask
CMD ["python", "app.py"]
