#!/bin/bash

# Create an array to store the countries and capitals
countries=(
  "Afghanistan" "Kabul"
  "Albania" "Tirana"
  "Algeria" "Algiers"
  "Andorra" "Andorra la Vella"
  "Angola" "Luanda"
  "uganda" "kampala"
  "Kenya"  "Nairobi"
)

# Create a temporary file to store the sorted data
tempfile=$(mktemp)

# Sort the countries and capitals alphabetically by capital city
sort -t' ' -k2 "${countries[@]}" > "$tempfile"

# Print the header
printf "%-20s %-20s\n" "Country" "Capital"

# Read the sorted data from the temporary file and print it to the console
while read -r country capital; do
  printf "%-20s %-20s\n" "$country" "$capital"
done < "$tempfile"

# Remove the temporary file
rm "$tempfile"
