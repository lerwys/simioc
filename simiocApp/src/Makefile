TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = simioc
# simioc.dbd will be created and installed
DBD += simioc.dbd

# simioc.dbd will be made up from these files:
simioc_DBD += base.dbd

# Include dbd files from all support applications:
simioc_DBD += asyn.dbd
simioc_DBD += motorSupport.dbd
simioc_DBD += devSoftMotor.dbd
simioc_DBD += motorRecord.dbd
simioc_DBD += motorSimSupport.dbd
simioc_DBD += asSupport.dbd
simioc_DBD += calcSupport.dbd

# Add all the support libraries needed by this IOC
simioc_LIBS += softMotor motorSimSupport motor asyn autosave calc

# simioc_registerRecordDeviceDriver.cpp derives from simioc.dbd
simioc_SRCS += simioc_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
simioc_SRCS_DEFAULT += simiocMain.cpp
simioc_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#simioc_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
simioc_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

