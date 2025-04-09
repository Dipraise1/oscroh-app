#!/bin/bash

echo "===========================================" 
echo "Running Os Motto Hookup on Android" 
echo "===========================================" 
echo

# Check if Android device is connected
flutter devices

# Run on Android
flutter run -d android

# If no Android device is found, suggest using an emulator
if [ $? -ne 0 ]; then
  echo ""
  echo "No Android device detected. Would you like to:"
  echo "1. Run on Chrome web (flutter run -d chrome)"
  echo "2. Try running on iOS again (you need CocoaPods installed)"
  echo ""
  read -p "Enter option (1 or 2): " option
  
  if [ "$option" = "1" ]; then
    flutter run -d chrome
  elif [ "$option" = "2" ]; then
    flutter run -d ios
  else
    echo "Invalid option. Exiting."
  fi
fi 