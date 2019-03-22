FROM cirrusci/android-sdk:28

USER root

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install apt-utils zip \
    && apt-get install -y nodejs build-essential \
    && npm install -g cordova@6.5.0 ionic@2.2.1 typings@1.3.1 \
    && cd $ANDROID_HOME \
    && echo 'Downloading android tools...' \
    && curl -O https://dl.google.com/android/repository/tools_r25.2.3-linux.zip \
    && echo 'Downloading gradle...' \
    && curl -O http://services.gradle.org/distributions/gradle-1.12-all.zip

RUN cd $ANDROID_HOME \
    && echo 'Extracting android tools...' \
    && unzip -o tools_r25.2.3-linux.zip -d  $ANDROID_HOME \
    && rm tools_r25.2.3-linux.zip \
    && rm $ANDROID_HOME/tools/templates/gradle/wrapper/gradle/wrapper/gradle-wrapper.properties \
    && echo 'Fixing api-versions.xml...' \
    && sed 's/init>/init/g' -n $ANDROID_HOME/platform-tools/api/api-versions.xml \
    && unzip $ANDROID_HOME/platform-tools/api/annotations.zip -d  $ANDROID_HOME/platform-tools/api/ \
    && rm $ANDROID_HOME/platform-tools/api/annotations.zip \
    && sed 's/Callback</Callback&lt;/g' -n $ANDROID_HOME/platform-tools/api/android/accounts/annotations.xml \
    && sed 's/>,/&gt;,/g' -n $ANDROID_HOME/platform-tools/api/android/accounts/annotations.xml \
    && head -20 $ANDROID_HOME/platform-tools/api/android/accounts/annotations.xml \
    && zip -r $ANDROID_HOME/platform-tools/api/annotations.zip $ANDROID_HOME/platform-tools/api/android
COPY gradle/gradle-wrapper.properties $ANDROID_HOME/tools/templates/gradle/wrapper/gradle/wrapper/
USER cirrus
    