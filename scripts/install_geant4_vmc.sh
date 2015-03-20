#!/bin/bash


if [ ! -d  $SIMPATH/transport/geant4_vmc ]; then
  cd $SIMPATH/transport
  git clone $GEANT4VMC_LOCATION
fi

cd $SIMPATH/transport/geant4_vmc
#git checkout $GEANT4VMCBRANCH
#git reset $GEANT4VMCVERSION
    
install_prefix=$SIMPATH_INSTALL
checkfile=$install_prefix/lib/libgeant4vmc.so

if (not_there Geant4_VMC $checkfile);
then

  cd $SIMPATH/transport/geant4_vmc

  #mypatch ../Geant4_vmc_c++11.patch
  
  if (not_there Geant4_VMC_Build build);
  then
    mkdir build
  fi
  cd build

  cmake -DCMAKE_INSTALL_PREFIX=$install_prefix ../
  
  make -j$number_of_processes
  make -j$number_of_processes install

  if [ "$platform" = "macosx" ];
  then
    cd $install_prefix/lib
    create_links dylib so
  fi

  check_success Geant4_VMC $checkfile
  check=$?

  check_all_libraries $install_prefix/lib

fi

if [ "$platform" = "macosx" ];
then
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$SIMPATH/transport/geant4_vmc/lib/
else
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SIMPATH/transport/geant4_vmc/lib/
fi

cd $SIMPATH

return 1
