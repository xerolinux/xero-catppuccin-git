#!/bin/bash
#set -e
echo "##########################################"
echo "Be Careful this will override your Rice!! "
echo "##########################################"
sleep 2
echo
echo "Backing up current XeroASCII      "
echo "##################################"
# Check if XeroASCII.old file exists in /etc/
if [ -f "$HOME/XeroAscii.old" ]; then
    echo "Deleting existing XeroAscii.old file..."
    sudo rm $HOME/XeroAscii.old
fi
# Rename XeroASCII to XeroASCII.old
if [ -f "$HOME/XeroAscii" ]; then
    echo "Renaming XeroAscii to XeroAscii.old..."
    sudo mv $HOME/XeroAscii $HOME/XeroAscii.old
fi
echo
echo "Substituting some Packages with others"
echo "######################################"
# Check if kvantum and latte-dock exist
if pacman -Qs kvantum && pacman -Qs latte-dock && pacman -Qs catppuccin-cursors-mocha-mauve && pacman -Qs catppuccin-gtk-theme-mocha-mauve && pacman -Qs catppuccin-kde-theme-mauve-git; then
  # Remove kvantum and latte-dock
  sudo pacman -Syy && sudo pacman -Rns --noconfirm kvantum latte-dock catppuccin-cursors-mocha-mauve catppuccin-gtk-theme-mocha-mauve catppuccin-kde-theme-mauve-git > /dev/null 2>&1
  echo
  # Install latte-dock-git and lightly-git
  sudo pacman -S latte-dock-git lightly-git --noconfirm --needed > /dev/null 2>&1
fi
sleep 2
echo
echo "Installing Catppuccin Theme & Packages"
echo "######################################"
# Check if any of the specified packages are installed and install them if not present
packages="xero-kde-config xero-catppuccin-sddm asian-fonts lightlyshaders-git xero-catppuccin-wallpapers tela-circle-icon-theme-dracula-git python-pip gnome-themes-extra gtk-engine-murrine gtk-engines"
echo
echo "Installing required packages..."
for package in $packages; do
    pacman -Qi "$package" > /dev/null 2>&1 || sudo pacman -Syy --noconfirm --needed "$package" > /dev/null 2>&1
done
sleep 2
echo
echo "Removing No longer needed Packages"
sudo pacman -Rns --noconfirm catppuccin-kde-theme-mauve-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-cursors-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-kde-theme-git &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-gtk-theme-mocha-mauve &>/dev/null; sudo pacman -Rns --noconfirm catppuccin-cursors-mocha-mauve &>/dev/null; sudo pacman -Rns --noconfirm qt5-virtualkeyboard &>/dev/null; sudo pacman -Rns --noconfirm qt6-virtualkeyboard &>/dev/null
sleep 2
echo
# Clone GTK theme repository and install
echo "Installing catppuccin GTK4 theme & Applying LibAdwaita Patch"
git clone --recurse-submodules https://github.com/catppuccin/gtk.git && cd gtk/ && pip3 install -r requirements.txt
python install.py mocha -l -a mauve --tweaks normal -d ~/.themes && sh /usr/local/bin/stylepak install-system Catppuccin-Mocha-Standard-Mauve-Dark && cd .. && rm -Rf gtk/
sleep 2
echo
# Clone KDE theme repository and install
echo "Installing catppuccin KDE theme, Plz answer with y both time..."
git clone --depth=1 https://github.com/catppuccin/kde catppuccin-kde && cd catppuccin-kde && sh install.sh 1 4 2 && cd .. && rm -Rf catppuccin-kde/
sleep 2
echo
# Update SDDM configuration
echo "Updating SDDM configuration..."
sudo sed -i "s/Current=.*/Current=catppuccin/g" /etc/sddm.conf.d/kde_settings.conf 2>/dev/null
sleep 2
echo
echo "Creating Backup & Applying new Rice, hold on..."
echo "###############################################"
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -Rf Configs/Home/. ~ && cp -Rf Configs/Home/.config/latte ~/.config/ && sudo cp -Rf Configs/System/. / && sudo cp -Rf Configs/Home/. /root/
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
echo "#############################################"
echo "  All Done! Reboot system To activate rice.  "
echo "#############################################"
