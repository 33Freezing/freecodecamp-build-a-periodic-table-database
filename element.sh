#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
   echo "Please provide an element as an argument."
else
   QUERY="select e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type from elements as e inner join properties as p using(atomic_number) inner join types as t using(type_id) where "
   if [[ $1 =~ ^[0-9]+$ ]]
   then
      ELEMENT_INFO=$($PSQL "$QUERY atomic_number=$1;")
  else
      ELEMENT_INFO=$($PSQL "$QUERY symbol='$1' or name='$1';")
  fi 
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT_INFO | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
     echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi

