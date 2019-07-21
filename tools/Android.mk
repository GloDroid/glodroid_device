sdcard: droid
	$(call pretty,"Creating sdcard image...")
	cd $(PRODUCT_OUT) && ./gensdimg.sh
