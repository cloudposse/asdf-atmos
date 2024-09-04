#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/cloudposse/atmos"
TOOL_NAME="atmos"
TOOL_TEST="atmos version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# Handle GitHub API token if available
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

# Function to detect OS and Architecture
detect_platform() {
	OS=$(uname | tr '[:upper:]' '[:lower:]')
	ARCH=$(uname -m)

	case $ARCH in
	x86_64) ARCH="amd64" ;;
	arm64) ARCH="arm64" ;;
	aarch64) ARCH="arm64" ;;
	*) fail "Architecture $ARCH is not supported." ;;
	esac
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # Adapt this if the version format changes
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	detect_platform # Detect OS and ARCH

	# Construct the download URL based on version, OS, and architecture
	url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${OS}_${ARCH}"

	echo "* Downloading $TOOL_NAME release $version for $OS/$ARCH..."
	curl "${curl_opts[@]}" -o "$filename" -L "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		filename="${TOOL_NAME}_${version}"
		download_release "$version" "$filename"
		mv "$filename" "$install_path/$TOOL_NAME"

		# Make sure it's executable
		chmod +x "$install_path/$TOOL_NAME"

		# Verify the installation
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
