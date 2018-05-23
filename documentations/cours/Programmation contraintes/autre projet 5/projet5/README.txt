PUZZLE:

////////////// LES FICHIERS ////////////

Le fichier 'puzzle.mzn' contient la modélisation du problème et sa résolution.
Le fichier 'puzzle.dzn' contient les données du problème.
Le fichier 'solution' doit être modifié pour faire fonctionner l'affichage.(voir plus bas)

Le jar 'puzzle.jar' est un exécutable java pour :
	- créer un dzn correspondant à un problème
	- afficher le résultat de façon compréhensible

Pour une utilisation rapide du jar voir plus bas (I/ 2)Exemple existant))
IMPORTANT:Pour une utilisation avec mélange des directions ou/et mélange des tuiles voir plus bas(   I/1) et I/2)  )


////////////// DOSSIERS ////////////

DOSSIER problems: contient les problèmes jusqu'au n7 (7*7 plateau)
DOSSIER results: contient l'affichage des problèmes avec les dzns de base(sans rotation ou positionnement mélangé).
DOSSIER dzns: contient les dzns de base(sans rotation ou positionnement mélangé).
DOSSIER solutions: contient les solutions des dzns de base(sans rotation ou positionnement mélangé).

////////////// PLUS ////////////

Pour une utilisation plus poussé avec changement du modèle type...etc lire entièrement(pas nécessaire pour le projet).

////////////// JAR ////////////


/****************************************************************************************************************/
/** RAPPEL                 **************************************************************************************/
/****************************************************************************************************************/
Lancer un jar java exécutable:

- java -jar puzzle.jar [0..i]

[0..i]:les arguments du jar séparé par un espace.

/****************************************************************************************************************/
/** I / ULILISATION RAPIDE DU JAR *******************************************************************************/
/****************************************************************************************************************/

A utiliser quand on se moque d'écraser les .dzn précédents.
A utiliser quand on veut utiliser le "modele_type" pour la modélisation des pièces.
A utiliser quand on se moque d'écraser les resultats précédents.

/****************************************************************************************************************/
/** 1)LES ARGUMENTS *********************************************************************************************/
/****************************************************************************************************************/
[0]-p genereDznAndProblem:
	[1]:nomFichierOriginel : les tuiles modéliser avec les éléments dans modelisation

[0]-ps ->genereDznAndProblem avec un shuffle en plus : directions des tuiles alétoires à l'initialisation.
	[1]:nomFichierOriginel : comme précédemment.	

[0]-ps+ ->genereDznAndProblem avec un shuffle en plus : directions et positions des tuiles alétoires à l'initialisation.
	[1]:nomFichierOriginel : comme précédemment.	

[0]-r  ->generateResult:
	[1]:nomFichierSolution : un fichier avec votre solution (suivant le format de l'exemple: ex/exemple_solution);

/****************************************************************************************************************/
/** 2)Exemple ***************************************************************************************************/
/****************************************************************************************************************/
	- créer un fichier problem avec la spec de modélisation des tuiles.
	- 'java -jar puzzle.jar -p problem' ou 'java -jar puzzle.jar -ps problem' ou 'java -jar puzzle.jar -ps+ problem'
	- utiliser minizinc avec puzzle.mzn et le puzzle.dzn généré.
	- copier la solution de minizinc dans un fichier "solution" a côté du jar
	- 'java -jar puzzle.jar -r solution'
	- voir le résultat dans le fichier result généré.

/****************************************************************************************************************/
/** 2)Exemple existant ******************************************************************************************/
/****************************************************************************************************************/
	- Le dossier problemes contient les problèmes de taille 3x3,4x4,5x5,6x6 et 7x7 sous le nom n3, n4 ... 
	  Ils sont extraits du plateau présenté dans le sujet, sans mélange, ils donnent donc déjà une solution.

	- 'java -jar puzzle.jar -p problemes/n3'
	-  exec puzzle.mzn with puzzle.dzn
	- 'java -jar puzzle.jar -r solutions/n3'
	
	- resultat dans result

/****************************************************************************************************************/
/** I / ULILISATION COMPLETE ***********************************************************************************/
/****************************************************************************************************************/
A utiliser quand on veut garder les .dzn.
A utiliser quand on veut prendre en compte une nouvelle modélisation.
A utiliser quand on veut garder les différents résultats.
/****************************************************************************************************************/
/** 1)LES ARGUMENTS *********************************************************************************************/
/****************************************************************************************************************/
[0] : le fichier représentant la modélisation des pièces (même format que l'exemple: modele_type)
[1]-p genereDznAndProblem:
	[2]:nomFichierOriginel : les tuiles modéliser avec les éléments dans modelisation
	[3]:nomFichierDzn : le fichier .dzn que vous voulez générer
	[4]:nomFichierProblem : le problème modéliser avec l'indexation du jar. (utile pour l'affichage).
[1]-ps ->genereDznAndProblem avec un shuffle en plus : directions des tuiles alétoires à l'initialisation.
	[2]:nomFichierOriginel : [3]:nomFichierDzn : [4]:nomFichierProblem : comme précédemment.	
[1]-r  ->generateResult:
	[2]:nomFichierProblem : les tuiles modéliser avec l'indexation du jar.
	[3]:nomFichierSolution : un fichier avec votre solution (suivant le format de l'exemple: ex/exemple_solution);
	[4]:nomFichierAffichage : le fichier représentant le résultat de votre solution.

/****************************************************************************************************************/
/** 2)EXEMPLE D'UTILISATION AVEC L'EXEMPLE EXISTANT ********************************************************/
/****************************************************************************************************************/
	- 'java -jar puzzle.jar modele_type -p ex/exemple_origine ex/exemple_origine.dzn ex/exemple_problem_origine'
	- 'java -jar puzzle.jar modele_type -r ex/exemple_problem_origine ex/exemple_solution ex/exemple_affichage'

/****************************************************************************************************************/
/** 3)EXEMPLE D'UTILISATION COMPLETE ******************************************************************************/
/****************************************************************************************************************/
	- Créer un fichier "modele" contenant votre modélisation des pièces.
	- Créer un fichier "origine" contenant la modélisation des tuiles avec la spec de "modele"

	- lancer : 'java -jar puzzle.jar modele -p origine origine.dzn problemOrigine'

	- Utiliser Minizinc et puzzle.mzn avec le origine.dzn.

	- Copier la solution (format type en exemple dans solution_type) et coller dans un fichier "solution" a côté du jar.
	- lancer : 'java -jar puzzle.jar modele -r problemOrigine solution affichageSolution'

	- Ouvrir "affichageSolution" pour voir le résultat.


