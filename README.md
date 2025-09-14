# frames-api

![Coverage](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fartur-gm%2Fframes-api%2Frefs%2Fheads%2Fmain%2Fcoverage%2F.last_run.json&query=%24.result.line&label=coverage&color=green)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/artur-gm/frames-api/ci.yml)
![Rails Version](https://img.shields.io/badge/Rails-8-blue)


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

