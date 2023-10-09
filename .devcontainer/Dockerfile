FROM mcr.microsoft.com/devcontainers/dotnet:0-7.0

ARG SONAR_DIR=/opt/sonarscanner

# Install SonarScanner CLI
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && sudo mkdir -p $SONAR_DIR && cd $SONAR_DIR  \
    && sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
    && sudo unzip sonar-scanner-cli-5.0.1.3006-linux.zip \
    && sudo rm sonar-scanner-cli-5.0.1.3006-linux.zip \
    && sudo chmod +x sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner \
    && sudo ln -s $SONAR_DIR/sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner \
    && sudo curl https://cdn.shiftleft.io/download/sl >/usr/local/bin/sl && chmod a+rx /usr/local/bin/sl
    

