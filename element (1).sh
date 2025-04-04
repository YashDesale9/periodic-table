#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"

# check argument is zero/empty
if [[ -z $1 ]]
then
  # return message
  echo Please provide an element as an argument.
else
  # check is argument a number
  if [[ $1 =~ ^[0-9]$ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius  FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$1")
  else
    # not a number 
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius  FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE elements.name='$1' OR elements.symbol='$1'")
  fi
  
  # check if exists
  if [[ -z $ELEMENT_INFO ]]
  then
    # return message
    echo I could not find that element in the database.
  else
    # get info 
    echo $ELEMENT_INFO | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
    # return info message
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  fi
  
fi
