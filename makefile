wondershaper:
	exit
install:
	install -Dm744 wondershaper /sbin/wondershaper
	install -Dm744 wondershaper.wrapper /usb/bin/wondershaper
	install -Dm644 wondershaper.service /usr/lib/systemd/system/wondershaper.service
	install -Dm644 wondershaper.conf /etc/conf.d/wondershaper.conf
	mkdir -p /etc/conf.d/wondershaper
	cp ./conf.d/* /etc/conf.d/wondershaper
clean:
	rm -f wondershaper
