FROM golang:1.22.5

WORKDIR /app

COPY code .

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

RUN ls -la .

ENTRYPOINT ["sh", "entrypoint.sh"]
