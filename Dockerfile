# すべての環境で必要になりそうなベース
FROM python:3.11-slim-bookworm AS base

RUN pip install poetry \
    && apt-get update \ 
    && apt-get install -y build-essential --no-install-recommends make \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    curl 

# プロジェクトファイルのコピー
COPY pyproject.toml poetry.lock* ./

# 作業ディレクトリの設定
WORKDIR /app

# devcontainer用のステージ
FROM base AS local
RUN apt-get install -y git \
    git-secrets

# 依存パッケージのインストール
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

FROM base AS production
# 依存パッケージのインストール
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --only main