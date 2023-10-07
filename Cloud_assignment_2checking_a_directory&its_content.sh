
#!/bin/bash

# Get the sort order argument ("a" for ascending, "d" for descending)
sort_order="$1"
shift  # Remove the sort order argument from the arguments list

# Loop through each directory path
for dir in "$@"; do
    # Check if the argument is a directory
    if [ -d "$dir" ]; then  # Changed "$Dir" to "$dir"
        echo "Sorting contents of $dir:"  # Changed "$Documents" to "$dir"
        echo "Yes"

        # Sort the contents based on the provided sort order
        if [ "$sort_order" = "a" ]; then
            ls -1 "$dir" | sort
        elif [ "$sort_order" = "d" ]; then
            ls -1 "$dir" | sort -r
        else
            echo "Invalid sort order argument: $sort_order"
            exit 1
        fi

        echo
    else
        echo "$dir" is not a valid directory.
    fi
done

