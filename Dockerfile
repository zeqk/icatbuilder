FROM cirrusci/android-sdk:25

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
    && unzip $ANDROID_HOME/platform-tools/api/annotations.zip -d  $ANDROID_HOME/platform-tools/api/ \
    && rm $ANDROID_HOME/platform-tools/api/annotations.zip \
    && rm $ANDROID_HOME/tools/templates/gradle/wrapper/gradle/wrapper/gradle-wrapper.properties \
    && echo 'Fixing xml...' \    
    && sed 's/init>/init/g' -n $ANDROID_HOME/platform-tools/api/api-versions.xml \
    && find . -name "*.xml" -type f -print0 | xargs -0 sed -n 's/init>/init/g' \
    && find . -name "*.xml" -type f -print0 | xargs -0 sed -n 's/Callback</Callback&lt;/g' \
    && find . -name "*.xml" -type f -print0 | xargs -0 sed -n 's/>,/&gt;,/g' \
    && zip -r $ANDROID_HOME/platform-tools/api/annotations.zip $ANDROID_HOME/platform-tools/api/android \
    && chmod 775 $ANDROID_HOME/gradle-1.12-all.zip \
    && export PATH=$PATH:/opt/android-sdk-linux/platform-tools/:/opt/android-sdk-linux/tools/:/opt/android-sdk-linux/build-tools/28.0.3/
COPY gradle/gradle-wrapper.properties $ANDROID_HOME/tools/templates/gradle/wrapper/gradle/wrapper/
USER cirrus
    