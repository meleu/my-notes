# Linux LVM

## Preparar os HDs para usar com LVM

Guia muito bom e mão na massa (**ALERTA!**: use o ad-blocker antes de clicar neste link): <https://www.howtoforge.com/linux_lvm>

### 1. criar partições

- uma partição com 512 MB para boot como "EFI System"
- Restante das partições como "Linux LVM"

dar uma conferida com com `fdisk -l`


### 2. criar o volume físico (pv)

Volume Físico = Physical Volume = pv

Observação: Adicionar ao volume físico, somente as partições criadas como "Linux LVM".

```
# no meu caso são dois HDs (sda e sdb)
# a primeira partição do sda (sda1) não será utilizada aqui
pvcreate /dev/sda2 /dev/sdb1

# conferindo:
pvdisplay
```

### 3. criando um grupo de volume (vg)

Grupo de Volume = Volume Group = vg

```
# vgcreate ${volumeName} "${partitions[@]}"
vgcreate myVolumeGroup /dev/sda2 /dev/sdb1

# conferindo
vgdisplay

# outros comandos úteis
# vgrename
# vgscan
# vgremove
# vgreduce
```


### 4. criando os volumes lógicos (lv)

Volume Lógico = Logical Volume = lv

```
# o volume usado como / (root) terá 50G
lvcreate --name root --size 40G myVolumeGroup

# o volume usado como /home terá 400G
lvcreate --name home --size 400G myVolumeGroup

# conferindo
lvdisplay

# outros comandos úteis:
# lvrename
# lvremove
# lv<tab><tab>...
```
