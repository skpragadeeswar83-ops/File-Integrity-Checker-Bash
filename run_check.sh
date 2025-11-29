#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

compareHashes() {
    local dirPath="$1"

    if [ -d "$dirPath" ]; then
        realDir=$(cd "$dirPath" && pwd)
    else
        realDir=$(find ~ -type d -name "$dirPath" 2>/dev/null | head -n1)
    fi

    if [ ! -d "$realDir" ]; then
        echo -e "${RED}❌ Directory not found!${NC}"
        return
    fi

    folderName=$(basename "$realDir")
    baselineFile=$(ls Baselines/"${folderName}"*_baseline_*.txt 2>/dev/null | head -n1)

    if [ ! -f "$baselineFile" ]; then
        echo -e "${RED}❌ No baseline found for $folderName${NC}"
        return
    fi

    mkdir -p Reports
    reportFile="Reports/temp_Report.txt"
    > "$reportFile"

    echo -e "${BLUE}🔍 Running Integrity Check...${NC}"
    
    changes=0

    while read -r baseHash baseFile; do
        if [ -f "$baseFile" ]; then
            currentHash=$(shasum -a 256 "$baseFile" | awk '{print $1}')
            if [ "$currentHash" != "$baseHash" ]; then
                echo -e "${RED}Modified: $baseFile${NC}" | tee -a "$reportFile"
                ((changes++))
            fi
        else
            echo -e "${YELLOW}Deleted: $baseFile${NC}" | tee -a "$reportFile"
            ((changes++))
        fi
    done < <(awk '{print $1, $2}' "$baselineFile")

    for file in "$realDir"/*; do
        if ! grep -q "$file" "$baselineFile"; then
            echo -e "${GREEN}Added: $file${NC}" | tee -a "$reportFile"
            ((changes++))
        fi
    done

    echo -e "${BLUE}======================================"
    echo -e "🔔 Integrity Check Completed"
    echo -e "Total Changes Found: $changes"
    echo -e "Results saved to: $reportFile"
    echo -e "======================================${NC}"
}

compareHashes "$1"
