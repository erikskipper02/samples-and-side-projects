# importing the required packages 
import pyautogui 
import cv2 as cv
import numpy as np
  
# Specify name of Output file 
filename = "screen_recording.avi"

# Specify video codec 
fourcc = cv.VideoWriter_fourcc(*"XVID")
  
# Specify frames rate. We can choose any value and experiment with it 
fps = 20.0

# Specify resolution 
resolution = pyautogui.size()
  
# Creating a VideoWriter object 
out = cv.VideoWriter(filename, fourcc, fps, resolution) 
  
# Create an Empty window 
cv.namedWindow("Live", cv.WINDOW_NORMAL) 
  
# Resize this window 
cv.resizeWindow("Live", 480, 270) 
  
while True: 
    # Take screenshot using PyAutoGUI 
    img = pyautogui.screenshot() 
  
    # Convert the screenshot to a numpy array 
    frame = np.array(img) 
  
    # Convert it from BGR(Blue, Green, Red) to 
    # RGB(Red, Green, Blue) 
    frame = cv.cvtColor(frame, cv.COLOR_BGR2RGB) 
  
    # Write it to the output file 
    out.write(frame) 
      
    # Optional: Display the recording screen 
    cv.imshow('Live', frame) 
      
    # Stop recording when we press 'q' 
    if cv.waitKey(1) == ord('q'): 
        break
  
# Release the Video writer 
out.release() 
  
# Destroy all windows 
cv.destroyAllWindows()