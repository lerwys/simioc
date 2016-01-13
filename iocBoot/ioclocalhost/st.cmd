#!../../bin/linux-x86_64/simioc

## You may have to change motorSim to something else
## everywhere it appears in this file

< envPaths

epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")          
epicsEnvSet("EPICS_CA_ADDR_LIST", "127.0.0.1")

epicsEnvSet("PREFIX", "13SIM1:")
epicsEnvSet("PORT",   "SIM1")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "1024")
epicsEnvSet("YSIZE",  "1024")
epicsEnvSet("NCHANS", "2048")

cd ${TOP}

## Register all support components
dbLoadDatabase("dbd/simioc.dbd",0,0)
simioc_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadTemplate("db/sensor.substitutions")
dbLoadTemplate("db/motorSim.substitutions")
dbLoadRecords("db/fakemotor.db", "Sys=XF:31IDA-OP,Dev={Tbl-Ax:FakeMtr},Mtr=XF:31IDA-OP{Tbl-Ax:X1}Mtr")

# Create simulated motors: ( start card , start axis , low limit, high limit, home posn, # cards, # axes to setup)
motorSimCreate( 0, 0, -32000, 32000, 0, 1, 6 )
# Setup the Asyn layer (portname, low-level driver drvet name, card, number of axes on card)
drvAsynMotorConfigure("motorSim1", "motorSim", 0, 6)


# setup all the simDetector crud
simDetectorConfig("$(PORT)", $(XSIZE), $(YSIZE), 1, 0, 0)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/ADBase.template",     "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/simDetector.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin, set it to get data from first simDetector driver.
NDStdArraysConfigure("Image1", 3, 0, "$(PORT)", 0)
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDPluginBase.template","P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")

# This creates a waveform large enough for 1024x1024x3 (e.g. RGB color) arrays.
# This waveform only allows transporting 8-bit images
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,TYPE=Int8,FTVL=UCHAR,NELEMENTS=3145728")
# This waveform only allows transporting 16-bit images
#dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,TYPE=Int16,FTVL=USHORT,NELEMENTS=3145728")
# This waveform allows transporting 32-bit images
#dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,TYPE=Int32,FTVL=LONG,NELEMENTS=3145728")

# This loads a database to tie the ROI size to the detector readout size
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROI_sync.template", "P=$(PREFIX),CAM=cam1:,ROI=ROI1:")
dbLoadRecords("$(AREA_DETECTOR)/ADApp/Db/NDROI_sync.template", "P=$(PREFIX),CAM=cam1:,ROI=ROI2:")

# Load all other plugins using commonPlugins.cmd
< ${TOP}/iocBoot/commonPlugins.cmd

## autosave/restore machinery
#save_restoreSet_Debug(0)
#save_restoreSet_IncompleteSetsOk(1)
#save_restoreSet_DatedBackupFiles(1)
#
#set_savefile_path("${TOP}/as","/save")
#set_requestfile_path("${TOP}/as","/req")
#
#set_pass0_restoreFile("info_positions.sav")
#set_pass0_restoreFile("info_settings.sav")
#set_pass1_restoreFile("info_settings.sav")

cd ${TOP}/iocBoot/${IOC}
iocInit()

## more autosave/restore machinery
cd ${TOP}/as/req
#makeAutosaveFiles()
#create_monitor_set("info_positions.req", 5 , "")
#create_monitor_set("info_settings.req", 15 , "")

