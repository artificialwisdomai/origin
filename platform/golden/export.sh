source_img=`ls /home/sdake/repos/origin/platform/golden/build/*vdi`
vbox-img convert --srcfilename ${source_img} --dstfilename $HOME/baseline.img --srcformat VDI --dstformat RAW
zstd --compress $HOME/baseline.img
