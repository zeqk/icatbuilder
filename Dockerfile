FROM cirrusci/android-sdk:28

USER root
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install apt-utils \
    && apt-get install -y nodejs build-essential \
    && npm install -g cordova@6.5.0 ionic@2.2.1 typings@1.3.1 \
    && cd $ANDROID_HOME \
    && curl -O https://dl.google.com/android/repository/tools_r25.2.3-linux.zip \
    && unzip -o tools_r25.2.3-linux.zip \
    && rm tools_r25.2.3-linux.zip
USER cirrus