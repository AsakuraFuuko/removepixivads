TARGET = iphone:clang:9.2:6.0
ARCHS = armv7 arm64
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = removepixivads
removepixivads_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
