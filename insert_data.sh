#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    echo $WINNER $OPPONENT
#get winner team id
    W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
#get opponent team id
    O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#if winner team id does not exist
    if [[ -z $W_TEAM_ID ]]
    then
#add team
      $PSQL "INSERT INTO teams(name) values('$WINNER')"
#get winner team id
      W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
#if opponent team id does not exist
    if [[ -z $O_TEAM_ID ]]
    then
#add team table
      $PSQL "INSERT INTO teams(name) values('$OPPONENT')"
# get opponent team id
      O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
#add entry to games
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $W_TEAM_ID, $O_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
