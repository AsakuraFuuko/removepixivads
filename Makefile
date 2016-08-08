export TARGET = iphone:clang:9.2:5.0
export THEOS_DEVICE_IP = 192.168.1.122
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = removepixivads
removepixivads_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
