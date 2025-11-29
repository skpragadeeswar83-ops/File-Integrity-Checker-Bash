#!/bin/bash

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

createBaseline() {

    # Check if full path was provided
    if [ -d "$1" ]; then
        BASEPATH=$(cd "$1" && pwd)
    else
        # Support legacy input: search by name only
        BASEPATH=$(find ~ -type d -name "$1" 2>/dev/null | head -n1)
    fi

    if [ ! -d "$BASEPATH" ]; then
        echo -e "${RED}❌ Directory not found!${NC}"
        return
    fi

    mkdir -p Baselines

    timestamp=$(date +"%Y%m%d_%H%M")
    folderName=$(basename "$BASEPATH")
    baselineFile="Baselines/${folderName}_baseline_${timestamp}.txt"

    echo -e "${BLUE}🔍 Scanning directory: $BASEPATH${NC}"
    echo -e "${YELLOW}Calculating hashes...${NC}"

    fileCount=0
    {
        for file in "$BASEPATH"/*; do
            if [ -f "$file" ]; then
                shasum -a 256 "$file"
                fileCount=$((fileCount+1))
            fi
        done
    } > "$baselineFile"

    echo -e "${GREEN}==========================================="
    echo -e "  🛡️  Baseline Created Successfully!"
    echo -e "  Directory: $BASEPATH"
    echo -e "  Files scanned: $fileCount"
    echo -e "  Saved as: $baselineFile"
    echo -e "===========================================${NC}"
}

createBaseline "$1"
