#!/usr/bin/env bash

# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  local repo=helm/helm
  curl --silent "https://api.github.com/repos/${repo}/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

version="${1:-latest}"

if [[ "$version" = 'latest' ]]; then
  version=$(get_latest_release)
fi

echo $version
outDir=bin
os=linux
mkdir -p "$outDir"
file="helm-binary-${version}.tar.gz"
curl -s "https://get.helm.sh/helm-${version}-${os}-amd64.tar.gz" -o "${outDir}/${file}"

cd "${outDir}"
tar xvf "${file}"
mv "${os}-amd64/helm" .

rm "${file}"
rm -rf "${os}-amd64"