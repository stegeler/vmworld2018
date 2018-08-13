#Used to Start the VMworld 2018 Concourse Pipeline
#!/bin/bash

fly -t main set-pipeline --pipeline acctctl --config pipeline.yml

if [ $? -eq 0 ]; then
	fly -t main unpause-pipeline --pipeline build-go-winery
fi
