#!/sbin/sh
# EDebloater

# Settings
OUTFD=$2
ui_print() {
    echo -n -e "ui_print $1\n" >> /proc/self/fd/$OUTFD
    echo -n -e "ui_print\n" >> /proc/self/fd/$OUTFD
}

# Mount
sleep 1;
ui_print "Mounting system...";
mount -t auto /system_root;
mount -o rw,remount /system_root;

# Path | Credit to wahyu6070 & TheHitMan7
if [ -f /system_root/system/build.prop ]; then
	SYSTEM=/system_root/system 
elif [ -f /system_root/build.prop ]; then
	SYSTEM=/system_root
elif [ -f /system/system/build.prop ]; then
	SYSTEM=/system/system
else
	SYSTEM=/system
fi

if [ ! -L $SYSTEM/vendor ]; then
	VENDOR=$SYSTEM/vendor
else
	VENDOR=/vendor
fi

if [ ! -L $SYSTEM/product ]; then
	PRODUCT=$SYSTEM/product
else
	PRODUCT=/product
fi

if [ ! -L $SYSTEM/system_ext ]; then
	SYSTEM_EXT=$SYSTEM/system_ext
else
	SYSTEM_EXT=/system_ext
fi

system_uninstall() {
  SYSTEM_APP="$SYSTEM/app"
  SYSTEM_PRIV_APP="$SYSTEM/priv-app"
}

product_uninstall() {
  SYSTEM_APP="$PRODUCT/app"
  SYSTEM_PRIV_APP="$PRODUCT/priv-app"
}

ext_uninstall() {
  SYSTEM_APP="$SYSTEM_EXT/app"
  SYSTEM_PRIV_APP="$SYSTEM_EXT/priv-app"
}

sleep 1;
ui_print "| Remove from /system/*/app & /system/*/priv-app... ";
post_install_wipe() {
  for i in \
HelpRtcPrebuilt Traceur LocationHistoryPrebuilt SafetyHubPrebuilt Stk \
colorservice RecorderPrebuilt CalculatorGooglePrebuilt obdm_stub OBDM_Permissions \
AppDirectedSMSService ScribePrebuilt CarrierServices Photos FilesPrebuilt \
BookmarkProvider CtsShimPrebuilt CtsShimPrivPrebuilt CbrsNetworkMonitor WAPPushManager \
SoterService GoogleFeedback GoogleOneTimeInitializer PartnerSetupPrebuilt BetterBug \
SetupWizardPrebuilt PixelSetupWizard Velvet MaestroPrebuilt AndroidAutoStubPrebuilt \
talkback SoundAmplifierPrebuilt Drive PrebuiltGmail GoogleTTS \
turbo PrebuiltGoogleTelemetryTvp CarrierWifi GCS Showcase \
DeviceIntelligenceNetworkPrebuilt; do
    rm -rf $SYSTEM_APP/$i $SYSTEM_PRIV_APP/$i
  done
}

if [ ! -f "$SYSTEM/test.enttn" ]; then
ui_print "| Totally cleaning..."
  ext_uninstall
  post_install_wipe
  product_uninstall
  post_install_wipe
  system_uninstall
  post_install_wipe
fi

rm -rf $SYSTEM/test.enttn
ui_print "Done! ";