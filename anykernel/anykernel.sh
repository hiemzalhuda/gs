### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Template Pixel 7 / 7a (lynx) — A/B device, KERNEL-ONLY zip
##
## ============================================================================
## JANGAN pakai BLOCK=auto di Pixel!
##   tools/ak3-core.sh:  auto) parttype="$plistinit $plistboot";;
##   plistinit="init_boot ramdisk"  <- DICOBA DULU
##   plistboot="boot BOOT ..."      <- baru ini
## Jadi BLOCK=auto menulis kernel (~49 MB) ke partisi init_boot (kecil) ->
## ERROR "image larger than partition" dan instalasi ABORT.
## Insiden 16/9: build pertama pakai auto, gagal pas flash di OrangeFox.
##
## Yang benar: BLOCK=boot (eksplisit), biarkan IS_SLOT_DEVICE yang menambahkan
## suffix slot aktif (_a/_b).
## ============================================================================
##
## anykernel.sh bawaan AnyKernel3 juga TIDAK bisa dipakai langsung (contohnya
## Galaxy Nexus: BLOCK=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot,
## IS_SLOT_DEVICE=0) — partisi boot Pixel tidak akan ketemu.

### AnyKernel setup
properties() { '
kernel.string=### blu_spark no-KSU battery (lynx) by hiemz ###
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=lynx
device.name2=Lynx
device.name3=Pixel 7a
supported.versions=13 - 16
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
# BLOCK=boot          -> EKSPLISIT, jangan auto (auto memilih init_boot lebih dulu -> gagal)
# IS_SLOT_DEVICE=auto -> deteksi suffix slot aktif (_a/_b). WAJIB di Pixel (A/B device).
BLOCK=boot;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# --- tulis kernel (Image.lz4) ke partisi boot ---
# split_boot: di Pixel ramdisk TIDAK ada di boot (ada di init_boot), jadi tidak perlu
# unpack/repack ramdisk. Ini bikin proses lebih cepat dan tidak menyentuh ramdisk ROM.
split_boot;
flash_boot;
## end boot install
