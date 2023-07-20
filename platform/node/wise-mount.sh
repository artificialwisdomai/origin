###
#
# Export /${id}-state/ with the submounts:
#
# /repos/(rw,virtiofs->virtioblk): $HOME/repos persistent storage
# /cache/(rw,virtiofs->virtioblk): $HOME/.cache persistent storage
# /home/(rw,virtiofs->virtioblk): TODO(sdake): $HOME/
# /models/(rw->ro,virtiofs->virtioblk): model persistent storage
# /datasets/(rw->ro,virtiofs->virtioblk): dataset persistent storage

# make state directories

sudo mkdir -p /var/lib/artificial_wisdom/01-state/{cache,home,repos}/
sudo mkdir -p /var/lib/artificial_wisdom/24-state/{cache,home,repos}/
sudo mkdir -p /var/lib/artificial_wisdom/61-state/{cache,home,repos}/

# make virtiofs mountpoints

sudo mkdir -p /var/run/artificial_wisdom/01-mounts/{cache,home,repos,models,datasets}/
sudo mkdir -p /var/run/artificial_wisdom/24-mounts/{cache,home,repos,models,datasets}/
sudo mkdir -p /var/run/artificial_wisdom/61-mounts/{cache,home,repos,models,datasets}/

# models

sudo mount -o bind,ro /opt/share/models /var/run/artificial_wisdom/01-mounts/models/
sudo mount -o bind,ro /opt/share/models /var/run/artificial_wisdom/24-mounts/models/
sudo mount -o bind,ro /opt/share/models /var/run/artificial_wisdom/61-mounts/models/

# datasets

sudo mount -o bind,ro /opt/share/datasets /var/run/artificial_wisdom/01-mounts/datasets/
sudo mount -o bind,ro /opt/share/datasets /var/run/artificial_wisdom/24-mounts/datasets/
sudo mount -o bind,ro /opt/share/datasets /var/run/artificial_wisdom/61-mounts/datasets/

# Cache

sudo mount -o bind /var/lib/artificial_wisdom/01-state/cache /var/run/artificial_wisdom/01-mounts/cache
sudo mount -o bind /var/lib/artificial_wisdom/24-state/cache /var/run/artificial_wisdom/24-mounts/cache
sudo mount -o bind /var/lib/artificial_wisdom/61-state/cache /var/run/artificial_wisdom/61-mounts/cache

# Home

sudo mount -o bind /var/lib/artificial_wisdom/01-state/home /var/run/artificial_wisdom/01-mounts/home
sudo mount -o bind /var/lib/artificial_wisdom/24-state/home /var/run/artificial_wisdom/24-mounts/home
sudo mount -o bind /var/lib/artificial_wisdom/61-state/home /var/run/artificial_wisdom/61-mounts/home

# Repos

sudo mount -o bind /var/lib/artificial_wisdom/01-state/repos /var/run/artificial_wisdom/01-mounts/repos
sudo mount -o bind /var/lib/artificial_wisdom/24-state/repos /var/run/artificial_wisdom/24-mounts/repos
sudo mount -o bind /var/lib/artificial_wisdom/61-state/repos /var/run/artificial_wisdom/61-mounts/repos
