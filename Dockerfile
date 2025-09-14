FROM ruby:3.1.0

# Instalar dependências do MySQL e development tools
RUN apt-get update -qq && \
    apt-get install -y \
    default-mysql-client \
    libmysqlclient-dev \
    build-essential \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Configurar bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Instalar gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copiar código da aplicação
COPY . .

# Expor porta
EXPOSE 3000

# Script de entrada
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Comando principal
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]