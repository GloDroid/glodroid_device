sdcard: droid
	$(call pretty,"Creating sdcard image...")
	cd $(PRODUCT_OUT) && PATH=/sbin:/bin:/usr/bin:$$PATH ./gensdimg.sh
