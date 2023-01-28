
include glodroid/configuration/common/base/board.mk

include glodroid/configuration/common/other-hals/board.mk

ifeq ($(GD_NO_DEFAULT_BLUETOOTH),)
include glodroid/configuration/common/bluetooth/board.mk
endif

ifeq ($(GD_NO_DEFAULT_GRAPHICS),)
include glodroid/configuration/common/graphics/board.mk
endif

ifeq ($(GD_NO_DEFAULT_CODECS),)
include glodroid/configuration/common/codecs/board.mk
endif

ifeq ($(GD_NO_DEFAULT_CAMERA),)
include glodroid/configuration/common/camera/board.mk
endif

ifeq ($(GD_NO_DEFAULT_MODEM),)
include glodroid/configuration/common/modem/board.mk
endif

ifeq ($(GD_NO_DEFAULT_AUDIO),)
include glodroid/configuration/common/audio/board.mk
endif

ifeq ($(GD_NO_DEFAULT_WIFI),)
include glodroid/configuration/common/wifi/board.mk
endif
