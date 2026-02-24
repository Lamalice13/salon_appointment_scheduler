#! /bin/bash

PSQL="psql -U freecodecamp -d salon -A -t -c"


MAIN_MENU() {

  if [[ $1 ]]
    then
      echo -e "\n$1"
  fi

$PSQL "SELECT service_id, name FROM services" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do 
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $SERVICE_NAME ]]
    then
      MAIN_MENU "The service you asked is not available."

    else 
      echo -e "\nEnter your phone number."
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

      if [[ -z $CUSTOMER_NAME ]] 
        then 
          echo -e "\nPlease provide your name"
          read CUSTOMER_NAME
          $PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
        fi 
      
      echo -e "\nHello, $CUSTOMER_NAME. Please choose an appointment time"
      echo -e "10:30"
      echo -e "11:00"
      echo -e "11:30"
      echo -e "12:00"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
      $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  fi


}

MAIN_MENU