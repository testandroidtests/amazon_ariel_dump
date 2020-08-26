#!/system/bin/sh

ARIEL_PVT_BOARD_ID=000F0010A0000014
ASTON_PVT_BOARD_ID=0012001070000014
LOG=/persistbackup/lock.log

evt_build=`cat /proc/idme/board_id`
boot0_lock=`cat /sys/class/mmc_host/mmc0/mmc0\:0001/block/mmcblk0/mmcblk0boot0/ro_lock`
mmc_lock_disable=`cat /sys/class/mmc_host/mmc0/mmc0\:0001/card_lock_disable`

if [[ "$evt_build" == "$ARIEL_PVT_BOARD_ID" || "$evt_build" == "$ASTON_PVT_BOARD_ID" ]]; then
   if [[ "$boot0_lock" != 2 ]]; then
      echo "Locking boot0 of eMMC..." >> $LOG
      echo 2 > /sys/class/mmc_host/mmc0/mmc0\:0001/block/mmcblk0/mmcblk0boot0/ro_lock
   fi

   if [[ "$mmc_lock_disable" != 1 ]]; then
      echo "Disabling eMMC lock..." >> $LOG
      echo 1 > /sys/class/mmc_host/mmc0/mmc0\:0001/card_lock_disable
   fi
fi
