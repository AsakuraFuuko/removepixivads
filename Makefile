TARGET = iphone:latest:7.0
ARCHS = armv7 arm64
THEOS_DEVICE_IP = localhost -p 2222
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = removepixivads
removepixivads_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
