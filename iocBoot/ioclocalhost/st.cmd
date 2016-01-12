#!../../bin/linux-x86_64/simioc

## You may have to change simioc to something else
## everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase("../../dbd/simioc.dbd",0,0)
simioc_registerRecordDeviceDriver(pdbbase) 

## Load record instances
dbLoadRecords("../../db/simioc.db","user=dchabot")

iocInit()

## Start any sequence programs
#seq sncsimioc,"user=dchabot"
