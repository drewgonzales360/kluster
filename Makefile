# It's expected that the user pass in the SSID and PASSWORD as env vars like
# SSID="urnetwork" PASSWORD="urpassword" make build-alpha
build-alpha:
	sudo packer build \
		-var wifi_name="${SSID}" \
		-var wifi_password="${PASSWORD}" \
		-var git_branch="$(shell git branch --show-current)" \
		-var git_hash="$(shell git rev-parse HEAD)" \
		alpha-instance.json

build-beta:
	sudo packer build \
		-var wifi_name="${SSID}" \
		-var wifi_password="${PASSWORD}" \
		-var git_branch="$(shell git branch --show-current)" \
		-var git_hash="$(shell git rev-parse HEAD)" \
		beta-instance.json
