import cv2

WINDOW_NAME = "Opencv Webcam"

def run():

    cv2.namedWindow(WINDOW_NAME)

    video_capture = cv2.VideoCapture(0)

    while True:
        ret, frame = video_capture.read()
        print(ret, frame.shape)

        cv2.imshow(WINDOW_NAME, frame)
        cv2.waitKey(1)

if __name__ == "__main__":
    run()
