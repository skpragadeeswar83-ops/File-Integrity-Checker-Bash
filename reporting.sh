#!/bin/bash

generateReport() {
    reportFile="$1"

    if [ ! -f "$reportFile" ]; then
        echo "❌ No temp report found!"
        return
    fi

    finalReport="Reports/Integrity_Report_$(date +%Y%m%d_%H%M).txt"

    echo "============== FILE INTEGRITY REPORT ==============" > "$finalReport"
    echo "Generated On: $(date)" >> "$finalReport"
    echo "" >> "$finalReport"

    high=$(grep -c "Modified:" "$reportFile")
    med=$(grep -c "Deleted:" "$reportFile")
    low=$(grep -c "Added:" "$reportFile")
    total=$((high + med + low))

    echo "Total Changes Found: $total" >> "$finalReport"
    echo "High Priority (Modified): $high" >> "$finalReport"
    echo "Medium Priority (Deleted): $med" >> "$finalReport"
    echo "Low Priority (Added): $low" >> "$finalReport"
    echo "" >> "$finalReport"

    if [ $high -gt 0 ]; then
        echo "🔴 HIGH PRIORITY — Modified Files:" >> "$finalReport"
        grep "Modified:" "$reportFile" >> "$finalReport"
        echo "" >> "$finalReport"
    fi

    if [ $med -gt 0 ]; then
        echo "🟡 MEDIUM PRIORITY — Deleted Files:" >> "$finalReport"
        grep "Deleted:" "$reportFile" >> "$finalReport"
        echo "" >> "$finalReport"
    fi

    if [ $low -gt 0 ]; then
        echo "🟢 LOW PRIORITY — New Files:" >> "$finalReport"
        grep "Added:" "$reportFile" >> "$finalReport"
        echo "" >> "$finalReport"
    fi

    echo "===================================================" >> "$finalReport"

    echo "📄 Report successfully created:"
    echo "$finalReport"
}

generateReport "$1"
