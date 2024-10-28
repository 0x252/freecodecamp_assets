#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
f=games.csv
#for l in `IFS=',' cat games.csv`; # dont works
i=0
while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  echo "$i: $year, $round, $winner, $opponent, $winner_goals, $opponent_goals"
  if [[ $i == 0 ]];
  then
          (( i = i + 1 ))
          echo "skip"
          continue
  fi
winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
if [[ -z $winner_id ]]; then
  `$PSQL "INSERT INTO teams(name) VALUES('$winner')"`
  export winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
fi
opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
if [[ -z $opponent_id ]]; then
  `$PSQL "INSERT INTO teams(name) VALUES('$opponent')"`
  export opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
fi
#  `$PSQL "INSERT INTO winners(name) VALUES('$winner');"`
#  `$PSQL "INSERT INTO opponents(name) VALUES('$opponent');"`
# TODO: SELECT winner_id FROM winners ORDER BY winner_id DESC; and etc
  $($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) values('$year', '$winner_id', '$opponent_id', '$winner_goals', '$opponent_goals', '$round');")
  (( i = i + 1 ))
  #r=$($PSQL "INSERT INTO GAMES (year, round, winner, opponent, winner_goals, opponent_goals) VALUES('$year', '$round', '$winner', '$opponent', '$winner_goals', '$opponent_goals')")
  #echo "$? = $r"
done < "$f"
