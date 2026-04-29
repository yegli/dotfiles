#!/bin/bash
set -e

echo "Creating folder structure..."
mkdir -p "$HOME/_code/private"
mkdir -p "$HOME/_code/ost"
mkdir -p "$HOME/_code/work"

echo "Folders created:"
ls -la "$HOME/_code/"
