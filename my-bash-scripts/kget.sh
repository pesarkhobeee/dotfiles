#!/bin/bash

# =============================================================================
# kget.sh - Interactive Kubernetes Resource Explorer
# =============================================================================
#
# This script provides an interactive way to explore Kubernetes resources using
# fzf for selection and bat for formatted output.
#
# Usage:
#   ./kget.sh           - Browse and describe Kubernetes resources interactively
#   ./kget.sh [arg]     - Explain a selected resource type instead of describing instances
#
# Features:
# - Lists all available Kubernetes resources using kubectl api-resources
# - Uses fzf for interactive resource type selection
# - Without arguments: Shows all instances of selected resource across namespaces,
#   then allows selection of a specific instance to describe
# - With any argument: Shows explanation of the selected resource type
# - Uses bat for syntax-highlighted YAML output
#
# Dependencies: kubectl, fzf, bat
# =============================================================================

# get aptional argument to explain a resource directly
if [ "$1" ]; then
    explain=true
fi

# Get all available Kubernetes resources
resources=$(kubectl api-resources --no-headers --verbs=list -o name | grep -v "^v" | sort | uniq)

# Use fzf to select a resource
selected=$(echo "$resources" | fzf --height=40% --reverse --prompt="Select a Kubernetes resource: ")

# Print the selected resource
echo "Selected resource: $selected"

# Explain the selected resource or get all of that resource type
if [ "$explain" = true ]; then
    kubectl explain "$selected" | bat --language=yaml
else
    kubectl get "$selected" -A | fzf | kubectl describe $selected $(awk '{print $2 " " "-n" $1}') | bat --language=yaml
fi
