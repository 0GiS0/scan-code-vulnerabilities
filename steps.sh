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

### Snyk ###

snyk auth
snyk code test --json > snyk-report.json
# Use snyk-to-html
snyk-to-html -i  snyk-report.json -o snyk-report.html

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

### sonarQube ###

sonar-scanner \
  -Dsonar.projectKey=shiftleft-java-demo \
  -Dsonar.filesize.limit=100 \
  -Dsonar.java.binaries=target/classes \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$JAVA_SONARQUBE_TOKEN

# Or Execute sonarQube for Java
# ./gradlew sonar \
#   -Dsonar.projectKey=tour-of-heroes-api-java \
#   -Dsonar.host.url=http://localhost:9000 \
#   -Dsonar.login=$JAVA_SONARQUBE_TOKEN

cd ..

### Snyk ###

export SNYK_TOKEN=$SNYK_TOKEN
snyk code test

### sast-scan tool ###

export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-java-demo --java --wait target/*.jar

cd ..

#####################################################################################################
############################################# Python Code #############################################
#####################################################################################################

git clone https://github.com/ShiftLeftSecurity/shiftleft-python-demo.git && cd shiftleft-python-demo

### sonarQube ###

sonar-scanner \
  -Dsonar.projectKey=shiftleft-python-demo \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$PYTHON_SONARQUBE_TOKEN

### Snyk ###

export SNYK_TOKEN=$SNYK_TOKEN
snyk code test

### sast-scan tool ###

export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-python-demo --python --wait

cd ..
#####################################################################################################
############################################# Go Code ###############################################
#####################################################################################################

git clone https://github.com/ShiftLeftSecurity/shiftleft-go-example.git && cd shiftleft-go-example

go build

### sonarQube ###

sonar-scanner \
  -Dsonar.projectKey=shiftleft-go-example \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=$GO_SONARQUBE_TOKEN

### Snyk ###

snyk auth
snyk code test

### sast-scan tool ###

export SHIFTLEFT_ACCESS_TOKEN=$SL_TOKEN
sl analyze --app shiftleft-go-example --go --wait