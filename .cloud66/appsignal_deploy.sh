last_commit=$(git rev-parse HEAD)
author=$(git --no-pager show -s --format='%an <%ae>' $last_commit)
bundle exec appsignal notify_of_deploy --revision=$last_commit --user=$author --environment=$RACK_ENV 
