# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
APPNAME=dispapp
SVRNAME=dispsvc
TLBNAME=disptlb
LIBNAME=RhubarbGeekNzRunningMan
EXENAME=$(LIBNAME)

all: $(BINDIR) $(BINDIR)\$(EXENAME).exe $(TLBNAME)\$(BINDIR)\$(LIBNAME).dll $(BINDIR)\$(APPNAME).exe

clean:
	if exist $(BINDIR) rmdir /q /s $(BINDIR)
	cd $(SVRNAME)
	$(MAKE) clean
	cd ..
	cd $(APPNAME)
	$(MAKE) clean
	cd ..
	cd $(TLBNAME)
	$(MAKE) clean
	cd ..

$(BINDIR):
	mkdir $@

$(BINDIR)\$(APPNAME).exe: $(APPNAME)\$(BINDIR)\$(APPNAME).exe
	copy $(APPNAME)\$(BINDIR)\$(APPNAME).exe $@

$(BINDIR)\$(EXENAME).exe: $(SVRNAME)\$(BINDIR)\$(SVRNAME).exe
	copy $(SVRNAME)\$(BINDIR)\$(SVRNAME).exe $@

$(APPNAME)\$(BINDIR)\$(APPNAME).exe:
	cd $(APPNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..

$(SVRNAME)\$(BINDIR)\$(SVRNAME).exe:
	cd $(SVRNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..

$(TLBNAME)\$(BINDIR)\$(LIBNAME).dll:
	cd $(TLBNAME)
	$(MAKE) CertificateThumbprint=$(CertificateThumbprint)
	cd ..
