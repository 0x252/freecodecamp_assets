#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.
winner_goals=$($PSQL "SELECT SUM(winner_goals) FROM games")
opponent_goals=$($PSQL "SELECT SUM(winner_goals) FROM games")
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$winner_goals"

echo -e "\nTotal number of goals in all games from both teams combined:"
#total=`expr $winner_goals + $opponent_goals`
echo $($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games;");

echo -e "\nAverage number of goals in all games from the winning teams:"
echo
echo $($PSQL "SELECT AVG(winner_goals) FROM games;")
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
average=$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games;")
echo $average
echo -e "\nAverage number of goals in all games from both teams:"
average_op=$($PSQL "SELECT ROUND(AVG(opponent_goals),2) FROM games;")
# https://stackoverflow.com/questions/14877797/how-to-sum-two-fields-within-an-sql-query
#echo $(( average_op + average ))
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) AS SUM FROM games;")"

echo -e "\nMost goals scored in a single game by one team:"
echo $($PSQL "select max(winner_goals) from games")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $($PSQL "SELECT COUNT(game_id) from games where winner_goals > 2;")

echo -e "\nWinner of the 2018 tournament team name:"
echo $($PSQL "SELECT teams.name FROM games LEFT JOIN teams ON teams.team_id = games.winner_id WHERE year = 2018 AND round = 'Final';")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo $($PSQL "SELECT name FROM games LEFT JOIN teams on games.winner_id=teams.team_id OR games.opponent_id=team_id where round='Eighth-Final' and year=2014 ORDER BY name")

echo -e "\nList of unique winning team names in the whole data set:"
echo $($PSQL "SELECT DISTINCT teams.name FROM games LEFT JOIN teams ON teams.team_id = games.winner_id ORDER BY name;")

echo -e "\nYear and team name of all the champions:"
echo $($PSQL "SELECT year, teams.name FROM games JOIN teams ON teams.team_id = games.winner_id WHERE round = 'Final' ORDER BY year;")
#echo -e "2014|Germany\n2018|France"


echo -e "\nList of teams that start with 'Co':"
echo $($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%';")
