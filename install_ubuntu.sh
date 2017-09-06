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
apt-get install -y python3-dev
apt-get install -y ffmpeg
apt-get install unzip

apt-get install -y build-essential cmake pkg-config libjpeg8-dev \
libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev \
libavdevice-dev libgtk-3-dev libavutil-dev libswscale-dev libavresample-dev libavfilter-dev libgphoto2-dev gfortran

cd ~
# source: http://opencv.org/releases.html
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.3.0.zip
unzip opencv.zip

# source: https://github.com/opencv/opencv_contrib/tree/3.3.0
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.3.0.zip
unzip opencv_contrib.zip

#pyenv
apt-get install -y build-essential libbz2-dev libssl-dev libreadline-dev libsqlite3-dev tk-dev
# optional scientific package headers (for Numpy, Matplotlib, SciPy, etc.)
apt-get install -y libpng-dev libfreetype6-dev
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc

pyenv install 3.6.1
pyenv global 3.6.1
pip install numpy
#pip install gphoto2

cd opencv-3.3.0
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=~/.pyenv/versions/3.6.1/usr/local/ \
-D INSTALL_C_EXAMPLES=OFF \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D BUILD_opencv_python3=ON \
-D BUILD_opencv_legacy=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib-3.3.0/modules \
-D BUILD_EXAMPLES=ON \
-D PYTHON_EXECUTABLE=~/.pyenv/versions/3.6.1/bin/python \
-D PYTHON_LIBRARY=~/.pyenv/versions/3.6.1/lib/libpython3.6m.a \
-D PYTHON_INCLUDE_DIR=~/.pyenv/versions/3.6.1/include/python3.6m \
-D PYTHON_INCLUDE_DIRS=~/.pyenv/versions/3.6.1/include/python3.6m \
-D PYTHON_INCLUDE_DIRS2=~/.pyenv/versions/3.6.1/include/python3.6m \
-D INCLUDE_DIRS=~/.pyenv/versions/3.6.1/include/python3.6m \
-D INCLUDE_DIRS2=~/.pyenv/versions/3.6.1/include/python3.6m \
-D PYTHON_PACKAGES_PATH=~/.pyenv/versions/3.6.1/lib/python3.6/site-packages \
-D PYTHON_NUMPY_INCLUDE_DIR=~/.pyenv/versions/3.6.1/lib/python3.6/site-packages/numpy/core/include ..

make -j 3 install
ldconfig

cd ~/venv/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so cv2.so
cd ~/opencv

python -c 'import cv2; print(cv2.__version__)'
