# It's expected that the user pass in the SSID and PASSWORD as env vars like
# SSID="urnetwork" PASSWORD="urpassword" make build-alpha
build-alpha:
	sudo packer build -var wifi_name="${SSID}" -var wifi_password="${PASSWORD}" alpha-instance.json

build-beta:
	sudo packer build -var wifi_name="${SSID}" -var wifi_password="${PASSWORD}" beta-instance.json

env:
	docker run -it -v /mnt/NRG/Docs/CS/Code/Repos/kluster/output-arm-image/alpha-instance.iso:/sdcard/filesystem.img lukechilds/dockerpi
