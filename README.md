# GWJ91 - Projet sans titre pour l'instant

Ce projet est la soumission pour la Godot Wild Jam #91 de l'équipe suivante :

- Raphaël Bonneval
- Mario Giraud
- Brice Maussang
- Yvan Roux
- Valentin Rigolle

Le projet est basé sur le template de Maaack : [Voir le README du template](./MAAACK_README.md)

## Présentation du jeu

## Résumé et objectifs

Le but du jeu est de préparer un cambriolage. Sur votre bureau, vous avez le plan du bâtiment dans lequel vous
allez vous infiltrer : vous avez un temps limité pour prendre des notes avant que la simulation de cambriolage
commence ! La nuit tombée, vous ne voyez rien, donc vous devrez vous baser uniquement sur vos notes.
Déplacez-vous discrètement de pièce en pièce, en évitant les gardes, les meubles et les chats qui roupillent.
Atteignez votre butin et ramenez-le sans vous faire repérer !


### Boucle de gameplay

Le jeu est découpé en niveaux, qui se déroulent en 2 phases :

- Phase de reconnaissance : le joueur voit un plan du bâtiment à infiltrer. On peut y voir la configuration des pièces,
les rondes des gardes, l'emplacement des caméras, etc. Il a un temps limité pour prendre des notes par-dessus le plan.
- Phase d'infiltration : le joueur essaye maintenant de s'infiltrer dans le bâtiment. Il fait maintenant sombre et le
plan est caché. Le joueur peut déplacer son personnage dans le bâtiment à infiltrer, mais il ne voit rien. En se basant
sur les indices sonores, les notes qu'il a prises et parfois sur ses erreurs (se cogner à un meuble, etc.), il doit
atteindre son butin et le ramener.

Chaque niveau est contextualisé par un scénario : qui est le voleur et pourquoi cherche-t-il à cambrioler cet endroit
en particulier ? Les niveaux suivent une trame narrative cohérente qui amènent le joueur à découvrir des personnages
issus de milieux divers, leurs situations, leurs problématiques.

#### Phase de reconnaissance

#### Phase d'infiltration 

Mécaniques de gameplay importantes :

- Contrôle du personnage à la souris : cela donne une impression "organique" et un peu "fouillie" pour diriger son
personnage. Calme, le joueur peut être précis et naviger parmi les obstacles, mais dans la panique, les mouvements
soudains peuvent amener son personnage à faire du bruit en se cognant dans les meubles.
    - Le personnage se dirige vers le curseur de la souris en ligne droite. C'est au joueur de s'assurer qu'il n'y a
    pas d'obstacle sur la trajectoire du personnage.
    - Le personnage a une vitesse maximale de course. Cette vitesse peut être affectée si le joueur transporte un
    butin lourd, par exemple une télévision.
- Le personnage ne voit pas son environnement, seulement ses notes. Les notes sont superposées à la pièce dans lequel
le personnage se trouve, et peuvent donc servir à marquer l'emplacement des obstacles pour les éviter.
- La perception de l'environnement passe par le son : un chat qui miaule, des bruits de pas d'un garde, etc. Ces indices
sonores sont aussi représentés graphiquement, par des onomatopées par exemple.
    - Si le personnage se cogne contre un meuble par exemple, le joueur peut avoir un bref indice visuel sur
    l'emplacement de l'obstacle.
- Le bruit que fait le joueur a des conséquences. Notamment, il peut se faire repérer s'il n'est pas assez prudent. 
Selon les niveaux, les risques peuvent être une personne qui dort, des gardes qui patrouillent ou encore des caméras 
fixes. Le joueur a droit à l'erreur : s'il fait un peu de bruit à proximité d'un garde, ce dernier va se méfier et aller
fouiller la source du son, mais pas déclencher immédiatement un game over. Le game over arrive si le joueur se fait
attraper.
- Le joueur peut interagir avec certains éléments de l'environnement.
    - Des portes peuvent être dévérouillées.
    - Des meubles peuvent être déplacés.
- Certaines missions peuvent être effectuées par plusieurs voleurs en même temps. Le joueur les contrôle à tour de rôle.

### Style graphique

Le jeu adopte un style en noir et blanc, inspiré des polars noirs avec par exemple _Sin City_ comme référence. Le
contexte du jeu, une préparation de cambriolage à partir d'un plan et de notes dessinés sur un bureau, se prête à
une esthétique "dessinée à la main".

Les notes du joueur sont en couleur pour contraster avec l'environnement.

### Sound design

Le son admet un rôle particulièrement important : avec les notes du joueur, c'est le principal retour sensoriel
lors des phases d'infiltration. Quelques exemples de sons :

- Les bruits de pas reflètent la surface du sol (plancher, carrelage, moquette, etc.) et la précipitation du joueur
(courir fait plus de bruit).
- Les gardes et autres personnages qui patrouillent émettent également des bruits de pas.
- Les habitants endormis peuvent ronfler.
- Des éléments de décor peuvent émettre des sons (le tic-tac d'une horloge).
- Se cogner contre un meuble fait du bruit.
- Des bruits de fond créent une ambiance pendant l'infiltration : bruit de ville, circulation au loin, sirènes...

Pour faire du son une information exploitable par le joueur et augmenter l'immersion, le son est __spatialisé__ et 
est affecté par l'environnement (un bruit de l'autre côté d'un mur est atténué).

### Narration

La narration passe par deux vecteurs principaux :

- Un scénario explicite, qui permet d'introduire et de conclure chaque niveau, et de faire la transition entre les
niveaux.
- Des éléments de décors, par exemple des coupures de journal sur le bureau, qui permettent d'approfondir l'univers
du jeu et la place qu'y prennent les cambriolages qu'on effectue.

## Développement du jeu

### Prototype

Un premier prototype du jeu sera produit avec un nombre restreint d'éléments :

- Un seul niveau simple, de 2 ou 3 salles.
- Un seul "ennemi", une personne qui dort à ne pas réveiller.
- Un seul butin à ramener.
