# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

OBJDIR=obj\$(VSCMD_ARG_TGT_ARCH)
BINDIR=bin\$(VSCMD_ARG_TGT_ARCH)
APPNAME=dispapp

all: $(BINDIR)\$(APPNAME).exe

clean:
	if exist $(OBJDIR) rmdir /q /s $(OBJDIR)
	if exist $(BINDIR) rmdir /q /s $(BINDIR)

$(BINDIR)\$(APPNAME).exe: $(OBJDIR)\$(APPNAME).obj $(OBJDIR)\$(APPNAME).res $(BINDIR) $(OBJDIR)\dispsvc_i.obj
	cl /Fe$@ /MT $(OBJDIR)\$(APPNAME).obj $(OBJDIR)\dispsvc_i.obj $(OBJDIR)\$(APPNAME).res ole32.lib oleaut32.lib /link /INCREMENTAL:NO /PDB:NONE /SUBSYSTEM:CONSOLE
	if not "$(CertificateThumbprint)"=="" signtool sign /a /sha1 $(CertificateThumbprint) /fd SHA256 /t http://timestamp.digicert.com $@

$(OBJDIR)\$(APPNAME).obj: $(APPNAME).cpp $(OBJDIR)
	cl /c /Fo$@ $(APPNAME).cpp -I..\dispsvc\$(OBJDIR) /DWIN32_LEAN_AND_MEAN

$(OBJDIR)\dispsvc_i.obj: $(APPNAME).cpp $(OBJDIR) ..\dispsvc\$(OBJDIR)\dispsvc_i.c
	cl /c /Fo$@ ..\dispsvc\$(OBJDIR)\dispsvc_i.c /I$(OBJDIR)

$(OBJDIR)\$(APPNAME).res: $(APPNAME).rc
	rc /r  $(RCFLAGS) /i $(OBJDIR) /fo$@ $(APPNAME).rc

$(BINDIR) $(OBJDIR):
	mkdir $@
