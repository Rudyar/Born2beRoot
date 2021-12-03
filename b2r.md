# BORN 2 BE ROOT
![artist](artist.png)


# ---- Initialiser sur VBox ----

1 / Iso Debian : https://www.debian.org/download

2 / Machine name : bloup, Machine folder : sgoinfre/VM , Linux, Debian 64 bits

3 / RAM 1024mb

4 / Create hard disk now

5 / VDI

6 / Dynamically allocated

7 / Sgoinfre , 8gb


# ---- Ajouter l'iso à la VM ----

1 / Settings

2 / Storage
3 / Controller:IDE - Empty

4 / Optical Drive

5 / Chose a disk file


# ---- Installation ---

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


# ---- Redemarrer la VM ----

1 / MDP intra

2 / arudy

3 / MDP intra

Fin installation, prompt terminal = arudy@arudy42


----------------------------------------------------------------------------------------

# ---- Setup Sudo ----

1 / (Se mettre en superuser cmd = su)

2 / apt-get install sudo

2 / apt-get update / apt-get upgrade

3 / sudo visudo : Acceder au fichier user sudo

4 / Ajouter la ligne "arudy	ALL=(ALL:ALL) ALL" en dessous de root

# ---- Installer ifconfig ----

1 / apt-get install net-tools

Sinon utiliser 'ip addr'


# ---- Setup serveur SSH ----

1 / sudo apt-get install openssh-server (deja installé normalement)

2 / sudo systemctl status sshd

3 / cd /etc/ssh

4 / vi sshd_config

5 / Changer Port 21 en 4242

6 / PermitRootLogin no : pour ne pas pouvoir se connecter en root par ssh

7 / sudo systemctl restart ssh

8 / sudo systemctl status ssh


# ---- Passer en ip statique ----

Passage en static pour kill le port 68

1 / /etc/network/interface
        iface enp0s3 inet static
        address 10.0.2.15 // ifconfig inet = mon ip machine
        netmask 255.255.255.0 // ifconfig | netmask = masque de sous reseau qui permet de reunir les machines dans le meme reseau
        broadcast 10.0.2.255 // ifconfig | permet de diffuser un paquet dans notre reseau
        gateway 10.0.2.2 // A la connexion sur la VM, la derniere adresse passe en paramettre | Passerelle permetant d'acceder a internet > sorte de route pour les paquets
    Acceder a internet en changeant le resolveur de nom de domaine
        etc/resolv.conf // changer le serveur dns avec celui de google 8.8.8.8
    Ajouter l'ip de la machine hote dans la config de VirtualBox
        ipconfig > inet de la partie enp0s3

# ---- Connexion depuis terminal sur la VM en SSH ----

1 / ss -tunlp : Sur pc hote pour checker les ports utilisé (4242 deja utilisé)

2 / Sur VB -> Settings -> network -> advanced -> Port Forwarding
3 / Name = SSH : Protocol = TCP ; Host IP = (ifconfig host machine inet) 10.12.6.12 ; Host Port = 42420 (Port de sortie du host) ; Guest IP = NULL ; Guest Port = 4242

1 / ssh arudy@10.12.6.12(inet) -p42420

2 / MDP


# ---- Setup UFW ----

1 / sudo apt install ufw

2 / sudo ufw status verbose -> Status: inactive

3 / sudo ufw app info openSSH -> Port 22/tcp

4 / sudo ufw enable -> Mettre en route ufw

5 / sudo ufw allow 4242

6 / sudo ufw status numbered -> checker que les ports 4242 sont bien activés, et que ceux là


# ---- Changer hostname ----

1 / hostnamectl = afficher hostname

2 / sudo hostnamectl set-hostname [New_Hostname]

3 / hostnamectl = afficher hostname


# ---- Gestion user && groupes ----

1 / users = Afficher tous les users de la machine

2 / groups = afficher les groupes d'un user

3 / En su cd/home && ls -l = afficher les users et leurs groupes

4 / addgroup user42

5 / usermod -g user42 arudy

6 / groups arudy en su pour checker si bien root

7 / getent group (| cut -d: -f1) = lister tous les groupes

(adduser arudy sudo en su -)

# ---- Ajouter un user ----

1 / adduser "username"

# ---- Politique de password forte ----

1 / sudo apt-get install libpam-pwquality

2 / sudo cp /etc/pam.d/common-password /etc/pam.d/common-password-backup = Backup du fichier common-password au cas ou

3 / sudo vim /etc/pam.d/common-password = Ouvrir le fichier de config de pw

4 / Modifier la ligne password requisite avec :

minlen=10 : Longueure min du mdp

ucredit=-1 : Au moins une maj

dcredit=-1 : Au moins un chiffre

maxrepeat=3 : Max 3 chars identiques à la suite

reject_username : pas username dans le mdp

enfore_for_root : Regles appliauees au root

difok=7 : Au moins 7 chars diff de l'ancien mdp

### Changement frequence modif de mdp

5 / sudo vim /etc/login.defs

6 / Modifier lignes : PASS_MAX_DAYS	30 ; PASS_MIN_DAYS	2 ; PASS_WARN_AGE	7

7 / sudo passwd -e arudy = Forcer tous les users à changer leur mdp à la prochaine connexion ?????

# ---- Politique de mdp & logs sudo ----

1 / sudo visudo

2 / Defaults        passwd_tries=5 : Ajouter cette ligne

3 / Defaults	    insults : Ajouter celle la

4 / Defaults	    requiretty

5 / Ajouter "/snap" avant le dernier "bin" dans la ligne secure_path


# ---- Fichier log sudo ----

1 / cd /var/log

2 / mkdir sudo && cd sudo && touch sudo.log

3 / sudo visudo

4 / Defaults	logfile="/var/log/sudo/sudo/log"

5 / Defaults	log_input,log_output (Pas sur d'en avoir besoin)


# ---- Broadcast toutes les 10 min ----

1 / cd /etc

2 / sudo vim crontab

3 / */10 * * * * root bash /etc/init.d/monitoring.sh

5 / Mettre monitoring.sh dans /etc/init.d


# ---- CMD ----

lsblk = Afficher les periph bloc, sans la ram, en arbo. --help pour avoir le detail des colonnes

apt install vim

apt-cache policy openssh-server = Checker si openSSH est installé sur le serveur

sudo reboot

sudo systemctl poweroff

ss -tulnp pour voir les ports ouvert de la machine (t = ports tcp, u = port udp, l = ports en ecoutes, n = ip et ports au lieu des DNS, p = processus lié à chaque port)

sudo ufw enable / disable / reset

ping google.com

sudo apt install sysstat : pour avoir le systeme monitoring pas degeu

# ---------- DOCS --------

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
https://linux.die.net/man/8/pam_pwquality
PAM : https://fr.wikipedia.org/wiki/Pluggable_Authentication_Modules

Changement de mdp regulier : https://blog.malandra.be/forcer-le-changement-regulier-de-mot-de-passe-sous-linux/

Adduser : https://doc.ubuntu-fr.org/adduser

tty : affiche sur le terminal (sortie standard) le nom du fichier de l'entree standard. (Pas vraiment compris le truc...)
https://fr.wikipedia.org/wiki/Tty_(Unix)

Sudo log : https://www.tekfik.com/kb/linux/advance-linux/sudo-log-configuration-on-linux

ram usage : https://www.cyberciti.biz/faq/linux-check-memory-usage/
https://www.binarytides.com/linux-command-check-memory-usage/

awk : https://likegeeks.com/awk-command/

cpu load : https://www.baeldung.com/linux/get-cpu-usage

ether / MAC : https://www.cyberciti.biz/tips/change-or-find-out-display-ethernet-mac.html

ip static : https://www.ionos.fr/assistance/serveurs-et-cloud/serveur-dedie-pour-les-serveurs-achetes-avant-le-28102018/reseau/modifier-ou-ajouter-une-adresse-ipv4-a-un-serveur-dedie-linux/

# ---- A checker avant la soutenance ----

swap

tty

lvm

apparmor

static ip
