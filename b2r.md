#---- Initialiser sur VBox ----
1 / Iso Debian : https://www.debian.org/download
2 / Machine name : bloup, Machine folder : sgoinfre/VM , Linux, Debian 64 bits
3 / RAM 1024mb
4 / Create hard disk now
5 / VDI
6 / Dynamically allocated
7 / Sgoinfre , 8gb


#---- Ajouter l'iso à la VM ----

1 / Settings
2 / Storage
3 / Controller:IDE - Empty
4 / Optical Drive
5 / Chose a disk file


#---- Installation ---

1 / Choisir install
2 / English : langue de l'Installation
3 / France : Pays de notre VM
4 / USA - American english pour le keyboard
5 / Hostname : arudy42
6 / Configure Network : laisser blanc, pas de NDD à confgurer
7 / Root psw : MDP intra / Confirmer a nouveau ensuite
8 / Nom Complet : Arthur Rudy, pour un second user
9 / Login : arudy
10 / MDP intra / Confirmer ensuite le MDP
11 / Guided - use entire disk qnd setup encrypted LVM
12 / Next
13 / Separate home, pour partitionner ensuite
14 / Passphrase = MDP / Confirmer
15 / Ecrire max pour donner la full size du disque
16 / Finish partitioning
17 / Yes
18 / Scan extra installation media  / No
19 / Deb archive mirror config : France
20 / ded.debian.org
21 / Blank for proxy
22 / ? Message d'erreure ?
23 / Partagede donnees ? No
24 / System minimal blabla
25 / Installer Grub : Yes. Pour lancer l'OS au demarrage
26 / dev/sda pour installer le grub
27 / Continue


#---- Redemarrer la VM ----

1 / MDP intra
2 / arudy
3 / MDP intra

Fin installation, prompt terminal = arudy@arudy42


----------------------------------------------------------------------------------------

#---- Setup Sudo ----

1 / (Se mettre en superuser cmd = su)
2 / apt-get install sudo
2 / apt-get update / apt-get upgrade
3 / sudo visudo : Acceder au fichier user sudo
4 / Ajouter la ligne "arudy	ALL=(ALL:ALL) ALL" en dessous de root

#---- Installer ifconfig ----

1 / apt-get install net-tools
Sinon utiliser 'ip addr'


#---- Setup serveur SSH ----

1 / sudo apt-get install openssh-server (deja installé normalement)
2 / sudo systemctl status sshd
3 / cd /etc/ssh
4 / vi sshd_config
5 / Changer Port 21 en 4242
6 / PermitRootLogin no : pour ne pas pouvoir se connecter en root par ssh
7 / sudo systemctl restart ssh
8 / sudo systemctl status ssh


#---- Connexion depuis terminal sur la VM en SSH ----

1 / ss -tunlp : Sur pc hote pour checker les ports utilisé (4242 deja utilisé)
2 / Sur VB -> Settings -> network -> advanced -> Port Forwarding
3 / Name = SSH ; Protocol = TCP ; Host IP = (ifconfig host machine inet) 10.12.6.12 ; Host Port = 42420 (Port de sortie du host) ; Guest IP = NULL ; Guest Port = 4242
1 / ssh arudy@10.12.6.12(inet) -p42420
2 / MDP


#---- Setup UFW ----

1 / sudo apt install ufw
2 / sudo ufw status verbose -> Status: inactive
3 / sudo ufw app info openSSH -> Port 22/tcp
4 / sudo ufw allow OpenSSH -> Autoriser les connexions entrantes SSH
5 / sudo ufw enable -> Mettre en route ufw
6 / sudo ufw allow 4242
7 / sudo ufw status numbered -> checker que les ports 4242 sont bien activés, et que ceux là


#---- Changer hostname ----

1 / hostnamectl = afficher hostname
2 / sudo hostnamectl set-hostname [New_Hostname]
3 / hostnamectl = afficher hostname


#---- Gestion user && groupes ----

1 / users = Afficher tous les users de la machine
2 / groups = afficher les groupes d'un user
3 / En su cd/home && ls -l = afficher les users et leurs groupes
4 / addgroup user42
5 / usermod -g user42 arudy
6 / groups arudy en su pour checker si bien root
7 / getent group (| cut -d: -f1) = lister tous les groupes
(adduser arudy sudo en su -)


#---- CMD ----

lsblk = Afficher les periph bloc, sans la ram, en arbo. --help pour avoir le detail des colonnes
apt install vim
apt-cache policy openssh-server = Checker si openSSH est installé sur le serveur
sudo reboot
sudo systemctl poweroff
ss -tulnp pour voir les ports ouvert de la machine (t = ports tcp, u = port udp, l = ports en ecoutes, n = ip et ports au lieu des DNS, p = processus lié à chaque port)
sudo ufw enable / disable / reset


#---------- DOCS --------

https://www.debian.org/ = pour l'iso debian

LVM(logical volumes manager) = https://www.linuxtricks.fr/wiki/lvm-sous-linux-volumes-logiques

Diff entre apt et aptitude = Ce sont deux interfaces diff de dpkg (gestionnaire de paquets), aptitude + récent et plus facile à utiliser. Evite apt-get... J'ai tjrs utiliser apt perso. https://www.it-swarm-fr.com/fr/apt/quelle-est-la-difference-entre-apt-get-et-aptitude/961623026/

SSH (Secure SHell) = https://www.it-connect.fr/modules/introduction-a-ssh/
openssh = App à l'écoute des connexions entrantes du server

OCR SSH https://openclassrooms.com/fr/courses/43538-reprenez-le-controle-a-laide-de-linux/41773-la-connexion-securisee-a-distance-avec-ssh

Connexion à distance ssh : https://doc.ubuntu-fr.org/ssh

Diff entre 32 et 64 bits : https://www.portables.org/blog/differences-entre-les-versions-32-ou-64-bits-expliques-par-notre-expert-n49#:~:text=%2D%20Une%20architecture%20(processeur%20%2B%20Windows,exploitations%20et%20les%20cartes%20m%C3%A8res.

Diff entre ssh & sshd : ssh coté client, sshd coté serveur. Pas bien compris la diff...

Diff UDP TCP : TCP (Transmition Control Protocol) = Protocole fiable, c'est à dire transmet l'int2gralité des paquets de la machine A à B (telechargement de film, on veut tout, sans perte de paquets). UDP (User Datagram Protocol) Protocole non fiable, pas de numerotation des paquets, peut perdre des paquets utilse en VOip ou streqming par exemple.

UFW : https://fr.joecomp.com/how-set-up-firewall-with-ufw-debian-9
Uncomplicated Firewall, pare feu plus facile a configurer que ceux deja present sur debian. De base UFW bloque toutes les entrees du serveur, sauf celles des ports ouverts biensur, les sortis sont toutes ouvertes.

Groupes et users : https://devconnected.com/how-to-list-users-and-groups-on-linux/
https://openclassrooms.com/fr/courses/43538-reprenez-le-controle-a-laide-de-linux/39044-les-utilisateurs-et-les-droits

Gestion de MDP fort avec pwquality: https://blog.malandra.be/forcer-lutilisation-de-mot-de-passe-complexe/
https://debian-facile.org/doc:securite:passwd:libpam-pwquality
PAM : https://fr.wikipedia.org/wiki/Pluggable_Authentication_Modules


