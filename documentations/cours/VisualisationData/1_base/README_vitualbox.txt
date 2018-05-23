
Si vous utilisez Virtualbox vous pouvez  installer les extensions   qui permettent d'ajuster la taille de l'écran est de monter un répertoire partagé entre l'hôte(Mac OS ou Windows ou Linux) et le guest Ubuntu 16.04.1:

Cela marche bien avec :

VirtualBox 5.0.30

et 

Ubuntu 16.04.1 LTS (64bits)
———————
Marche à suivre:

installer :

VirtualBox 5.0.30

telecharger:
ubuntu-16.04.1-desktop-amd64.iso

depuis par exemple: https://www.ubuntu.com/download/desktop/thank-you?version=16.04.1&architecture=amd64


créer une machine virtuelle avec cette distribution.

puis créer un repertoire partagé depuis l'interface de VirtualBox.

puis sous le guest Ubuntu:

sudo apt-get install virtualbox-guest-additions-iso

sudo apt-get install virtualbox-guest-utils


ajouter votre utilisateur ("myuser") dans le groupe vboxsf afin qu'il puisse lire le repertoire partagé:
sudo usermod -a -G vboxsf myuser

reboot

aller dans /media/"mon_rep_share" et le lire ou y ecrire.


