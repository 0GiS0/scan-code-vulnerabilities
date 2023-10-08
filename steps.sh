echo "SonarQube portal: http://localhost:9000"
echo "SonarQube user: admin"
echo "SonarQube password: admin"

# Load environment variables
set -o allexport; source .env; set +o allexport

#####################################################################################################
############################################# .NET Code #############################################
#####################################################################################################

# Clone repo
git clone https://github.com/ShiftLeftSecurity/shiftleft-csharp-demo.git && cd shiftleft-csharp-demo/netcoreWebapi


### sonarQube ###

# Configure the tool
dotnet sonarscanner begin /k:"shiftleft-csharp-demo"\
 /d:sonar.host.url="http://localhost:9000"\
   /d:sonar.login="$DOTNET_SONARQUBE_TOKEN"

# Build the code
dotnet build

# Execute sonarQube for .NET
dotnet sonarscanner end /d:sonar.login="$DOTNET_SONARQUBE_TOKEN"

### snyk ###
snyk auth
snyk code test --org=aac5cb6b-19db-452c-8d36-1cb4e0d91c6c

### sast-scan tool ###
export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-csharp-demo --csharp --wait netcoreWebapi.csproj

cd ../..

#####################################################################################################
############################################# Java Code #############################################
#####################################################################################################

git clone https://github.com/ShiftLeftSecurity/shiftleft-java-demo.git && cd shiftleft-java-demo

# Compile the code with maven
mvn clean package

sonar-scanner \
  -Dsonar.projectKey=shiftleft-java-demo \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$JAVA_SONARQUBE_TOKEN

# Or Execute sonarQube for Java
# ./gradlew sonar \
#   -Dsonar.projectKey=tour-of-heroes-api-java \
#   -Dsonar.host.url=http://localhost:9000 \
#   -Dsonar.login=$JAVA_SONARQUBE_TOKEN

cd ..

### snyk ###
snyk auth
snyk code test

### sast-scan tool ###
export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-csharp-demo --java --wait target/hello-shiftleft-0.0.1.jar

cd ..

#####################################################################################################
############################################# Python Code #############################################
#####################################################################################################

git clone https://github.com/ShiftLeftSecurity/shiftleft-python-demo.git && cd shiftleft-python-demo

# Execute sonarQube for Python
sonar-scanner \
  -Dsonar.projectKey=shiftleft-python-demo \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$PYTHON_SONARQUBE_TOKEN

### snyk ###
snyk auth
snyk code test

### sast-scan tool ###
export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-python-demo --python --wait

#####################################################################################################
############################################# Go Code ###############################################
#####################################################################################################

git clone https://github.com/ShiftLeftSecurity/shiftleft-go-example.git && cd shiftleft-go-example

sonar-scanner \
  -Dsonar.projectKey=shiftleft-go-example \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$GO_SONARQUBE_TOKEN

### snyk ###
snyk auth
snyk code test

### sast-scan tool ###
export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-go-example --go --wait