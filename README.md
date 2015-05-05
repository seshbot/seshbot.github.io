Setting up seshbot for a new box (e.g., vagrant)
-----

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install git curl vim default-jdk
    curl -L https://get.rvm.io | bash -s stable
    source /home/vagrant/.rvm/scripts/rvm
    rvm install 1.9.3
    rvm use 1.9.3
    rvm rubygems current
    git clone -b source https://github.com/seshbot/seshbot.github.io.git seshbot
    cd seshbot/
    git clone https://github.com/seshbot/seshbot.github.io.git _deploy
    gem install bundler
    bundle install
    rake generate
    rake deploy
