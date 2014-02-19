cd codebase

if [ -d "ticckle_backend" ]
then
  echo 'ticckle_backend repository exists, skipping initialization'
else
  echo 'Setting up ticckle_backend repository'
  source ~/.rvm/scripts/rvm
  git clone git@github.com:ticckle/ticckle_backend.git
  cd ticckle_backend
  git fetch
  git checkout develop
  gem install bundler
  bundle install
fi

