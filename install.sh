#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
sleep 2
echo
echo "Backing up current XeroASCII "
echo "#############################"
# Check if XeroASCII.old file exists in /etc/
if [ -f "$HOME/XeroAscii.old" ]; then
    echo "Deleting existing XeroAscii.old file..."
    rm $HOME/XeroAscii.old
fi
# Rename XeroASCII to XeroASCII.old
if [ -f "$HOME/XeroAscii" ]; then
    echo "Renaming XeroAscii to XeroAscii.old..."
    mv $HOME/XeroAscii $HOME/XeroAscii.old
fi
echo
sleep 2
echo "Removing No longer needed Packages"
echo "##################################"
sudo pacman -Rns --noconfirm kvantum &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-kde-theme-mauve-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-cursors-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-kde-theme-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha-mauve &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-cursors-mocha-mauve &>/dev/null; sudo pacman -Rns --noconfirm qt5-virtualkeyboard &>/dev/null; sudo pacman -Rns --noconfirm qt6-virtualkeyboard &>/dev/null
sleep 2
echo
echo "Installing Catppuccin Theme & Packages"
echo "######################################"
# Check if any of the specified packages are installed and install them if not present
packages="lightly-git xero-catppuccin-sddm asian-fonts lightlyshaders-git xero-catppuccin-wallpapers tela-circle-icon-theme-dracula-git python-pip gnome-themes-extra gtk-engine-murrine gtk-engines xero-fonts-git"
echo
echo "Installing required packages..."
echo "###############################"
for package in $packages; do
    pacman -Qi "$package" > /dev/null 2>&1 || sudo pacman -Syy --noconfirm --needed "$package" > /dev/null 2>&1
done
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~ && cp -Rf Configs/Home/.config/latte ~/.config/
sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
sleep 2
echo
echo "Applying Our Custom Grub Theme..."
echo "#################################"
chmod +x Grub.sh
sudo ./Grub.sh
sudo sed -i "s/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=1920x1080/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sleep 2
echo
# Clone GTK theme repository and install
echo "Installing catppuccin GTK4 theme & Applying LibAdwaita Patch"
echo "############################################################"
git clone --recurse-submodules https://github.com/catppuccin/gtk.git && cd gtk/
python install.py mocha -l -a mauve --tweaks normal -d ~/.themes && cd .. && rm -Rf gtk/
sleep 2
echo
# Clone KDE theme repository and install
echo "Installing catppuccin KDE theme, Plz answer with y both times.."
echo "###############################################################"
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde && cd catppuccin-kde && sh install.sh 1 4 2 && cd .. && rm -Rf catppuccin-kde/
sleep 2
echo
# Update SDDM configuration
echo "Updating SDDM configuration..."
echo "##############################"
sudo sed -i "s/Current=.*/Current=catppuccin/g" /etc/sddm.conf.d/kde_settings.conf 2>/dev/null
sleep 2
echo
echo "Applying Flatpak GTK Overrides"
echo "##############################"
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
echo
sleep 1.5
echo "Converting Current Theme to Flatpak"
echo "###################################"
sleep 1.5
stylepak install-system Catppuccin-Mocha-Standard-Mauve-Dark && stylepak install-user Catppuccin-Mocha-Standard-Mauve-Dark
sleep 2
rm -rf xero-catppuccin-git/
echo
echo "#############################################"
echo "  All Done! Reboot system To activate rice.  "
echo "#############################################"
