#!/usr/bin/env python3
import paho.mqtt.client as mqtt
import time
import pickle
from collections import namedtuple
from colorama import Fore

Sensor = namedtuple("Sensor", "x y z")

def on_message(client, userdata, message):
    msg = pickle.loads(message.payload)
    # msg = message.payload
    # print("\tmessage received " ,str(message.payload.decode("utf-8")))
    print(f"{Fore.CYAN}{message.topic}{Fore.GREEN}[{len(message.payload)}]{Fore.RESET}: {msg}")
    # print("\tmessage topic=",message.topic)
    # print("\tmessage qos=",message.qos)
    # print("\tmessage retain flag=",message.retain)

client = mqtt.Client("kevin")
client.on_message=on_message

host = "10.0.1.199"
# host = "logan.local"
# host = "localhost"
# host = "mqtt.eclipseprojects.io"
resp = client.connect(host, 8883, 60)

if resp != 0:
    print(f"*** Failed to connect: {resp}")
    exit(1)
print(f">> Success: {resp}")

client.loop_start()
client.subscribe("test")

for i in range(100):
    # msg = f"this is a test {i}" #.encode("utf-8")
    msg = Sensor(i,i/2.,3.*i)
    msg = pickle.dumps(msg)
    client.publish("test", msg)
    time.sleep(0.01)
    # print(">> sent")

client.loop_stop()
