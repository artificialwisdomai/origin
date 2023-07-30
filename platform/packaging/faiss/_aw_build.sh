source /opt/intel/oneapi/setvars.sh

make -C _build -j$(nproc) faiss faiss_avx2
make -C _build -j$(nproc) swigfaiss
