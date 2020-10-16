build:
	sudo packer build -var wifi_name="${SSID}" -var wifi_password="${PASSWORD}" alpha-instance.json

env:
	docker run -it -v /mnt/NRG/Docs/CS/Code/Repos/kluster/output-arm-image/alpha-instance.iso:/sdcard/filesystem.img lukechilds/dockerpi
