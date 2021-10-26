FROM jenkins/jenkins:lts
USER root
# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins pipeline-utility-steps:2.10.0 gradle:1.37.1 maven-plugin:3.13 jdk-tool:1.5 workflow-aggregator:2.6 git:4.8.2 msbuild:1.30 mstest:1.0.0 octopusdeploy:3.1.6 kubernetes:1.29.2 configuration-as-code:1.52
# Install development tools
RUN apt-get update
RUN apt-get install dnsutils sed vim maven wget curl sudo python3 python3-pip ruby-full ruby-dev php7.4 php-cli php-zip php-dom php-mbstring unzip -y
RUN apt-get install libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb chromium -y
# Install Ruby Bundler
RUN gem install bundler
# Allow jenkins to run sudo with no password
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-7.2-bin.zip
RUN unzip gradle-7.2-bin.zip
RUN mv gradle-7.2 /opt
RUN chmod +x /opt/gradle-7.2/bin/gradle
RUN ln -s /opt/gradle-7.2/bin/gradle /usr/bin/gradle
# Install JDK
RUN wget https://cdn.azul.com/zulu/bin/zulu17.28.13-ca-jdk17.0.0-linux_x64.tar.gz
RUN tar -xzf zulu17.28.13-ca-jdk17.0.0-linux_x64.tar.gz
RUN mv zulu17.28.13-ca-jdk17.0.0-linux_x64 /opt
# Install DotNET Core
RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update; apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-5.0 dotnet-sdk-3.1
RUN apt update && sudo apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && curl -sSfL https://apt.octopus.com/public.key | apt-key add - && sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && apt update && sudo apt install -y octopuscli
# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt update; apt install yarn
# Install PHP Composer
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# Install Go
RUN wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
ENV PATH=/usr/local/go/bin:/root/go/bin:${PATH}
RUN mkdir /usr/share/go
RUN chown jenkins /usr/share/go
ENV GOPATH=/usr/share/go
ENV PATH=/usr/share/go/bin:${PATH}
# Install gitversion
RUN wget https://github.com/GitTools/GitVersion/releases/download/5.7.0/gitversion-linux-x64-5.7.0.tar.gz
RUN mkdir /opt/gitversion
RUN tar -C /opt/gitversion -xzf gitversion-linux-x64-5.7.0.tar.gz
RUN chmod -R 755 /opt/gitversion
ENV PATH=/opt/gitversion:${PATH}
# Disable CSRF
ENV JAVA_OPTS=-Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true
USER jenkins
