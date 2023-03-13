# Method 1 Reset git submodules

```
git submodule foreach --recursive git reset --hard
```

However, it may fail under some cases, especially after a merging which remove/add submodules.

# Method 2 Reset git submodules by deiniting and initing

```
# unbinds all submodules
git submodule deinit -f .
# checkout again
git submodule update --init --recursive
```
