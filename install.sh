amzn-ami-hvm-2017.03.1.20170623-x86_64-gp2

yum update -y
yum -y groupinstall "Development tools"
yum install -y git cmake gcc-c++
yum -y install zlib-devel  # gen'l reqs
yum -y install bzip2-devel openssl-devel ncurses-devel  # gen'l reqs
yum -y install mysql-devel  # req'd to use MySQL with python ('mysql-python' package)
yum -y install libxml2-devel libxslt-devel  # req'd by python package 'lxml'
yum -y install unixODBC-devel  # req'd by python package 'pyodbc'
yum -y install sqlite sqlite-devel xz-devel 
yum -y install readline-devel tk-devel gdbm-devel db4-devel 
yum -y install libpcap-devel xz-devel # you will be sad if you don't install this before compiling python, and later need it.
yum -y install libjpeg-devel


curl https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz | tar -xJ
cd Python-3.6.1/
sudo ./configure
make
sudo make install

ln -s /usr/local/bin/python3 /usr/bin/
ln -s /usr/local/bin/pip3 /usr/bin/

python3 -m venv venv
source venv/bin/activate
pip install numpy

#cd ..
#cp -rf build/numpy/lib/python3.6/site-packages/numpy lambda-package/
#export NUMPY=$PWD/lambda-package/numpy/core/include
#cd build


git clone https://github.com/Itseez/opencv_contrib.git
cd opencv_contrib
git checkout 3.2.0
cd ..
git clone https://github.com/Itseez/opencv.git
cd opencv
git checkout 3.2.0
mkdir release
cd release

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib/modules \
    -D PYTHON_EXECUTABLE=/root/venv/bin/python \
    -D BUILD_EXAMPLES=ON ..

ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so venv/lib/python3.6/site-packages/cv2.so



cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D PYTHON_EXECUTABLE=~/.venv/bin/python \
    -D BUILD_opencv_python3=ON \
    -D BUILD_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/build/opencv_contrib/ \
    -D WITH_V4L=OFF \
    -D PYTHON3_LIBRARY=$(python -c "import re, os.path; print(os.path.normpath(os.path.join(os.path.dirname(re.__file__), '..', 'libpython3.6m.dylib')))") \
    -D PYTHON3_EXECUTABLE=$(which python) \
    -D PYTHON3_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -D PYTHON3_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=~/.venv/lib/python3.6/site-packages/numpy/core/include ..


