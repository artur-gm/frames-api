# README

API para gerenciar quadros e círculos dentro deles.

A documentação da API estará disponível em: http://localhost:3000/ (HTML) e http://localhost:3000/api-docs/v1/swagger.yaml (YAML).

## Requisitos

- Docker
- Docker Compose

## Inicialização do Projeto

1. Clone o repositório:

   ```bash
   git clone https://github.com/artur-gm/frames-api
   ```

2. Navegue até o diretório do projeto:

   ```bash
   cd frames-api
   ```

3. Use os scripts fornecidos na pasta `bin`:
    - Para iniciar o ambiente de desenvolvimento:

      ```bash
      ./bin/setup.sh
      ```

    - Para executar testes:

      ```bash
      ./bin/test.sh
      ```

    - Para abrir o console do Rails:

        ```bash
        ./bin/console.sh
        ```

    3.1. Caso não esteja usando Linux, pode usar

    ```bash
    docker-compose build
    docker-compose
    ```

4. A API estará disponível em `http://localhost:3000`.

