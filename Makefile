JENKINS_VERSION ?=2.303.1
IMAGE_NAME = devops/jenkins-master-base-$(JENKINS_VERSION)

MAKE_COMMON ?= ../
include $(MAKE_COMMON)/docker.mk
include $(MAKE_COMMON)/common.mk

$(TARGET)/jenkins-war-$(JENKINS_VERSION).war : 
		@echo "Downloading jenkins war file"
		$(call download, https://get.jenkins.io/war-stable/$(JENKINS_VERSION)/jenkins.war, jenkins-war-$(JENKINS_VERSION).war)
		
prepare : $(TARGET)/jenkins-war-$(JENKINS_VERSION).war