#!/bin/bash
# A script to validate Kubernetes YAML files against multiple schema locations using kubeconform.
kubeconform -summary -kubernetes-version 1.33.5 -schema-location default -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' "$1"
