Configure baseline images 🚀

# Overview

These provisioners are focused on building specific image types.

TODO: [sdake](https://github.com/sdake) The playbook needs to be disambiguated.
TODO: [sdake](https://github.com/sdake) The image types need to be written here.

**baseline_pristine**: The baseline image by which other images are built in a recurrent
self-hosted fashion.

**baseline_dirty**: A baseline image that has been modified by installing build tools.

**baseline_clean**: A baseline image that has been built from a baseline_dirty image.

**build_debspawn**: An image that contains code and configuration necessary to
build with debspawn.
