# FROM oven/bun:latest AS build

# COPY medpoisk-client/ /medpoisk-client

# WORKDIR /medpoisk-client

# RUN bun install
# RUN bun run build

FROM python:3.11

ARG SQLALCHEMY_DATABASE_URL
ENV SQLALCHEMY_DATABASE_URL $SQLALCHEMY_DATABASE_URL

RUN apt update && apt upgrade -y

RUN pip install -U pip && pip install poetry

WORKDIR /medpoisk-server

COPY medpoisk-server/pyproject.toml .

RUN poetry install --no-root

COPY medpoisk-client/dist /medpoisk-client/dist
COPY medpoisk-server/ /medpoisk-server

RUN mkdir ./pictures
CMD poetry run alembic upgrade head && poetry run python -m medpoisk_server