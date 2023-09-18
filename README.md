# linux-tools
Some Linux scripts 


## NEXUS
### Delete component

docker run -it --rm --name delete-nexus-component \
--env NEXUS_DNS=$NEXUS_DNS \
--env NEXUS_PORT=$NEXUS_PORT \
--env REPO=$REPO \
--env FORMAT=$FORMAT \
--env KEYWORD=$KEYWORD \
--env EXTRA_SEARCH=$EXTRA_SEARCH \
--env DELETE=$DELETE \
--env DRY_RUN=$DRY_RUN \
xaadim:tools/delete-nexus-component:latest