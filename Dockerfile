FROM oven/bun:latest AS build

COPY medpoisk-client/ /medpoisk-client

WORKDIR /medpoisk-client

RUN bun install
RUN bun run build

FROM python:3.11

RUN apt update && apt upgrade -y

RUN pip install -U pip && pip install poetry

WORKDIR /medpoisk-server

COPY medpoisk-server/pyproject.toml .

RUN poetry install --no-root

COPY --from=build /medpoisk-client /medpoisk-client
COPY medpoisk-server/ /medpoisk-server


CMD poetry run python -m medpoisk_server