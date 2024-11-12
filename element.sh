PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")

    if [[ -z $ELEMENT ]]
    then
      echo I could not find that element in the database.
    else
      while IFS='|' read TYPE_ID ID SYMBOL NAME MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done < <($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
    fi
  else
    ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' or name = '$1'")

    if [[ -z $ELEMENT ]]
    then
      echo I could not find that element in the database.
    else
      while IFS='|' read TYPE_ID ID SYMBOL NAME MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done < <($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
    fi
  fi
else
  echo Please provide an element as an argument.
fi