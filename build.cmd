@echo off
.paket\paket.bootstrapper.exe
if errorlevel 1 (
  exit /b %errorlevel%
)
if not exist paket.lock (
  .paket\paket.exe -v install
) else (
  .paket\paket.exe -v restore
)
if errorlevel 1 (
  exit /b %errorlevel%
)

if not exist FsAutoComplete\bin\release\FsAutoComplete.Suave.exe (
  git clone -b cors https://github.com/ionide/FsAutoComplete.git 
  cd FsAutoComplete
  call build.cmd LocalRelease
  cd ..
)

packages\FAKE\tools\FAKE.exe %* --fsiargs build.fsx
