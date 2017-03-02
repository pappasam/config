# Finding header files on Ubuntu

When doing C and C++ development, finding appropriate header files may result in tedious web queries.
To avoid this silliness, the following commands may be used to search the web for headers.

## Locating within which Ubuntu package a header lives

```sh
# obtain and update cache
sudo apt install apt-file
apt-file update

# search for the header "Python.h"
apt-file -x search "/Python.h$"

# search for header "boost/filesystem.hpp"
apt-file -x search "/boost/filesystem.hpp$"

# show information about an Ubuntu package
apt-cache show libboost1.58-dev

# when installed, show all files in a package
dpkg -L libpython3.5-dev
```
