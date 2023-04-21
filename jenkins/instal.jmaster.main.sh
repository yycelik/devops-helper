echo "#####################################################################################"
echo "#################################### Step 1: Install Java"
sudo apt install openjdk-11-jdk-headless
echo "#####################################################################################"
echo "#################################### Step 2: Install Jenkins Master"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
echo "#####################################################################################"
echo "#################################### Step 3: Get admin pass"
cat /var/lib/jenkins/secrets/initialAdminPassword

