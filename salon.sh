#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~Welcome to my salon~~\n"

MAIN_MENU() {
  echo -e "\nHow can I help you today?"
  echo -e "\n1) Coloring"
  echo "2) Cut"
  echo "3) Blowdry"
  read SERVICE_ID_SELECTED;

  #if incorrect service id selected
  if [[ $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
  then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #check if customer exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_NAME ]]
    then
      #register first time customers
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      CUSTOMER_REGISTRATION=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    #schedule appointment
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME"
    read SERVICE_TIME

    #book the time of the appointment
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    BOOK_TIME=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    
  else
    MAIN_MENU
  fi

}

MAIN_MENU
