#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(call my-dir)

okhttp_common_src_files := $(call all-java-files-under,okhttp/src/main/java)
okhttp_common_src_files += $(call all-java-files-under,okio/src/main/java)
okhttp_system_src_files := $(filter-out %/Platform.java, $(okhttp_common_src_files))
okhttp_system_src_files += $(call all-java-files-under, android/main/java)

okhttp_test_src_files := $(call all-java-files-under,okhttp-tests/src/test/java)
okhttp_test_src_files += $(call all-java-files-under,mockwebserver/src/main/java)
okhttp_test_src_files := $(filter-out mockwebserver/src/main/java/com/squareup/okhttp/internal/spdy/SpdyServer.java, $(okhttp_test_src_files))

include $(CLEAR_VARS)
LOCAL_MODULE := okhttp
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(okhttp_system_src_files)
LOCAL_JAVACFLAGS := -encoding UTF-8
LOCAL_JARJAR_RULES := $(LOCAL_PATH)/jarjar-rules.txt
LOCAL_JAVA_LIBRARIES := core-libart conscrypt
LOCAL_NO_STANDARD_LIBRARIES := true
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_JAVA_LIBRARY)

# static version of okhttp for inclusion in apps targeting older releases
include $(CLEAR_VARS)
LOCAL_MODULE := okhttp-static
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(okhttp_common_src_files)
LOCAL_JAVACFLAGS := -encoding UTF-8
# This is set when building apps - exclude platform targets.
ifneq ($(TARGET_BUILD_APPS),)
    LOCAL_SDK_VERSION := 11
else
    LOCAL_JAVA_LIBRARIES := core-libart
    LOCAL_NO_STANDARD_LIBRARIES := true
endif
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_STATIC_JAVA_LIBRARY)

# non-jarjar'd version of okhttp to compile the tests against
include $(CLEAR_VARS)
LOCAL_MODULE := okhttp-nojarjar
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(okhttp_system_src_files)
LOCAL_JAVACFLAGS := -encoding UTF-8
LOCAL_JAVA_LIBRARIES := core-libart conscrypt
LOCAL_NO_STANDARD_LIBRARIES := true
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_STATIC_JAVA_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := okhttp-tests-nojarjar
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(okhttp_test_src_files)
LOCAL_JAVACFLAGS := -encoding UTF-8
LOCAL_JAVA_LIBRARIES := core-libart okhttp-nojarjar junit4-target bouncycastle-nojarjar
LOCAL_NO_STANDARD_LIBRARIES := true
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_STATIC_JAVA_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := okhttp-hostdex
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := $(okhttp_system_src_files)
LOCAL_JAVACFLAGS := -encoding UTF-8
LOCAL_JARJAR_RULES := $(LOCAL_PATH)/jarjar-rules.txt
LOCAL_JAVA_LIBRARIES := conscrypt-hostdex
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_HOST_DALVIK_JAVA_LIBRARY)
