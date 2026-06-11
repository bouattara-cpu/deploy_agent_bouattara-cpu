# deploy_agent_bouattara-cpu

## How to run the script 
- Open your terminal 
- Go into the project folder: cd deploy_agent_bouattara-cpu
- Make the script excutable: chmod +x setup_project.sh 
- Run the script: bash setup_project.sh
- Enter a project name when asked 
- Choose whether to update the thresholds 
- The health check runs automatically 

## How to trigger the archive feature 

While the script is running, press Ctrl+C at any time.
The script will:
- Detect the Ctrl+C signal
- Bundle the incomplete folder into a .tar.gz archive 
- Delete the incomplete folder
- Exit cleanly

## Project Stucture Created

attendance_tracker_bouattara-cpu/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log

## Requirements
- Bash shell
- Python3 installed    
