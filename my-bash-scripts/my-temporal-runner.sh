#!/bin/bash
find . -name '*.go' | entr -r teller run --reset --shell -- go run cmd/temporal/main.go | jq --color-output -R 'fromjson?'
