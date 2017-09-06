#!/usr/bin/env bash
#run as root
if [ "`/usr/bin/whoami`" != "root" ]; then
    echo "You need to execute this script as root."
    exit 1
fi

add-apt-repository -y ppa:jonathonf/python-3.6
apt-get update -y
apt-get upgrade -y

apt-get install -y python3.6
apt-get install -y python3-pip
apt-get install -y ffmpeg
apt-get install unzip

apt-get install -y build-essential cmake pkg-config libjpeg8-dev \
libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libavdevice-dev libgtk-3-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev libgphoto2-dev gfortran

cd ~
mkdir opencv
cd opencv
# source: http://opencv.org/releases.html
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.3.0.zip
unzip opencv.zip

# source: https://github.com/opencv/opencv_contrib/tree/3.3.0
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.3.0.zip
unzip opencv_contrib.zip

pip3 install --upgrade pip
pip3 install virtualenv
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate
pip install numpy
#pip install gphoto2

cd opencv-3.3.0
mkdir build
cd build

# hack to force python3:
mv /usr/bin/python2.7 /usr/bin/back_python2.7

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/root/opencv/opencv_contrib-3.3.0/modules \
    -D PYTHON_EXECUTABLE=/root/python3/bin/python \
    -D BUILD_EXAMPLES=ON ..


make -j 3 install
ldconfig

cd ~/opencv/python3/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so cv2.so
cd ~/opencv

python -c 'import cv2; print(cv2.__version__)'
