
include device/glodroid/common/base/board.mk

include device/glodroid/common/other-hals/board.mk

ifeq ($(GD_NO_DEFAULT_BLUETOOTH),)
include device/glodroid/common/bluetooth/board.mk
endif

ifeq ($(GD_NO_DEFAULT_GRAPHICS),)
include device/glodroid/common/graphics/board.mk
endif

ifeq ($(GD_NO_DEFAULT_CODECS),)
include device/glodroid/common/codecs/board.mk
endif

ifeq ($(GD_NO_DEFAULT_CAMERA),)
include device/glodroid/common/camera/board.mk
endif

ifeq ($(GD_NO_DEFAULT_MODEM),)
include device/glodroid/common/modem/board.mk
endif

ifeq ($(GD_NO_DEFAULT_AUDIO),)
include device/glodroid/common/audio/board.mk
endif

ifeq ($(GD_NO_DEFAULT_WIFI),)
include device/glodroid/common/wifi/board.mk
endif
