################################################################################
#
#  sb-signing-utils
#
################################################################################

#SB_SIGNING_UTILS_SITE ?= $(call github,open-power,sb-signing-utils,$(SB_SIGNING_UTILS_VERSION))
# Temporarily point to internal GHE repo until public repo available
SB_SIGNING_UTILS_SITE ?= git@github.ibm.com:cjengel/sb-signing-utils
SB_SIGNING_UTILS_SITE_METHOD = git

SB_SIGNING_UTILS_LICENSE = Apache-2.0
SB_SIGNING_UTILS_LICENSE_FILES = LICENSE
#SB_SIGNING_UTILS_VERSION ?= 5af9cc4172c8828d42b73750b55eca917bbf5276
SB_SIGNING_UTILS_VERSION ?= 8f3c9ca01780498c9d818e4150102359ca2dc756

HOST_SB_SIGNING_UTILS_DEPENDENCIES = host-openssl host-mlca_framework

ifeq ($(BR2_OPENPOWER_SECUREBOOT_SIGN_MODE),production)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
else ifeq ($(BR2_OPENPOWER_SECUREBOOT_KEY_TRANSITION_TO_PROD),y)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
else ifeq ($(BR2_OPENPOWER_P10_SECUREBOOT_SIGN_MODE),production)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
else ifeq ($(BR2_OPENPOWER_P10_SECUREBOOT_KEY_TRANSITION_TO_PROD),y)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
endif

HOST_SB_SIGNING_UTILS_AUTORECONF = YES
HOST_SB_SIGNING_UTILS_AUTORECONF_OPTS = -i
HOST_SB_SIGNING_UTILS_CONF_OPTS = --enable-sign-v2

define HOST_SB_SIGNING_UTILS_COPY_FILES
	$(INSTALL) -m 0755 $(@D)/crtSignedContainer.sh $(HOST_DIR)/usr/bin/
endef

SB_SIGNING_UTILS_KEY_SRC_PATH=$(BR2_EXTERNAL)/package/sb-signing-utils/keys
SB_SIGNING_UTILS_KEY_DST_PATH=$(HOST_DIR)/etc/keys

define HOST_SB_SIGNING_UTILS_COPY_KEYS
	$(INSTALL) -d -m 0755 $(SB_SIGNING_UTILS_KEY_DST_PATH)
	$(INSTALL) -m 0755 $(SB_SIGNING_UTILS_KEY_SRC_PATH)/* \
		$(SB_SIGNING_UTILS_KEY_DST_PATH)
endef

HOST_SB_SIGNING_UTILS_POST_INSTALL_HOOKS += HOST_SB_SIGNING_UTILS_COPY_FILES
HOST_SB_SIGNING_UTILS_POST_INSTALL_HOOKS += HOST_SB_SIGNING_UTILS_COPY_KEYS

$(eval $(host-autotools-package))
