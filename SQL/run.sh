#!/bin/bash

# Database credentials
DB_USER="root"
DB_PASS="rootpassword"
DB_NAME="ml"

# Log files
LOG_FILE="sql_execution.log"
ERROR_LOG_FILE="sql_errors.log"

# Initialize logs
echo "SQL Execution Log - $(date)" > $LOG_FILE
echo "SQL Error Log - $(date)" > $ERROR_LOG_FILE

# mysql  -h 127.0.0.1 -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < drop/drop_and_create.sql

# Loop through all .sql files in the current directory
for script in *.sql; do
    if [[ -f "$script" ]]; then
        echo "Running script: $script" | tee -a $LOG_FILE
        mysql  -h 127.0.0.1 -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$script" 2>> >(while read -r line; do echo "[$script] $line" >> $ERROR_LOG_FILE; done)
        if [[ $? -eq 0 ]]; then
            echo "Successfully executed: $script" | tee -a $LOG_FILE
        else
            echo "Error occurred while running: $script. Check $ERROR_LOG_FILE for details." | tee -a $LOG_FILE
        fi
    fi
done

echo "Execution completed. Check $LOG_FILE and $ERROR_LOG_FILE for details."
