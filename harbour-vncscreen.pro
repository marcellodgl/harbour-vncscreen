# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-vncscreen

CONFIG += sailfishapp

INCLUDEPATH+=src/libvncclient
INCLUDEPATH+=src/libvncclient/libjpeg
INCLUDEPATH+=src/libvncclient/common
INCLUDEPATH+=src/libvncclient/zlib
#attenzione alle parentesi affiancate, un accapo rende non letto dalla funzione il contenuto della procedura da considerare
#equals(TargetName,"SailfishOS-armv7hl"){
#    message(arm)
#}

VERSION=0.1.0


DEFINES += APP_VERSION=\\\"$$VERSION\\\"


SOURCES += src/harbour-vncscreen.cpp \
    src/interfacerfb.cpp \
    src/screenprovider.cpp \
    src/vncclientthread.cpp \
    src/libvncclient/common/d3des.c \
    src/libvncclient/common/md5.c \
    src/libvncclient/common/minilzo.c \
    src/libvncclient/common/sha1.c \
    src/libvncclient/common/turbojpeg.c \
    src/libvncclient/common/vncauth.c \
    src/libvncclient/common/zywrletemplate.c \
    src/libvncclient/libjpeg/jaricom.c \
    src/libvncclient/libjpeg/jcapimin.c \
    src/libvncclient/libjpeg/jcapistd.c \
    src/libvncclient/libjpeg/jcarith.c \
    src/libvncclient/libjpeg/jccoefct.c \
    src/libvncclient/libjpeg/jccolor.c \
    src/libvncclient/libjpeg/jcdctmgr.c \
    src/libvncclient/libjpeg/jchuff.c \
    src/libvncclient/libjpeg/jcinit.c \
    src/libvncclient/libjpeg/jcmainct.c \
    src/libvncclient/libjpeg/jcmarker.c \
    src/libvncclient/libjpeg/jcmaster.c \
    src/libvncclient/libjpeg/jcomapi.c \
    src/libvncclient/libjpeg/jcparam.c \
    src/libvncclient/libjpeg/jcprepct.c \
    src/libvncclient/libjpeg/jcsample.c \
    src/libvncclient/libjpeg/jctrans.c \
    src/libvncclient/libjpeg/jdapimin.c \
    src/libvncclient/libjpeg/jdapistd.c \
    src/libvncclient/libjpeg/jdarith.c \
    src/libvncclient/libjpeg/jdatadst.c \
    src/libvncclient/libjpeg/jdatasrc.c \
    src/libvncclient/libjpeg/jdcoefct.c \
    src/libvncclient/libjpeg/jdcolor.c \
    src/libvncclient/libjpeg/jddctmgr.c \
    src/libvncclient/libjpeg/jdhuff.c \
    src/libvncclient/libjpeg/jdinput.c \
    src/libvncclient/libjpeg/jdmainct.c \
    src/libvncclient/libjpeg/jdmarker.c \
    src/libvncclient/libjpeg/jdmaster.c \
    src/libvncclient/libjpeg/jdmerge.c \
    src/libvncclient/libjpeg/jdpostct.c \
    src/libvncclient/libjpeg/jdsample.c \
    src/libvncclient/libjpeg/jdtrans.c \
    src/libvncclient/libjpeg/jerror.c \
    src/libvncclient/libjpeg/jfdctflt.c \
    src/libvncclient/libjpeg/jfdctfst.c \
    src/libvncclient/libjpeg/jfdctint.c \
    src/libvncclient/libjpeg/jidctflt.c \
    src/libvncclient/libjpeg/jidctfst.c \
    src/libvncclient/libjpeg/jidctint.c \
    src/libvncclient/libjpeg/jmemansi.c \
    src/libvncclient/libjpeg/jmemmgr.c \
    src/libvncclient/libjpeg/jquant1.c \
    src/libvncclient/libjpeg/jquant2.c \
    src/libvncclient/libjpeg/jutils.c \
    src/libvncclient/libjpeg/rdbmp.c \
    src/libvncclient/libjpeg/rdcolmap.c \
    src/libvncclient/libjpeg/rdppm.c \
    src/libvncclient/libjpeg/rdrle.c \
    src/libvncclient/libjpeg/rdswitch.c \
    src/libvncclient/libjpeg/rdtarga.c \
    src/libvncclient/libjpeg/transupp.c \
    src/libvncclient/libjpeg/wrbmp.c \
    src/libvncclient/libjpeg/wrgif.c \
    src/libvncclient/libjpeg/wrppm.c \
    src/libvncclient/libjpeg/wrrle.c \
    src/libvncclient/libjpeg/wrtarga.c \
    src/libvncclient/zlib/adler32.c \
    src/libvncclient/zlib/compress.c \
    src/libvncclient/zlib/crc32.c \
    src/libvncclient/zlib/deflate.c \
    src/libvncclient/zlib/gzclose.c \
    src/libvncclient/zlib/gzlib.c \
    src/libvncclient/zlib/gzread.c \
    src/libvncclient/zlib/gzwrite.c \
    src/libvncclient/zlib/infback.c \
    src/libvncclient/zlib/inffast.c \
    src/libvncclient/zlib/inflate.c \
    src/libvncclient/zlib/inftrees.c \
    src/libvncclient/zlib/trees.c \
    src/libvncclient/zlib/uncompr.c \
    src/libvncclient/zlib/zutil.c \
    src/libvncclient/corre.c \
    src/libvncclient/cursor.c \
    src/libvncclient/h264.c \
    src/libvncclient/hextile.c \
    src/libvncclient/listen.c \
    src/libvncclient/rfbproto.c \
    src/libvncclient/rre.c \
    src/libvncclient/sockets.c \
    src/libvncclient/tight.c \
    src/libvncclient/tls_none.c \
    src/libvncclient/ultra.c \
    src/libvncclient/vncviewer.c \
    src/libvncclient/zlib.c \
    src/libvncclient/zrle.c \
    src/sym2rfbkey.cpp \
    src/interfacesettings.cpp

OTHER_FILES += qml/harbour-vncscreen.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-vncscreen.changes.in \
    rpm/harbour-vncscreen.spec \
    rpm/harbour-vncscreen.yaml \
    translations/*.ts \
    harbour-vncscreen.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-vncscreen-de.ts

DISTFILES += \
    qml/pages/ConnectPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/PasswordPage.qml \
    qml/pages/AboutPage.qml \
    qml/components/BlockText.qml \
    LICENSE \
    README.md \
    COPYING

HEADERS += \
    src/libvncclient/common/d3des.h \
    src/libvncclient/common/lzoconf.h \
    src/libvncclient/common/lzodefs.h \
    src/libvncclient/common/md5.h \
    src/libvncclient/common/minilzo.h \
    src/libvncclient/common/sha-private.h \
    src/libvncclient/common/sha.h \
    src/libvoncclient/common/turbojpeg.h \
    src/libvncclient/libjpeg/cderror.h \
    src/libvncclient/libjpeg/cdjpeg.h \
    src/libvncclient/libjpeg/jconfig.h \
    src/libvncclient/libjpeg/jdct.h \
    src/libvncclient/libjpeg/jerror.h \
    src/libvncclient/libjpeg/jinclude.h \
    src/libvncclient/libjpeg/jmemsys.h \
    src/libvncclient/libjpeg/jmorecfg.h \
    src/libvncclient/libjpeg/jpegint.h \
    src/libvncclient/libjpeg/jpeglib.h \
    src/libvncclient/libjpeg/jversion.h \
    src/libvncclient/libjpeg/transupp.h \
    src/libvncclient/rfb/default8x16.h \
    src/libvncclient/rfb/keysym.h \
    src/libvncclient/rfb/rfb.h \
    src/libvncclient/rfb/rfbclient.h \
    src/libvncclient/rfb/rfbconfig.h \
    src/libvncclient/rfb/rfbint.h \
    src/libvncclient/rfb/rfbproto.h \
    src/libvncclient/rfb/rfbregion.h \
    src/libvncclient/zlib/crc32.h \
    src/libvncclient/zlib/deflate.h \
    src/libvncclient/zlib/gzguts.h \
    src/libvncclient/zlib/inffast.h \
    src/libvncclient/zlib/inffixed.h \
    src/libvooncclient/zlib/inflate.h \
    src/libvncclient/zlib/inftrees.h \
    src/libvncclient/zlib/trees.h \
    src/libvncclient/zlib/zconf.h \
    src/libvncclient/zlib/zlib.h \
    src/libvncclient/zlib/zutil.h \
    src/libvncclient/tls.h \
    src/interfacerfb.h \
    src/screenprovider.h \
    src/vncclientthread.h \
    src/sym2rfbkey.h \
    src/interfacesettings.h

RESOURCES += \
    vncscreen.qrc

