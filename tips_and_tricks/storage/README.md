# Gerenciamento de storage

## Discos MBR

O gerenciamento de discos com partição MBR deve ser realizado através do fdisk

```sudo yum -y install fdisk```

## Discos GPT

O gerenciamento de discos com partição GPT deve ser realizado através do gdisk

```sudo yum -y install gdisk```

## Expansão de volumes configurados como Linux LVM

**OBS**: Volumes lógicos não são recomendados para ambientes virtualizados, dê preferência a partições padrão.

1. Verificando o tamanho do disco

    ```bash
    [root@localhost ~]# fdisk -l
    Disk /dev/sda: 201 GiB, 215822106624 bytes, 421527552 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x4756842e

    Device     Boot     Start       End   Sectors  Size Id Type
    /dev/sda1  *         2048 415236095 415234048  198G 83 Linux
    /dev/sda2       415238142 419428351   4190210    2G  5 Extended
    /dev/sda5       415238144 419428351   4190208    2G 82 Linux swap / Solaris
    ```

2. Redimensionando a partição

    ```bash
    [root@localhost ~]# fdisk /dev/sda
    Welcome to fdisk (util-linux 2.23.2).

    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Command (m for help): d
    Partition number (1,2, default 2):
    Partition 2 is deleted

    Command (m for help): n
    Partition type:
    p   primary (1 primary, 0 extended, 3 free)
    e   extended
    Select (default p):
    Using default response p
    Partition number (2-4, default 2):
    First sector (1026048-27262975, default 1026048):
    Using default value 1026048
    Last sector, +sectors or +size{K,M,G} (1026048-27262975, default 27262975):
    Using default value 27262975
    Partition 2 of type Linux and of size 12.5 GiB is set

    Command (m for help): t
    Partition number (1,2, default 2): 8e
    Partition number (1,2, default 2):
    Hex code (type L to list all codes): 8e
    Changed type of partition 'Linux' to 'Linux LVM'

    Command (m for help): p

    Disk /dev/sda: 14.0 GB, 13958643712 bytes, 27262976 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk label type: dos
    Disk identifier: 0x000912b7

    Device Boot      Start         End      Blocks   Id  System
    /dev/sda1   *        2048     1026047      512000   83  Linux
    /dev/sda2         1026048    27262975    13118464   8e  Linux LVM

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
    The kernel still uses the old table. The new table will be used at
    the next reboot or after you run partprobe(8) or kpartx(8)
    Syncing disks.

    [root@localhost ~]# partx -u /dev/sda
    ```

3. Redimensionando o volume físico

    ```bash
    [root@localhost ~]# pvdisplay
    --- Physical volume ---
    PV Name               /dev/sda2
    VG Name               centos
    PV Size               <11.51 GiB / not usable 2.00 MiB
    Allocatable           yes (but full)
    PE Size               4.00 MiB
    Total PE              2946
    Free PE               0
    Allocated PE          2946
    PV UUID               XepyHg-H23c-Qkma-2sDl-f5if-diC8-f7Gsn7

    [root@localhost ~]# pvresize /dev/sda2
    Physical volume "/dev/sda2" changed
    1 physical volume(s) resized / 0 physical volume(s) not resized
    ```

4. Redimensionando o volume lógico

    ```bash
    [root@localhost ~]# lvdisplay
    --- Logical volume ---
    LV Path                /dev/centos/root
    LV Name                root
    VG Name                centos
    LV UUID                2j5NcR-5Uec-PPd3-z34J-ON18-k3d5-g2OuDw
    LV Write Access        read/write
    LV Creation host, time localhost, 2017-12-12 11:46:22 -0500
    LV Status              available
    # open                 1
    LV Size                <10.71 GiB
    Current LE             2741
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     8192
    Block device           253:0

    [root@localhost ~]# lvextend -l +100%FREE /dev/centos/root
    Size of logical volume centos/root changed from <10.71 GiB (2741 extents) to <11.71 GiB (2997 extents).
    Logical volume centos/root successfully resized.
    ```

5. Expandindo o sistema de arquivos

    ```bash
    [root@localhost ~]# xfs_growfs /dev/mapper/centos-root 
    meta-data=/dev/mapper/centos-root isize=256    agcount=7, agsize=436992 blks
            =                       sectsz=512   attr=2, projid32bit=1
            =                       crc=0        finobt=0 spinodes=0
    data     =                       bsize=4096   blocks=2806784, imaxpct=25
            =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
    log      =internal               bsize=4096   blocks=2560, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
    data blocks changed from 2806784 to 3068928
    ```
