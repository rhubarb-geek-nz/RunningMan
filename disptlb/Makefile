# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

OBJDIR=obj\$(VSCMD_ARG_TGT_ARCH)
BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
LIBNAME=RhubarbGeekNzRunningMan
TLBFILE=..\dispsvc\$(OBJDIR)\dispsvc.tlb

all: $(BINDIR)\$(LIBNAME).dll

clean:
	if exist $(OBJDIR) rmdir /q /s $(OBJDIR)
	if exist $(BINDIR) rmdir /q /s $(BINDIR)

$(BINDIR)\$(LIBNAME).dll: $(BINDIR) $(TLBFILE)
	tlbimp $(TLBFILE) /asmversion:1.0.0.0 /namespace:$(LIBNAME) /machine:Agnostic /out:$@
	if not "$(CertificateThumbprint)"=="" signtool sign /a /sha1 $(CertificateThumbprint) /fd SHA256 /t http://timestamp.digicert.com $@

$(BINDIR) $(OBJDIR):
	mkdir $@
