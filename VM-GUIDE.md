# Falkon OS в виртуалке — да, работает из коробки
# Live ISO уже содержит virtualbox-guest-utils + open-vm-tools + qemu-guest-agent + spice-vdagent,
# а falkon-drivers сам включает нужное при установке.

## VirtualBox (самый простой на Windows)
1. Создать -> Тип Linux, Версия Arch Linux 64-bit
2. RAM 4096, CPU 2-4, Видео 128МБ, вкл 3D
3. Система -> EFI ВКЛ (иначе не загрузится на новых ISO)
4. Носители -> выбрать falkon-*.iso
5. Старт -> иконка "Установить Falkon (Просто)" -> выбрать пустой VDI
6. После установки: Устройства -> Отключить ISO, Перезагрузить

## VMware Workstation Player (бесплатный)
1. Guest OS: Linux 6.x kernel 64-bit, EFI
2. RAM 4ГБ, CPU 2, HDD 30ГБ
3. falkon-drivers сам поставит open-vm-tools

## Hyper-V (встроен в Windows 10/11 Pro)
1. ВМ поколения 2 (UEFI), Secure Boot ВЫКЛ (иначе Arch не стартует)
2. RAM 4ГБ, vCPU 2
3. Подключить ISO, ставить через falkon-install-easy (там GRUB/systemd-boot сами разберутся)

## QEMU/KVM (для Linux-хоста)
qemu-system-x86_64 -enable-kvm -m 4G -smp 4 -cpu host -drive file=falkon.qcow2,if=virtio -cdrom falkon-*.iso -boot d -vga virtio

## Если тормозит в ВМ
sudo falkon-tweaks
# + в настройках ВМ дать 3D и 2+ ядра. Core-редакция летает даже на 2ГБ RAM.
