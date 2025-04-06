#!/bin/bash

# Set the commit day (yyyy-mm-dd)
commit_day="2025-04-06"

# Start and end time for commits (start at 4:30 AM, end at 10:00 PM)
start_hour=4
start_minute=30
end_hour=22

# Get all files/folders (excluding .git)
files=$(find . -mindepth 1 -not -path './.git*' | sort)

# Total hours to spread over (excluding the start time minute part)
total_hours=$((end_hour - start_hour))

i=0
for file in $files; do
    git add "$file"

    # Random hour within the time window
    hour_offset=$((RANDOM % total_hours))
    hour=$((start_hour + hour_offset))

    # Random minute and second (including the starting minute of 30)
    if [ $hour -eq $start_hour ]; then
        minute_offset=$((RANDOM % (60 - start_minute) + start_minute))
    else
        minute_offset=$((RANDOM % 60))
    fi
    second=$((RANDOM % 60))

    # Format the time
    commit_time=$(printf "$commit_dayT%02d:%02d:%02d" $hour $minute_offset $second)

    # Create the commit with random timestamp
    GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" \
    git commit -m "Add $file"

    echo "Committed $file at $commit_time"
    ((i++))
done

