TARGET = iphone:clang:latest:6.0

include theos/makefiles/common.mk

TWEAK_NAME = BTNotificationEnabler BTNotificationPreferences

BTNotificationEnabler_FILES = BulletinHandler.xm
BTNotificationEnabler_CFLAGS = -include Prefix.pch
BTNotificationEnabler_PRIVATE_FRAMEWORKS = BulletinBoard

BTNotificationPreferences_FILES = BulletinBoardAppDetailController.xm
BTNotificationPreferences_CFLAGS = -include Prefix.pch
BTNotificationPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
