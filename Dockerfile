FROM python:3.7

RUN apt-get update && apt-get -y install netcat && apt-get clean

WORKDIR /app

COPY . .

RUN chmod +x ./run*.sh
EXPOSE 8000

RUN pip install --no-cache-dir -r requirements.txt

CMD ["./run.sh"]