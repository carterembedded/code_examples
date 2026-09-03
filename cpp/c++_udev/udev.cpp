#include <libudev.h>
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <unistd.h>
#include <string.h>
#include <libgen.h>

int main(int argc, char **argv)
{

    struct udev *udev;
    struct udev_enumerate *enumerate_h;
    struct udev_enumerate *enumerate_u;
    struct udev_list_entry *devices_h, *devices_u, *dev_list_entry;
    struct udev_device *dev;

    udev = udev_new();

    enumerate_u = udev_enumerate_new(udev);
    enumerate_h = udev_enumerate_new(udev);
    udev_enumerate_add_match_subsystem(enumerate_h, "hidraw");

    udev_enumerate_scan_devices(enumerate_h);
    devices_h = udev_enumerate_get_list_entry(enumerate_h);

    char* devpath = "/dev/hidraw2";
    char *devnode = basename(devpath);
    const char* foundpath = NULL;
    const char *path_h;
    udev_list_entry_foreach(dev_list_entry, devices_h) {
        path_h = udev_list_entry_get_name(dev_list_entry);
   	printf("path_h: %s\n", path_h); 
	if(strstr(path_h, devnode)) {
			printf("got path: %s", path_h);
			foundpath = path_h;
			break;
	}
        //dev = udev_device_new_from_syspath(udev, path_h);
    }
printf("fetching dev and bus num.\n");
	    char* newpath;
	    newpath = new char[256];
	    strcpy(newpath, foundpath);
            newpath = dirname(newpath);
            newpath = dirname(newpath);
            newpath = dirname(newpath);
            newpath = dirname(newpath);
	    printf("newpath: %s\n", newpath);
	dev = udev_device_new_from_syspath(udev, newpath);

        fprintf(stderr, "devnum: %s\n",
            udev_device_get_sysattr_value(dev, "devnum"));
        fprintf(stderr, "busnum: %s\n",
            udev_device_get_sysattr_value(dev, "busnum"));
        fprintf(stderr, "idproduct: %s\n",
            udev_device_get_sysattr_value(dev, "idProduct"));
        fprintf(stderr, "idvendor: %s\n",
            udev_device_get_sysattr_value(dev, "idVendor"));
        udev_device_unref(dev);

    udev_enumerate_unref(enumerate_h);
    udev_unref(udev);

    return 0;
}
