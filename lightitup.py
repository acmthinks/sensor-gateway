import sys
from time import sleep 
import RPi.GPIO as GPIO

pin1=11

#setup the mode in which to refer to the pins
GPIO.setmode (GPIO.BOARD)

#initialize the pins
GPIO.setup(pin1, GPIO.OUT)

GPIO.output(pin1, True)

sleep(1)

GPIO.output(pin1, False)
GPIO.cleanup()
