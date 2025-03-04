features {
    'autoupdater',
    'ebtables-filter-multicast',
    'ebtables-filter-ra-dhcp',
    'ebtables-limit-arp',
    'mesh-batman-adv-15',
    'mesh-vpn-wireguard',
    'respondd',
    'status-page',
    'web-advanced',
    'web-wizard',
    'config-mode-geo-location-osm',
    'radv-filterd',
    'radvd',
    'web-private-wifi',
}

packages {
    'iwinfo',
    'ffac-ssid-changer',
    'ffac-wg-registration',
    'ff-web-ap-timer',
    'respondd-module-airtime',
    'tecff-general-workaround',
    'tecff-broken-wlan-workaround',
}

if not device_class('tiny') and not target('ramips', 'mt7620') then
    features {
        'tls',
        'wireless-encryption-wpa3',
    }
    packages {
        'openssh-sftp-server',
        'ffac-autoupdater-wifi-fallback',
        'ffmuc-custom-banner',
    }
end

if device({
        'zte-mf281',
        'glinet-gl-xe300',
        'glinet-gl-ap1300',
        'zte-mf289f',
        'zte-mf286r',
        'wavlink-ws-wn572hp3-4g',
        'tp-link-tl-mr6400-v5',
    }) then
    features {
        'web-cellular',
    }
    packages {
        'ffac-private-wan-dhcp',
    }
end

pkgs_usb = {
    'usbutils',
}

pkgs_hid = {
    'kmod-usb-hid',
    'kmod-hid-generic',
}

pkgs_usb_serial = {
    'kmod-usb-serial',
    'kmod-usb-serial-ftdi',
    'kmod-usb-serial-pl2303',
}

pkgs_usb_storage = {
    'block-mount',
    'blkid',
    'kmod-fs-ext4',
    'kmod-fs-ntfs',
    'kmod-fs-vfat',
    'kmod-usb-storage',
    'kmod-usb-storage-extras',-- Card Readers
    'kmod-usb-storage-uas', -- USB Attached SCSI (UAS/UASP)
    'kmod-nls-base',
    'kmod-nls-cp1250',      -- NLS Codepage 1250 (Eastern Europe)
    'kmod-nls-cp437',       -- NLS Codepage 437 (United States, Canada)
    'kmod-nls-cp850',       -- NLS Codepage 850 (Europe)
    'kmod-nls-cp852',       -- NLS Codepage 852 (Europe)
    'kmod-nls-iso8859-1',   -- NLS ISO 8859-1 (Latin 1)
    'kmod-nls-iso8859-13',  -- NLS ISO 8859-13 (Latin 7; Baltic)
    'kmod-nls-iso8859-15',  -- NLS ISO 8859-15 (Latin 9)
    'kmod-nls-iso8859-2',   -- NLS ISO 8859-2 (Latin 2)
    'kmod-nls-utf8',        -- NLS UTF-8
}

pkgs_usb_net = {
    'kmod-mii',
    'kmod-usb-net',
    'kmod-usb-net-asix',
    'kmod-usb-net-asix-ax88179',
    'kmod-usb-net-cdc-eem',
    'kmod-usb-net-cdc-ether',
    'kmod-usb-net-cdc-subset',
    'kmod-usb-net-dm9601-ether',
    'kmod-usb-net-hso',
    'kmod-usb-net-ipheth',
    'kmod-usb-net-mcs7830',
    'kmod-usb-net-pegasus',
    'kmod-usb-net-rndis',
    'kmod-usb-net-rtl8152',
    'kmod-usb-net-smsc95xx',
}

pkgs_pci = {
    'pciutils',
    'kmod-bnx2', -- Broadcom NetExtreme BCM5706/5708/5709/5716
}

include_usb = true

-- rtl838x has no USB support as of Gluon v2023.2
if target('realtek', 'rtl838x') then
    include_usb = false
end

-- 7M usable firmware space + USB port
if target('ath79', 'generic') and not device({
    'devolo-wifi-pro-1750e',
    'gl.inet-gl-ar150',
    'gl.inet-gl-ar300m-lite',
    'gl.inet-gl-ar750',
    'joy-it-jt-or750i',
    'netgear-wndr3700-v2',
    'tp-link-archer-a7-v5',
    'tp-link-archer-c5-v1',
    'tp-link-archer-c7-v2',
    'tp-link-archer-c7-v5',
    'tp-link-archer-c59-v1',
    'tp-link-tl-wr842n-v3',
    'tp-link-tl-wr1043nd-v4',
    'tp-link-tl-wr1043n-v5',
}) then
    include_usb = false
end

if target('ramips', 'mt76x8') and not device({
    'gl-mt300n-v2',
    'gl.inet-microuter-n300',
    'netgear-r6120',
    'ravpower-rp-wd009',
}) then
    include_usb = false
end

-- 7M usable firmware space + USB port
if device({
    'avm-fritz-box-7412',
    'tp-link-td-w8970',
    'tp-link-td-w8980',
    'gl-mt300n-v2',
    'gl.inet-microuter-n300',
    'netgear-r6120',
    'ravpower-rp-wd009'
}) then
    include_usb = false
end

-- devices without usb ports
if device({
    'ubiquiti-unifi-6-lr-v1',
    'netgear-ex6150',
    'netgear-ex3700',
    'ubiquiti-edgerouter-x',
    'ubiquiti-edgerouter-x-sfp',
    'zyxel-nwa55axe',
}) then
    include_usb = false
end

if include_usb then
    packages(pkgs_usb)
    packages(pkgs_usb_net)
    packages(pkgs_usb_serial)
    packages(pkgs_usb_storage)
end

-- device has no reset button and requires a special package to go into setup mode
-- https://github.com/freifunk-gluon/community-packages/tree/master/ffda-network-setup-mode
if device({
    'zyxel-nwa55axe',
}) then
    packages {'ffda-network-setup-mode'}
end

if target('x86', '64') then
    -- add guest agent for qemu and vmware
    packages {
        'qemu-ga',
        'open-vm-tools',
    }
end

if target('x86') and not target('x86', 'legacy') then
    packages(pkgs_pci)
    packages(pkgs_hid)
end

if target('bcm27xx') then
    packages(pkgs_hid)
end

if target('mediatek', 'filogic') then
    -- reboot target three times a day
    packages {
        'ffac-threetime-reboot',
    }
end
