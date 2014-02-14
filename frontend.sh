if [ -d "ticckle_frontend" ]
then
  echo 'ticckle_frontend repository exists, skipping initialization'
else
  echo 'Setting up ticckle_frontend repository'
  git clone git@github.com:ticckle/ticckle_frontend.git
  cd ticckle_frontend
  git fetch
  git checkout develop
  gem install compass
  gem install sass
  npm install
  sudo npm install bower --global
  bower install
  sudo npm install grunt-cli --global
fi

