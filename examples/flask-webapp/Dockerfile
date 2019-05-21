FROM python:2.7-alpine
WORKDIR /app
ADD . /app
RUN pip install Flask
ENV NAME World
CMD ["python", "app.py"]