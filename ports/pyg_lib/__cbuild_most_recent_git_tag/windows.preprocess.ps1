cd "$env:SRC_DIR"
sed -i -e '/HAVE_THREADLOCALSTORAGE/s/NOT HAVE_THREADLOCALSTORAGE/OFF/g' third_party/METIS/GKlib/GKlibSystem.cmake
sed -i -e '/HAVE_THREADLOCALSTORAGE/s/if(.*)/if(OFF)/g' third_party/METIS/GKlib/GKlibSystem.cmake
