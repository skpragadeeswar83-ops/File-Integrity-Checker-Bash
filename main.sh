#!/bin/bash

# Color Codes
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m" # No Color

# Create folders if missing
mkdir -p Baselines Reports

main() {
    echo -e "${BLUE}==============================================="
    echo -e "     FILE SYSTEM INTEGRITY CHECKER (FIC)      "
    echo -e "===============================================${NC}"
    
    while true; do
        echo -e "\n${YELLOW}Choose an option:${NC}"
        echo "1) Create Baseline"
        echo "2) Run Integrity Check"
        echo "3) Generate Report"
        echo "q) Quit"
        read -p "Enter your choice: " opt
    
        case "$opt" in
            1)
                read -p "Enter directory path or name: " dir
                if [ -z "$dir" ]; then
                    echo -e "${RED}❌ Invalid input!${NC}"
                else
                    source ./baseline_creator.sh "$dir"
                fi
                ;;
    
            2)
                read -p "Run check? This will overwrite temp reports! Proceed? (y/n): " ans
                if [ "$ans" == "y" ]; then
                    read -p "Enter directory path or name to check: " dir
                    source ./run_check.sh "$dir"
                fi
                ;;
    
            3)
                read -p "Generate report from temp data? (y/n): " ans
                if [ "$ans" == "y" ]; then
                    read -p "Enter report name: " name
                    source ./reporting.sh "./Reports/temp_Report.txt" > "./Reports/$name.txt"
                    echo -e "${GREEN}📄 Report saved as: ./Reports/$name.txt${NC}"
                fi
                ;;
    
            q|Q)
                echo -e "${GREEN}Exiting program. Stay secure! 👋${NC}"
                exit 0
                ;;
    
            *)
                echo -e "${RED}❌ Invalid option! Try again.${NC}"
                ;;
        esac
    done
}

main
