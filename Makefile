TARGET = iphone:clang:latest:6.0

include theos/makefiles/common.mk

TWEAK_NAME = BTNotificationEnabler BTNotificationPreferences

BTNotificationEnabler_FILES = BulletinHandler.xm

BTNotificationPreferences_FILES = BulletinBoardAppDetailController.xm
BTNotificationPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
