#!/bin/sh
set -x  # Modo de debug para imprimir comandos executados

# Criar o arquivo go.mod
cat <<EOL > go.mod
module code

go 1.22.5

require (
	github.com/99designs/gqlgen v0.17.63
	github.com/vektah/gqlparser/v2 v2.5.21
)
EOL


# Inicializar o módulo Go apenas se go.mod não existir
if [ ! -f go.mod ]; then
    go mod init code
fi

go mod tidy

# Gerar o arquivo tools.go
printf '//go:build tools\npackage tools\nimport (_ "github.com/99designs/gqlgen"\n _ "github.com/99designs/gqlgen/graphql/introspection")' | gofmt > tools.go

# Baixar dependências novamente
go mod tidy

# Inicializar o gqlgen
go run github.com/99designs/gqlgen init

# Baixar dependências novamente
go mod tidy

# Verificar se o server.go foi criado
if [ -f /app/server.go ]; then
    echo "server.go criado com sucesso!"
else
    echo "Erro: server.go não foi criado!"
    exit 1
fi

# Listar arquivos no diretório /app
ls -la /app

# Rodar o servidor Go
go run server.go || {
    echo "Falha ao iniciar o servidor Go"
    exit 1
}