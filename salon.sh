#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only --no-align -c"

MENU() {
  echo -e "\n~~~~~ MY SALON ~~~~~"
  echo "Select service ID:"
  services=$($PSQL "SELECT service_id, name FROM services")
  echo "$services" | while IFS="|" read service_id name; do
    echo "$service_id) $name"
  done
}

GET_SERVICE_ID() {
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    echo "I could not find that service. What would you like today?"
    MENU
    GET_SERVICE_ID
    return
  fi

  id=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $id ]]; then
    echo "I could not find that service. What would you like today?"
    MENU
    GET_SERVICE_ID
  else
    echo "Selected Service ID: $id"
  fi
}

MENU
GET_SERVICE_ID


echo "CUSTOMER Phone: "
read CUSTOMER_PHONE
customer=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE';")
if [[ -z $customer ]]; then
        echo "CUSTOMER_NAME"
        read CUSTOMER_NAME
        $($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi;
echo "SERVICE_TIME"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
$PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
