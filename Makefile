TARGET = iphone:clang:9.2:6.0
THEOS_DEVICE_IP = 192.168.1.122
ARCHS = armv7 arm64
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = removepixivads
removepixivads_FILES = Tweak.xm
removepixivads_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
