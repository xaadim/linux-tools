# linux-tools
Some Linux scripts 


## NEXUS
### Delete component

### ENV
- NEXUS_DNS: Nexus DNS. Default nexus.local
- NEXUS_PORT: Nexus port. Default value 8081
- REPO: Name of the repository in Nexus (see here http://DNS_NEXUS:PORT_NEXUS/#browse/browse). Default value docker-public
- FORMAT: The format of the component to remove: maven2, helm, docker. Docker default
- KEYWORD: Search key. Example: sgo/startweb
- EXTRA_SEARCH: additional filtering. Example: group=com.repo&name=com.repo.test&version=x.x.x&... (see here https://help.sonatype.com/repomanager3/integrations/rest-and-integration- api/search-api)
- DRY_RUN: Show only found components
- DELETE: Start deleting found components

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