#!/bin/bash
cleanup() {
	trap cleanup SIGINT
echo "Enter the project name:"
read PROJECT_NAME 
DIR="attendance_tracker_${PROJECT_NAME}"
	ARCHIVE="attendance_tracker_${PROJECT_NAME}_aechive.tar.gz"
	tar -czf "$ARCHIVE" "$DIR" 2>/dev/null
	rm -rf "$DIR" 
	exit 1
}
trap cleanup SIGINT 
if [ -d "$DIR" ]; then
	echo "Folder already exists. Replace it? (y/n)"
	read CONFIRM
	if [ "$CONFIRM" = "y" ]; then 
	rm -rf "$DIR" 
else
exit 0
	fi 
fi 
mkdir -p "$DIR/Helpers"
mkdir -p "$DIR/reports"
cp attendance_checker.py "$DIR/attendance_checker.py"
cp assets.csv "$DIR/Helpers/assets.csv"
cp config.json "$DIR/Helpers/config.json"
cp reports.log "$DIR/reports/reports.log"
echo "Update thresholds? (y/n)"
read UPDATE_CONFIG
if [ "$UPDATE_CONFIG" = "y" ]; then 
	echo "New WARNING value (default 75):"
	read WARNING_VAL
	[[ "$WARNING_VAL" =~ ^[0-9]+$ ]] || WARNING_VAL=75
sed -i "s/\"warning\": [0-9]*/\"warning\": $WARNING_VAL/" "$DIR/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]*/\"failure\": $FAILURE_VAL/" "$DIR/Helpers/config.json"
fi
if python3 --version 2>/dev/null; then
	echo "Python3 is installed."
else
	echo "WARNING: Python3 is not installed"
fi 
for FILE in "${REQUIRED_FILES[@]}"; do
	if [ -f "$FILE" ]; then 
		echo "FOUND: $FILE"
	else
		echo "MISSING: $FILE"
	fi 
done
