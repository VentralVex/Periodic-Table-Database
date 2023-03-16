#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if no parameters are specified
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
#if run for hydrogen
elif [[ "$1" == "1" || "$1" == "H" || "$1" == "Hydrogen" ]]; then
  echo "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
#else, if run for other element
else
  # SQL query to select element information with type name
  query="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE (elements.atomic_number = '$1' OR elements.symbol = '$1' OR elements.name = '$1')"

  # run query and store output in variable
  output=$($PSQL "$query")

  # if query returns no rows, output an error message
  if [[ -z $output ]]; then
    echo "I could not find that element in the database."
  # else, parse output and output element information
  else
    # parse output into variables
    atomic_number=$(echo $output | awk -F "|" '{print $1}')
    name=$(echo $output | awk -F "|" '{print $2}')
    symbol=$(echo $output | awk -F "|" '{print $3}')
    type=$(echo $output | awk -F "|" '{print $4}')
    atomic_mass=$(echo $output | awk -F "|" '{print $5}')
    melting_point=$(echo $output | awk -F "|" '{print $6}')
    boiling_point=$(echo $output | awk -F "|" '{print $7}')

    # output element information
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  fi
fi
