# VMware Nested Virtualization within Microsoft Hyper-V

VMware vSphere Hypervisor 7 License: JJ205-FC281-18LG1-0VCUH-0M911

```powershell
Add-EsxSoftwareDepot .\VMware-ESXi-6.5.0-4564106-depot.zip, .\net-tulip-1.1.15-1-offline_bundle.zip
Add-EsxSoftwarePackage -ImageProfile ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -SoftwarePackage net-tulip
New-EsxImageProfile -CloneProfile ESXi-6.5.0-4564106-standard -Name ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -Vendor 'Custom vendor'
Set-EsxImageProfile -Name ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -AcceptanceLevel CommunitySupported
Export-EsxImageProfile -ImageProfile ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -ExportToISO -filepath .\ESXi-6.5.0-4564106-net-tulip-1.1.15-1.iso
```

---

## Expose virtualizations extensions (per VM)

```powershell
Set-VMProcessor ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -Count 2 -Reserve 10 -Maximum 75 -RelativeWeight 200
Set-VMProcessor ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -CompatibilityForOlderOperatingSystemsEnabled $true
Set-VMProcessor ESXi-6.5.0-4564106-net-tulip-1.1.15-1 -ExposeVirtualizationExtensions $true
```
