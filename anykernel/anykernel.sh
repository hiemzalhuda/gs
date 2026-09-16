### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Template Pixel 7 / 7a (lynx) — A/B device
##
## KENAPA FILE INI ADA DI REPO:
## anykernel.sh bawaan AnyKernel3 itu contoh untuk Galaxy Nexus (tuna):
##   BLOCK=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot   <- hardware TI OMAP, BUKAN Pixel
##   IS_SLOT_DEVICE=0                                           <- Pixel itu A/B device
## Kalau dipakai apa adanya di Pixel: partisi boot tidak ketemu -> gagal flash / boot rusak.
##
## CARA KERJA DI PIXEL:
## - AK3 mendeteksi partisi lewat nama (BLOCK=auto) dan menambahkan suffix slot aktif (_a/_b).
## - Mode multi-partisi (boot + init_boot + vendor_kernel_boot) HANYA aktif otomatis kalau
##   ada FILE bernama persis "dtb" di root ZIP (lihat tools/ak3-core.sh). Kernel Pixel
##   biasanya tidak menghasilkan dtb dari source, jadi mode itu sering tidak aktif — dan itu
##   TIDAK masalah: kernel (Image.lz4) tetap ditulis ke partisi boot.
## - Ramdisk di Pixel 7 ada di init_boot, TAPI kita TIDAK mengubah ramdisk (kernel-only zip),
##   jadi bagian init_boot tidak perlu disentuh. Membiarkannya lebih aman daripada menulis
##   ramdisk kosong ke init_boot.

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
# BLOCK=auto          -> AK3 cari partisi boot sendiri (nama-based, bukan jalur hardcoded tuna)
# IS_SLOT_DEVICE=auto -> deteksi suffix slot aktif (_a/_b). WAJIB di Pixel (A/B device).
BLOCK=auto;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# --- tulis kernel (Image.lz4) ke partisi boot ---
# split_boot: di Pixel ramdisk tidak ada di boot, jadi tidak perlu unpack/repack.
# Kalau build menghasilkan dtb, AK3 sudah otomatis mengatur mode multi-partisi sendiri
# dan baris ini tetap berfungsi (menulis bagian boot).
split_boot;
flash_boot;
## end boot install
