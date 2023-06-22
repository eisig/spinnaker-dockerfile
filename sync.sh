# FROM_PREFIX=us-docker.pkg.dev/spinnaker-community/docker
# TO_PERFIX=docker.pkg.github.com/${{ github.repository }}
BOM='1.31.0.yaml'

FROM_PREFIX=$1
TO_PERFIX=$2

#1.30.1
DOCKER_IMAGES=(
echo
clouddriver
deck
fiat
front50
gate
igor
orca
rosco
)

set -x

function read_version() {
    local name=$1
    local version=$(yq < "bom/${BOM}" | yq ".services.${name}.version") 
    echo $version
}

for name in "${DOCKER_IMAGES[@]}"; do
    echo $name
    version=$(read_version $name)
    asset="${name}:${version}"
    docker pull "$FROM_PREFIX/$asset"
    docker tag $FROM_PREFIX/$asset $TO_PERFIX/$asset 
    docker push $TO_PERFIX/$asset  
done

# docker pull us-docker.pkg.dev/spinnaker-community/redis/redis-cluster:v2
# docker tag us-docker.pkg.dev/spinnaker-community/redis/redis-cluster:v2 $TO_PERFIX/redis-cluster:v2
# docker push $TO_PERFIX/redis-cluster:v2
