VERSION=${1:-21.7.524}


sudo apt-get install update -y
sudo apt-get install git -y
sudo apt-get install gpg -y
wget https://packages.chef.io/files/stable/chef-workstation/${VERSION}/ubuntu/20.04/chef-workstation_${VERSION}-1_amd64.deb
sudo dpkg -i chef-workstation_${VERSION}-1_amd64.deb
rm -f chef-workstation_${VERSION}-1_amd64.deb
