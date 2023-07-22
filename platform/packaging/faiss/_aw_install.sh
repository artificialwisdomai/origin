source /opt/intel/oneapi/setvars.sh

cmake --install _build --prefix $HOME/target/faiss
mkdir -p $HOME/target/faiss/_aw_package
cp -a _build/faiss/python/dist/faiss*whl $HOME/target/faiss/_aw_package/
cp -a _aw* $HOME/target/faiss/_aw_package/
