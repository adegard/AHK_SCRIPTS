import pyautogui
import keyboard
import time
from datetime import datetime
import threading

mouse_speed = 2
record_interval = 0.07  # 70ms
replay_delay = 0.1      # 100ms

script_filename = f"macro_{datetime.now().strftime('%H%M%S')}.py"
recording = True
events = []

print("Recording started. Press Ctrl+D to stop.")

def record_mouse():
    while recording:
        x, y = pyautogui.position()
        events.append(('move', x, y))
        if pyautogui.mouseDown():
            events.append(('click', x, y))
        time.sleep(record_interval)

def record_keys():
    def on_key(event):
        if not recording:
            return
        if event.event_type == 'down' and event.name != 'ctrl':
            events.append(('key', event.name))
    keyboard.hook(on_key)

def save_script(filename):
    with open(filename, 'w') as f:
        f.write("import pyautogui, time\n")
        f.write("import keyboard\n")
        f.write("time.sleep(2)  # Buffer before playback\n")
        for evt in events:
            if evt[0] == 'move':
                f.write(f"pyautogui.moveTo({evt[1]}, {evt[2]}, duration=0.01)\n")
                f.write(f"time.sleep({replay_delay})\n")
            elif evt[0] == 'click':
                f.write(f"pyautogui.click({evt[1]}, {evt[2]})\n")
                f.write(f"time.sleep({replay_delay})\n")
            elif evt[0] == 'key':
                f.write(f"keyboard.write('{evt[1]}')\n")
                f.write(f"time.sleep(0.02)\n")

# Threading to handle simultaneous input recording
keyboard.add_hotkey('ctrl+d', lambda: stop_recording())

def stop_recording():
    global recording
    recording = False
    print("\nRecording stopped.")
    save_script(script_filename)
    print(f"Script saved as {script_filename}")

# Start recording in parallel
threading.Thread(target=record_mouse).start()
record_keys()

# Keep the main thread alive until stopped
while recording:
    time.sleep(0.1)
