amzn-ami-hvm-2017.03.1.20170623-x86_64-gp2
amzn-ami-hvm-2017.03.1.20170812-x86_64-gp2

#sudo needed from here
cd /root
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
./configure
make
make install

ln -s /usr/local/bin/python3 /usr/bin/
ln -s /usr/local/bin/pip3 /usr/bin/

cd /root

git clone https://github.com/Itseez/opencv_contrib.git
cd opencv_contrib
git checkout 3.3.0
cd ..
git clone https://github.com/Itseez/opencv.git
cd opencv
git checkout 3.3.0
mkdir release
cd release

cd /root
python3 -m venv venv
source venv/bin/activate
pip install numpy

# hack to force python3:
mv /usr/bin/python2.7 /usr/bin/back_python2.7

cd opencv/release

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib/modules \
    -D PYTHON_EXECUTABLE=/root/venv/bin/python3 \
    -D PYTHON_DEFAULT_EXECUTABLE=/root/venv/bin/python3 \
    -D BUILD_opencv_python3=ON \
    -D BUILD_EXAMPLES=ON ..

make
make install

ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so /root/venv/lib/python3.6/site-packages/cv2.so

python -c 'import cv2; print(cv2.__version__)'



