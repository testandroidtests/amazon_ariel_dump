#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/mtk-msdc.0/by-name/recovery:6430720:7a40274105eef89586a075da293e93c6d7a809d4; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/platform/mtk-msdc.0/by-name/boot:5971968:341c965623b226aac18fdc11d3643eb08126ecdb EMMC:/dev/block/platform/mtk-msdc.0/by-name/recovery 7a40274105eef89586a075da293e93c6d7a809d4 6430720 341c965623b226aac18fdc11d3643eb08126ecdb:/system/recovery-from-boot.p && echo "
Installing new recovery image: succeeded
" >> /cache/recovery/log || echo "
Installing new recovery image: failed
" >> /cache/recovery/log
else
  log -t recovery "Recovery image already installed"
fi
