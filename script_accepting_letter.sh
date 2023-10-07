#!/bin/bash

# Get the letter from the user
letter=$(echo "$1" | cut -c1)

# Create an array to store the countries that start with the given letter
countries_with_letter=(
  "Afghanistan" "Kabul"
  "Albania" "Tirana"
  "Algeria" "Algiers"
  "Andorra" "Andorra la Vella"
  "Angola" "Luanda"
  "Uganda" "Kampala"
  "Kenya" "Nairobi"
)

# Iterate over the countries and add them to the array if they start with the given letter
for country in "${countries[@]}"; do
  if [[ "$country" =~ ^"$letter"[a-zA-Z]* ]]; then
    countries_with_letter+=("$country")
  fi
done

# Print the header
printf "%-20s\n" "Country"

# Print the countries in the array
for country in "${countries_with_letter[@]}"; do
  printf "%-20s\n" "$country"
done
