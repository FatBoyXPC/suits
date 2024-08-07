# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#  imports = [ ./disko-config.nix ];
#  disko.devices.disk.main.device = "/dev/sda";
# }
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          efiGptPartitionFirst = false;
          partitions = {
            TOW-BOOT-FI = {
              priority = 1;
              type = "EF02";
              size = "32M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = null;
              };
              hybrid = {
                mbrPartitionType = "0x0c";
                mbrBootableFlag = false;
              };
            };
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
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
    };
  };
}
