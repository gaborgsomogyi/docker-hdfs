#!/bin/bash

current_dir=$(pwd)

. "${current_dir}/network.sh"

NETWORK=delegation-token-network
create_network_if_not_exists "${NETWORK}"
docker run -it --cap-add={DAC_READ_SEARCH,SYS_NICE} --hostname=hdfs --name=hdfs --network "${NETWORK}" --rm --mount type=bind,source="${HOME}"/share,target=/share -p 9000:9000 gaborgsomogyi/hdfs:latest
