#!/system/bin/sh

KB_EKKB_EVT1=/data/key_provisioning/KB_EKKB_EVT1
KB_EKKB=/data/key_provisioning/KB_EKKB_EVT2
KB_PM=/data/key_provisioning/KB_PM_EVT2
KB_PD_EVT1=/data/key_provisioning/KB_PD_EVT1
ARIEL_EVT1_BOARD_ID=000F00102
ARIEL_EVT1_1_BOARD_ID=000F00103
ASTON_PROTO_BOARD_ID=001200100000
DRMDBGTOOL=/system/bin/drmkeydebug
LOG=/persistbackup/drmkey_operation.log

evt_build=`cat /proc/idme/board_id`
PARTITION_KB=`$DRMDBGTOOL q`

if [[ "$evt_build" == "$ARIEL_EVT1_BOARD_ID"* || "$evt_build" == "$ARIEL_EVT1_1_BOARD_ID"* ||
      "$evt_build" == "$ASTON_PROTO_BOARD_ID"* ]]; then
   #echo "This is an Ariel EVT1 or Aston proto." >> $LOG
   if [[ -f $KB_EKKB_EVT1 ]]; then
      mv $KB_EKKB_EVT1 /data/key_provisioning/FORCE_KB_EKKB
      mv $KB_PM /data/key_provisioning/KB_PM
      $DRMDBGTOOL i KB_EKKB
      $DRMDBGTOOL i KB_PM
   fi
   if [[ -f $KB_EKKB ]]; then
      rm $KB_EKKB
   fi
   if [[ -f $KB_PD_EVT1 ]]; then
      mv $KB_PD_EVT1 /data/key_provisioning/KB_PD
      $DRMDBGTOOL i KB_PD
   fi
else
   echo "This is not an Ariel EVT1 nor Aston proto."
   if [[ "$PARTITION_KB" == *"EKKB"* && "$PARTITION_KB" == *"PLAYREADY_BGROUPCERT"* &&
         "$PARTITION_KB" == *"PLAYREADY_ZGPRIV"* && "$PARTITION_KB" == *"HDCP_1X_TX"* &&
         "$PARTITION_KB" == *"WIDEVINE"* && "$PARTITION_KB" == *"DEVICE_RSA_KEYPAIR"* ]]; then
	echo "All key blocks exist."
   else
	echo "Some key blocks are missing, so we are doing re-provisioning."
	 $DRMDBGTOOL e f
	 $DRMDBGTOOL e o
	 idme copy KB /dev/block/mmcblk0p8
   fi
   if [[ -f $KB_EKKB_EVT1 ]]; then
      rm $KB_EKKB_EVT1
   fi
   if [[ -f $KB_EKKB ]]; then
      rm $KB_EKKB
   fi
   if [[ -f $KB_PD_EVT1 ]]; then
      rm $KB_PD_EVT1
   fi
fi

PARTITION_KB=`$DRMDBGTOOL q`
if [[ "$PARTITION_KB" == *"LEK"* ]]; then
   if [[ -f $KB_PM ]]; then
      rm $KB_PM
   fi
else
   echo "LEK is not provisioned, provisioning KB_PM now."
   if [[ -f $KB_PM ]]; then
      mv $KB_PM /data/key_provisioning/FORCE_KB_PM
      $DRMDBGTOOL i KB_PM
    echo "Done provisioning KB_PM."
   else
    echo "KB_PM doesn't exist, failed provisioning LEK."
   fi
fi
