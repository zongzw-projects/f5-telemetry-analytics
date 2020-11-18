# Script Usage

* install-dockerce-centos.sh
  
  Used to install Docker CE on the host.

* export-docker-images.sh

  Used to export docker images in order to `import-docker-images` on another host. This process is helpful to customers' environment which cannot access external network for image downloads.

  It should be run after the first `start-all.sh` execution, because `start-all.sh` pulls images to local host.

  ```
  Usage:
     $ ./export-docker-images.sh <target folder>
  ``` 
  
  It will execute `docker save` command to save the images to `target folder`(as *.tar).

  Then, we can `scp` the images to the target host(external network unaccessible).

* import-docker-images.sh

  Used to import docker images on the host mentioned above.

  ```
  Usage:
     $ ./import-docker-images.sh <image folder>
  ```

  It will execute `docker load` command to load images from .tar file.
