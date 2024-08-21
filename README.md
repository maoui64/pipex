# pipex

Objectif :
-
  - Etape 1 : on execute une commande sur <infile> (on traite infile comme une entree : a la place de l'entree standart 0(STDIN)).
  - Etape 2 : on recupere le resultat(sortie) de l'etape 1 pour executer une nouvelle commande.
La sortie de l'etape 1 devient a nouveau l'entree de la nouvelle commande.
La sortie de cette etape est enfin stockee dans <outfile> (outfile devient la sortie a la place de la sortie standart 1 (STDOUT)).

Les notions importantes a retenir sont :
  - les entrees et sorties standard (STDIN, STDOUT (et stderr))
  - on a 2 execution de commandes/programmes (les commandes de shell sont des programmes pre-enregistrees dans le shell).

SAUF QUE : pour executer un programme exterieur a notre programme/process actuel en utilisant la fonction execve, 
cela ferme le programme/process actuel (comme un return ou exit). Donc a la fin de l'etape 1, le process/programme est interrompue.

Parent et Child Process (fork).
-

Pour cela nous allons utiliser la fonction fork. Elle vient creer une copie du process actuel : le child process, la copie du parent process. 
Ces 2 process ont les memes informations aux moments du fork et vont suivre la suite du programme en meme temps. 

Pour les identifier, le resultat de fork est un PID (= Process IDentifier). 
Lorsque l'on est dans le child process, ce PID == 0 alors que dans le parent, le PID == nombre random (mais jamais == 0).

Ce fork va me permettre de realiser 2 execution de programme car je peux : 
  - envoyer le child process faire la premiere execution (etape 1) (grace a un simple if(PID == 0)), 
  - recuperer la sortie de cette execution (on y vient juste apres)
  - et faire la deuxieme execution (etape 2) a l'aide du parent process.

Communication entre process (pipe).
-

Mais voila un nouveau probleme : le resultat de l'etape 1 va sortir sur la sortie standart 1 (STDOUT).
Et on ne peut pas recuperer cette sortie pour 2 raisons :
  - on ne peut pas recuperer les informations sortie sur STDOUT comme ca
  - on ne peut pas communiquer les informations d'un process a l'autre aussi facilement.

On va donc utiliser la fonction pipe. Cela cree un tube permettant de faire passer une information d'un process vers un autre process.
Cette fonction cree 2 file descriptors (fd) : 
  - 1 entree du tube dans lequel on envoie des informations (ecriture),
  - 1 sortie du tube dans lequel on recupere les informations (lecture).

Ces 2 fd sont pointes par un array de 2 int (ici d2claration de tube[2]). 
Au contraire de STDIN == 0 et STDOUT == 1, tube[1] est l'endroit ou nous ecrivons l'info et tube[0] est l'endroit ou nous la lisons.
Dans notre exercice, on doit mettre le resultat de l'etape 1 dans tube[1] dans le child process pour que le parent process recupere l'information dans le tube[1].

Entrees et Sorties (dup2).
-

Pour cela, nous allons utiliser la fonction dup2. Elle prends un fd et le remplace par un nouveau. Ca tombe bien STDIN et STDOUT sont en fait des fd !

A l'aide de cette fonction, nous allons pour l'etape 1 ;
  - remplacer le STDIN par notre infile
  - remplacer le STDOUT par notre entree de tube : tube[1]

De cette maniere, quand on execute notre premiere commande : 
  - l'entree pour cette commande est infile (meme pas besoin de faire un read)
  - la sortie de cette excution ne va pas s'afficher sur le terminal (STDOUT) mais venir s'ecrire sur tube[1] (entree du tube).

Du coup pour l'etape 2 :
  - remplacer STDIN par tube[0] (la sortie du tube)
  - remplacer STDOUT par outfile.

De cette maniere, quand on execute notre deuxieme commande :
  - l'entree pour cette commande est tube[0],
  - la sortie est outfile (meme pas besoin de faire un write(oufile, ..., ...)).

.

Le plus complique a comprendre est passe. 
-
.

Enfin pour retrouver nos commandes, nous allons avoir besoin d'une nouvelle variable dans le main. 

Nous avons besoin de la variable char **envp. 
Elle represente l'environnement de notre ordinateur et nous permettre de recuperer le chemin de chacune des commandes qui sont deja pre-enregistree pour l'utilisation dans shell.

On va donc recuperer tous les paths possibles ou pourraient etre stocker les programmes de nos commandes shell.

Nous avons besoin du path de chaque commande pour utiliser la fonction execve.
