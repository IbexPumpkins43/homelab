{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-CT480BX500SSD1_2133E5C3EE93";

    content = {
      type = "gpt";

      partitions = {
        # EFI boot partition
        esp = {
          size = "2G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        # Root partition
        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  # Swap file
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
