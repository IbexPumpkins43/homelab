{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-CT1000P3SSD8_24294A05B115";

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

        # Encrypted root partition
        root = {
          size = "100%";

          content = {
            type = "luks";
            name = "crypted";

            settings.allowDiscards = true;

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  # Encrypted swap file
  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
}
