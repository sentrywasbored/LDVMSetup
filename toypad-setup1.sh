sudo apt update
sudo apt install -y git usbip hwdata curl python build-essential libusb-1.0-0-dev libudev-dev
echo "usbip-core" | sudo tee -a /etc/modules
echo "usbip-vudc" | sudo tee -a /etc/modules
echo "vhci-hcd" | sudo tee -a /etc/modules

echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules
echo "libcomposite" | sudo tee -a /etc/modules
echo "usb_f_rndis" | sudo tee -a /etc/modules

git config pull.rebase false
git clone https://github.com/Berny23/LD-ToyPad-Emulator.git
cd LD-ToyPad-Emulator

printf '\necho "usbip-vudc.0" > UDC\nusbipd -D --device\nsleep 2;\nusbip attach -r debian -b usbip-vudc.0\nchmod a+rw /dev/hidg0' >> usb_setup_script.sh
sudo curl https://raw.githubusercontent.com/virtualhere/script/main/install_server | sudo sh

sudo cp usb_setup_script.sh /usr/local/bin/toypad_usb_setup.sh
sudo chmod +x /usr/local/bin/toypad_usb_setup.sh
(sudo crontab -l 2>/dev/null; echo "@reboot sudo /usr/local/bin/toypad_usb_setup.sh") | sudo crontab -
sudo shutdown -r now