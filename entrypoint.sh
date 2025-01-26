#!/bin/sh
set -x

cat <<EOL > go.mod
module code

go 1.22.5

require (
	github.com/99designs/gqlgen v0.17.63
	github.com/vektah/gqlparser/v2 v2.5.21
)
EOL


if [ ! -f go.mod ]; then
    go mod init code
fi

go mod tidy

printf '//go:build tools\npackage tools\nimport (_ "github.com/99designs/gqlgen"\n _ "github.com/99designs/gqlgen/graphql/introspection")' | gofmt > tools.go

go mod tidy

go run github.com/99designs/gqlgen init

go mod tidy

if [ -f /app/server.go ]; then
    echo "server.go criado com sucesso!"
else
    echo "Erro: server.go não foi criado!"
    exit 1
fi

ls -la /app

go run server.go || {
    echo "Falha ao iniciar o servidor Go"
    exit 1
}