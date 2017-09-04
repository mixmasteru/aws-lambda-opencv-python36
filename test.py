import cv2
import numpy as np

# Create a VideoCapture object
cap = cv2.VideoCapture('vtest2.avi')

# Check if camera opened successfully
if (cap.isOpened() == False):
  print("Unable to read camera feed")

# Default resolutions of the frame are obtained.The default resolutions are system dependent.
# We convert the resolutions from float to integer.
frame_width = int(cap.get(3))
frame_height = int(cap.get(4))

# Define the codec and create VideoWriter object.The output is stored in 'outpy.avi' file.
out = cv2.VideoWriter('output.avi',cv2.VideoWriter_fourcc('H','2','6','4'), 10, (frame_width,frame_height))

n=0
while(True):
  ret, frame = cap.read()

  if ret == True:
    n+=1
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    backtorgb = cv2.cvtColor(gray,cv2.COLOR_GRAY2RGB)
    # Write the frame into the file 'output.avi'
    out.write(backtorgb)
    print("\rframe:"+str(n), end='', flush=True)
  # Break the loop
  else:
    break 

# When everything done, release the video capture and video write objects
cap.release()
out.release()
