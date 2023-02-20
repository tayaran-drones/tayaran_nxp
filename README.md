# tayaran_nxp

## 1 Update PX4

`
rm -rf /src/PX4-Authopilot && rm -rf build
make submodulesclean
make distclean
git submodule sync --recursive
git submodule update --recursive`
