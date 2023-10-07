#!/bin/bash

# Create an array to store the countries and capitals
countries=(
  "Afghanistan" "Kabul"
  "Albania" "Tirana"
  "Algeria" "Algiers"
  "Andorra" "Andorra la Vella"
  "Angola" "Luanda"
  ... # add all countries and capitals here
)

# Print the header
printf "%-20s\t%-20s\n" "Country" "Capital"

# Iterate over the countries and print each one with its capital in two columns
for country in "${countries[@]}"; do
  capital=$(echo "$country" | cut -d' ' -f2)
  printf "%-20s\t%-20s\n" "$country" "$capital"
done


