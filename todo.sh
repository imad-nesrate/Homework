#!/bin/bash

TASKS_FILE="tasks.txt"

initialize_tasks_file() {
    if [ ! -e "$TASKS_FILE" ]; then
        touch "$TASKS_FILE"
        echo "Tasks file created."
    fi
}

create_task() {
    initialize_tasks_file

    while true; do
        echo "Enter the title of the task: "
        read -r title
        if [ -z "$title" ]; then
            echo "Error: Title cannot be empty. Please enter a title." >&2
        else
            break
        fi
    done

    while true; do
        echo "Enter the due date of the task (YYYY-MM-DD): "
        read -r due_date
        if [ -z "$due_date" ]; then
            echo "Error: Due Date cannot be empty. Please enter a due date in YYYY-MM-DD format." >&2
        elif ! [[ "$due_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! date -d "$due_date" >/dev/null 2>&1; then
            echo "Error: Invalid date format. Please enter the date in YYYY-MM-DD format." >&2
        else
            break
        fi
    done

    echo "Enter the description of the task: "
    read -r description

    echo "Enter the location of the task: "
    read -r location

    echo "Is the task completed? (yes/no): "
    read -r completion
    case "$completion" in
        yes) completion="completed" ;;
        *) completion="uncompleted" ;;
    esac

    task_id=$(awk 'END {print $1+1}' "$TASKS_FILE" 2>/dev/null || echo 1)
    echo "$task_id    $title    $description    $location    $due_date    $completion" >> "$TASKS_FILE"
    echo "Task added successfully."
}

update_task() {
    echo "Enter the ID of the task you want to update: "
    read -r task_id

    echo "What do you want to update? (1. Title, 2. Description, 3. Location, 4. Due Date, 5. Completion)"
    read -r choice

    echo "Enter the new value: "
    read -r new_value

    awk -v task_id="$task_id" -v choice="$choice" -v new_value="$new_value" '
    BEGIN {FS=OFS="    "} 
    $1 == task_id {
        if (choice == 1) $2 = new_value;
        else if (choice == 2) $3 = new_value;
        else if (choice == 3) $4 = new_value;
        else if (choice == 4) $5 = new_value;
        else if (choice == 5) $6 = new_value;
    } 
    {print}' "$TASKS_FILE" > temp && mv temp "$TASKS_FILE"

    echo "Task updated successfully."
}

delete_task() {
    echo "Enter the ID of the task you want to delete: "
    read -r task_id

    awk -v task_id="$task_id" 'BEGIN {FS=OFS="    "} $1 != task_id' "$TASKS_FILE" > temp && mv temp "$TASKS_FILE"
    echo "Task deleted successfully."
}

task_info() {
    echo "Enter the ID of the task you want to view:"
    read -r task_id

    awk -v task_id="$task_id" -F '    ' '
    BEGIN {found=0}
    $1 == task_id {
        print "Task ID: " $1
        print "Title: " $2
        print "Description: " $3
        print "Location: " $4
        print "Due Date: " $5
        print "Completion: " $6
        found=1
        exit
    }
    END {
        if (found == 0) {
            print "Task with ID " task_id " not found."
        }
    }' "$TASKS_FILE"
}

list_tasks_by_day() {
    echo "Enter the date (YYYY-MM-DD) to list tasks for:"
    read -r input_date

    if ! [[ "$input_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Invalid date format. Please enter the date in YYYY-MM-DD format."
        return
    fi

    completed_tasks=$(awk -v date="$input_date" 'BEGIN {FS=OFS="    "} $5 == date && $6 == "completed"')
    uncompleted_tasks=$(awk -v date="$input_date" 'BEGIN {FS=OFS="    "} $5 == date && $6 != "completed"')

    if [ -n "$completed_tasks" ]; then
        echo "Completed tasks for $input_date:"
        echo "$completed_tasks"
    else
        echo "No completed tasks for $input_date."
    fi

    if [ -n "$uncompleted_tasks" ]; then
        echo "Uncompleted tasks for $input_date:"
        echo "$uncompleted_tasks"
    else
        echo "No uncompleted tasks for $input_date."
    fi
}

list_tasks() {
    local recup_date="$1"
    completed_tasks=$(awk -v date="$recup_date" 'BEGIN {FS=OFS="    "} $5 == date && $6 == "completed"')
    uncompleted_tasks=$(awk -v date="$recup_date" 'BEGIN {FS=OFS="    "} $5 == date && $6 != "completed"')

    if [ -n "$completed_tasks" ]; then
        echo "Completed tasks for $recup_date:"
        echo "$completed_tasks"
    else
        echo "No completed tasks for $recup_date."
    fi

    if [ -n "$uncompleted_tasks" ]; then
        echo "Uncompleted tasks for $recup_date:"
        echo "$uncompleted_tasks"
    else
        echo "No uncompleted tasks for $recup_date."
    fi
}

search_task_by_title() {
    echo "Enter the title of the task you want to search for:"
    read -r search_title

    matching_tasks=$(awk -v title="$search_title" 'BEGIN {FS=OFS="    "} $2 == title')

    if [ -n "$matching_tasks" ]; then
        echo "Tasks with title '$search_title':"
        echo "$matching_tasks"
    else
        echo "No tasks found with title '$search_title'."
    fi
}

if [ $# -eq 0 ]; then
    current_date=$(date +'%Y-%m-%d')
    list_tasks "$current_date"
    exit 0
fi

case "$1" in
    create)
        create_task
        ;;
    update)
        update_task
        ;;
    delete)
        delete_task
        ;;
    info)
        task_info
        ;;
    list)
        list_tasks_by_day
        ;;
    search)
        search_task_by_title
        ;;
    *)
        echo "Invalid option. Please use one of the following: create, update, delete, info, list, search."
        exit 1
        ;;
esac
