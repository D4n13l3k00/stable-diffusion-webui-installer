#!/bin/bash
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo "Usage: $0 <magnet link>"
    exit 1
fi

echo -e "${GREEN}${BOLD}Compressed magnet link:${NC}"
echo $1 | gzip | base64 -w0
