#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DIR="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR=$(readlink -f $DIR)

source $BASE_DIR/config-run.sh
source $BASE_DIR/env.sh 

if [ $ENABLE_SSL = true ]; then
  create_hivemr3_ssl_certificate $BASE_DIR/ats-key
fi

sudo docker run \
  --rm \
  --name docker-ats \
  --publish 10.1.91.17:8188:8188 \
  --publish 10.1.91.17:8190:8190 \
  --env ATS_SECRET_KEY=$ATS_SECRET_KEY \
  --volume $BASE_DIR/env.sh:/opt/mr3-run/ats/env.sh:ro \
  --volume $BASE_DIR/ats-conf:/opt/mr3-run/ats/conf:ro \
  --volume $BASE_DIR/ats-key:/opt/mr3-run/ats/key:ro \
  --volume /tmp/timeline-docker:/opt/mr3-run/ats/work-dir \
  $DOCKER_ATS_BUILD_IMG \
  /opt/mr3-run/ats/timeline-service.sh
