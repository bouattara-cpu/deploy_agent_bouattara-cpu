#!/bin/bash
echo "Enter the project name:"
read PROJECT_NAME 
DIR="attendance_tracker_${PROJECT_NAME}"
cleanup() {
	echo ""
	echo "[TRAP] ctrl+c detected! Archiving..."
	if [ -d "$DIR" ]; then 
	ARCHIVE="attendance_tracker_${PROJECT_NAME}_archive.tar.gz"
	tar -czf "$ARCHIVE" "$DIR" 2>/dev/null
	rm -rf "$DIR" 
	echo "[TRAP] Archive created and folder deleted"
else
	echo "[TRAP] Nothing to archive"
	fi
	exit 1
}
trap 'cleanup' SIGINT
set -e
if [ -d "$DIR" ]; then
	echo "Folder already exists. Replace it? (y/n)"
	read CONFIRM
	if [ "$CONFIRM" = "y" ]; then 
	rm -rf "$DIR" 
else
exit 0
	fi 
fi
echo "Creating project folders..."
mkdir -p "$DIR/Helpers"
mkdir -p "$DIR/reports"
cp attendance_checker.py "$DIR/attendance_checker.py"
cp assets.csv "$DIR/Helpers/assets.csv"
cp config.json "$DIR/Helpers/config.json"
cp reports.log "$DIR/reports/reports.log"
echo "Files copied."
echo "Update thresholds? (y/n)"
read UPDATE_CONFIG
if [ "$UPDATE_CONFIG" = "y" ]; then 
	echo "New WARNING value (default 75):"
	read WARNING_VAL
	if ! [[ "$WARNING_VAL" =~ ^[0-9]+$ ]]; then
	       	WARNING_VAL=75
	fi
	echo "New FAILURE value (default 50):"
	read FAILURE_VAL
	if ! [[ "$FAILURE_VAL" =~ ^[0-9]+$ ]]; then 
		FAILURE_VAL=50
	fi
sed -i "s/\"warning\": [0-9]*/\"warning\": $WARNING_VAL/" "$DIR/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]*/\"failure\": $FAILURE_VAL/" "$DIR/Helpers/config.json"
    echo "Thresholds updated: Warning=$WARNING_VAL% / Failure=$FAILURE_VAL%"
fi
echo "Running health check..."
if python3 --version 2>/dev/null; then
	echo "Python3 is installed."
else
	echo "WARNING: Python3 is not installed"
fi 
REQUIRED_FILES=(
	"$DIR/attendance_checker.py"
	"$DIR/Helpers/assets.csv"
	"$DIR/Helpers/config.json"
	"$DIR/reports/reports.log"
)
for FILE in "${REQUIRED_FILES[@]}"; do
	if [ -f "$FILE" ]; then 
		echo "FOUND: $FILE"
	else
		echo "MISSING: $FILE"
	fi 
done
