#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) COLOR ;;
    3) PERM ;;
    4) STYLE ;;
    5) TRIM ;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
    esac
}

CUT() {
  #set service name
  SERVICE_NAME='cut'
  CUSTOMER_INFO
  APPOINTMENT
}
COLOR() {
  #set service name
  SERVICE_NAME='color'
  CUSTOMER_INFO
  APPOINTMENT
}
PERM() {
  #set service name
  SERVICE_NAME='perm'
  CUSTOMER_INFO
  APPOINTMENT
}
STYLE() {
  #set service name
  SERVICE_NAME='style'
  CUSTOMER_INFO
  APPOINTMENT
}
TRIM() {
  #set service name
  SERVICE_NAME='trim'
  CUSTOMER_INFO
  APPOINTMENT
}

CUSTOMER_INFO() {
  #get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert customer name
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  #get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
}

APPOINTMENT() {
  #set time
  echo -e "\nWhat time would you like your $SERVICE_NAME, $(echo $CUSTOMER_NAME | sed -E  's/^ *| *$//g')?"
  read SERVICE_TIME
  #insert appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E  's/^ *| *$//g')."
}


MAIN_MENU