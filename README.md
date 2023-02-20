# tayaran_nxp

## 1 Update PX4 - v1.13.2

`
cd /src/PX4-Authopilot && rm -rf build
git checkout v1.13.2
make submodulesclean
make distclean
git submodule sync --recursive
git submodule update --recursive`
