#!/bin/bash

downloadPython() {
    wget "https://www.python.org/ftp/python/${1}/Python-${1}.tgz"
}

installPythonBuildDependencies() {
    sudo apt update
    sudo apt install \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libsqlite3-dev \
        libreadline-dev \
        libffi-dev curl \
        libbz2-dev
}

buildPython() {
    tar -xf "Python-${1}.tgz"
    cd "Python-${1}"
    ./configure --enable-optimizations
    make -j 2
    sudo make altinstall
}

configurePython(){
    echo "See this python versions: https://www.python.org/downloads/"
    read -p "Install Python? (y or n): " installPython;
    if [ "$installPython" != "y" ] && [ "$installPython" != "n" ]; then
        echo "\nPlease insert a valid option."
        configurePython
    else
        if [ "$installPython" = "y" ];
        then
            echo ""
            read -p "Insert a vaid python version: " pythonVersion
            echo $pythonVersion
            downloadPython "$pythonVersion"
            installPythonBuildDependencies
            buildPython "$pythonVersion"
        else
            echo "\nSkiping python installation..."
        fi
    fi
    rm "Python-$pythonVersion.tgz"
}

configurePython