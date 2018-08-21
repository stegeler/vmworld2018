#Used to Start the VMworld 2018 Concourse Pipeline
#!/bin/bash

./fly -t vsphereacct set-pipeline --pipeline acctctl --config pipeline.yml

if [ $? -eq 0 ]; then
	./fly -t vsphereacct unpause-pipeline --pipeline acctctl
fi
