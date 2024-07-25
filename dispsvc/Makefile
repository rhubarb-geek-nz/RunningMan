# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

OBJDIR=obj\$(VSCMD_ARG_TGT_ARCH)
BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
APPNAME=dispsvc

all: $(BINDIR)\$(APPNAME).exe

clean:
	if exist $(OBJDIR) rmdir /q /s $(OBJDIR)
	if exist $(BINDIR) rmdir /q /s $(BINDIR)

$(OBJDIR)\$(APPNAME).h $(OBJDIR)\$(APPNAME)_i.c: $(OBJDIR)\$(APPNAME).tlb

$(OBJDIR)\$(APPNAME).tlb: $(APPNAME).idl $(OBJDIR)
	midl $(APPNAME).idl /client none /server none /tlb $(APPNAME).tlb /h $(APPNAME)_h.h /out $(OBJDIR)

$(BINDIR)\$(APPNAME).exe: $(OBJDIR)\$(APPNAME).obj $(OBJDIR)\$(APPNAME).res $(BINDIR) $(OBJDIR)\$(APPNAME)_i.obj
	cl /Fe$@ /MT $(OBJDIR)\$(APPNAME).obj $(OBJDIR)\$(APPNAME)_i.obj $(OBJDIR)\$(APPNAME).res ole32.lib oleaut32.lib advapi32.lib user32.lib /link /INCREMENTAL:NO /PDB:NONE
	if not "$(CertificateThumbprint)"=="" signtool sign /a /sha1 $(CertificateThumbprint) /fd SHA256 /t http://timestamp.digicert.com $@

$(OBJDIR)\$(APPNAME).obj: $(APPNAME).c $(OBJDIR) $(OBJDIR)\$(APPNAME).h
	cl /c /Fo$@ $(APPNAME).c /I$(OBJDIR) /DWIN32_LEAN_AND_MEAN /DCOBJMACROS

$(OBJDIR)\$(APPNAME)_i.obj: $(OBJDIR)\$(APPNAME)_i.c $(OBJDIR)
	cl /c /Fo$@ $(OBJDIR)\$(APPNAME)_i.c

$(OBJDIR)\$(APPNAME).res: $(APPNAME).rc $(OBJDIR)\$(APPNAME).tlb
	rc /r  $(RCFLAGS) /i $(OBJDIR) /fo$@ $(APPNAME).rc

$(BINDIR) $(OBJDIR):
	mkdir $@
