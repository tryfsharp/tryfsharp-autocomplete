#!/bin/bash
if test "$OS" = "Windows_NT"
then
  MONO=""
else
  # Mono fix for https://github.com/fsharp/FAKE/issues/805
  export MONO_MANAGED_WATCHER=false
  MONO="mono"
fi

$MONO .paket/paket.bootstrapper.exe
exit_code=$?
if [ $exit_code -ne 0 ]; then
  exit $exit_code
fi
if [ -e "paket.lock" ]
then
  $MONO .paket/paket.exe restore
else
  $MONO .paket/paket.exe install
fi
exit_code=$?
if [ $exit_code -ne 0 ]; then
  exit $exit_code
fi

if [ ! -e "fs-auto-complete/bin/release/FsAutoComplete.Suave.exe" ]
then
  git clone -b cors https://github.com/tryfsharp/fs-auto-complete.git 
  cd fs-auto-complete
  build.sh LocalRelease
  cd ..
fi

$MONO packages/FAKE/tools/FAKE.exe $@ --fsiargs build.fsx
