## D. Chauveau 2018
## Tutorial R sur donnees State Facts
#############################################
####  STATISTIQUES DESCRIPTIVES AVEC R   ####
#############################################
# Importation sous forme de data.frame
# Fichier -> Changer le repertoire courant
# ou path complet vers le fichier texte

states <- read.table("StateFacts_tuto.txt", 
          header=T, row.names=1) # labels individus col. 1

dim(states)  # n et p
nrow(states) # n
ncol(states) # p
class(states)
colnames(states)  # nom des variables
row.names(states) # labels individus
# colnames(states)[1] <- "Population" # peut etre change si besoin, individus idem...

class(states$Region) # factor = variable qualitative
class(states$Apb)
          



# sauvegarde au format interne R
# save(states, file="states.Rdata")
# load("states.Rdata") # charge la table 
          
plot(states$Region) # method plot.factor

summary(states$Region) # method summary.factor
summary(states$Apb) # method summary.numeric

summary(states) # method summary.data.frame
# min, max, quantiles, table de freq du facteur qualitatif
  
attach(states)   # rend visible les variables de states


# recherche de manquants? (0 ici)
apply(is.na(states), 2, sum)
# rem: summary affiche aussi les NA's

###########################################################
# ANALYSE DE VARIABLES QUALITATIVES 
# Tables de contingence, histogrammes de profils

# Fonctions agissant sur les variables
table(Region)    # table des n_j (frequences)

t <- table(Region)    # objet de classe "table"
prop.table(t)         # table des f_j = probas empiriques
plot(Region) # barplot = distribution empirique des freq

barplot(prop.table(t)) # proba empirique 


# RECODAGES d'une quantitative en facteur 
# decoupage en classes egales
FD <- cut(Diplome,breaks=3,
    	labels=c("faible","moyen","fort")) 
table(FD)


t <- table(Region, FD)
t # table de contingence de 2 facteurs qualitatifs

prop.table(t) # proba empirique du couple

print(prop.table(t, margin=1), 2) # profils-ligne (sortie compacte)
# = lois empiriques de FD conditionnellement a Region

spineplot(t) # histo des profils-ligne: existence d'un effet de Region sur Diplome

spineplot(Region, FD) # idem

# recodage par les quantiles = classes egales en proba
k=2; q <- quantile(Meurtre,probs=seq(0,1,1/k))
FD2 <- cut(Meurtre,breaks=q,
        labels=c("faible","fort"))
t <- table(Region,FD2)
print(prop.table(t, margin=1), 2) # profils-ligne

# test du chi^2 pour l'hypothese nulle 
# H0: "pas de lien entre Region et FD" = "independance
chisq.test(t) # pb de validite, car case avec trop peu d'effectifs
# mais p-value = proba de se tromper en rejetant, faible: rejet H0 






###########################################################
# GRAPHIQUES hist et analogues
z <- seq(-4,4, len=200)
par(mfrow=c(2,1))
n=1000
x <- rnorm(n)
hist(x, col=8)
# n=1000
# x <- rnorm(n)
hist(x, freq=FALSE, col=8) # histo normalise pour la densite
lines(z, dnorm(z))


# Exemple de boucle for () {...} en R
# histogrammes des var quantitatives
#   states[,j] = j-eme variable (colonne)
#   colnames(states) = noms des p variables
par(mfrow=c(2,3))  # tableau de 2 x 3 graphiques
for (j in 1:5) {
	hist(states[,j], col=8, xlab="",
			cex.main=2,cex.axis=1.5,
			main=colnames(states)[j])
	}



# Croisement de vars quantitatives avec une qualitative (factor)
# boxplots des var qualitatives par Region
par(mfrow=c(3,2))  # tableau de 2 x 3 graphiques
for (j in 1:5) {
	boxplot(states[,j]~Region, col=8, xlab="",
			cex.main=2,cex.axis=1.5,
			main=colnames(states)[j])
	}


# rem: hist de Revenu presente un extreme; quel individu?
# Tri d'un data.frame selon une variable (colonne)
# tri de la table par Revenu
o <- order(Revenu)
n <- nrow(states)
states[o,][(n-10):n,] # les 10 individus  correspondants aux
# plus grandes valeurs de Revenu




###########################################################
# GRAPHIQUES SCATTERPLOTS - NUAGES DE POINTS
# Quelques graphiques elementaires
plot(Apb,Meurtre)        # nuage de points (basic)

plot(Apb,Meurtre, pch=4)        # symbole de point

# Quelques options
plot(Apb,Meurtre, pch=3,            # type de point
	xlab="Taux d'analphabetisme",   	# label axe x
	ylab="Taux de criminalite",       # label axe y
	main="nuage de points (scatterplot)")  # titre
	
	
# methode de plot sur data.frame
plot(states)  # n'a pas de sens pour un facteur qualitatif
plot(states[,-6])   # sauf facteur Region
plot(states[,-6], col=as.numeric(Region), pch=3)   # avec colorations par Region

plot(~Pop+Revenu+Meurtre)     # d'une liste explicite


# Nuages avec labels individus
# coloration par modalite d'un facteur
plot(Apb,Meurtre,type="n") # points "invisibles"
text(Apb,Meurtre,row.names(states), cex=0.8)  



# Nuages avec labels individus
# coloration par modalite d'un facteur
plot(Apb,Meurtre,type="n") # points "invisibles"
text(Apb,Meurtre,row.names(states), cex=1,
		col=as.numeric(Region))  




# avec barycentres et ellipse d'inertie
library(ade4) # package D. Chessel Lyon I, 
# deja installe sur les machines ES;
# le telecharger (CRAN) si machine perso

couleurs<-seq(1,length(levels(Region))) # juste 1:4 !

plot(Apb,Meurtre,type="n") # cadre
text(Apb,Meurtre,row.names(states), cex=1,
		col=as.numeric(Region))		
s.class(data.frame(Apb,Meurtre),Region, 
				add.plot=T,  	# ajoute au graphique existant
				col=couleurs,	# colorie barycentres/Region
				cstar=0,			# supprime les "etoiles"
				cpoint=0,			# supprime les symboles de point
				clabel=1,		# taille labels barycentres
				axesell=F)		# supprime les axes des ellipoides



# Sous-nuages par modalites de facteur(s)
coplot(Meurtre ~ Apb | Region)  # conditionne par facteur


# GRAPHIQUES: "radar" plots
stars(states[,-6],            # basic, tous les individus
      key.loc=c(6,2))
# segment plots
stars(states[1:10,-6],        # selection de 10 individus
    key.loc=c(6,2),           # avec legende
    draw.segments=T)          # "segment" plot




###########################################################
## statistiques numeriques univariees

mean(Apb); max(Revenu) # var, sd, quantile, etc...      

apply(states[,-6], 2, mean)  # moy. empirique/colonne
apply(states[,-6], 2, sd)  # ecart-type/colonne


# Matrice des correlations de toutes les vars numeriques
# = liens lineaires
cor(states[,-6]) # correlations, sauf facteur Region

print( cor(states[,-6]), 3) # short output



# Statistiques par niveaux de facteur(s)
# mean(Meurtre) par Region
tapply(Meurtre,Region,mean)   
tapply(Meurtre,Region,sd)   


# quartiles empiriques par Region
tapply(Meurtre,Region, quantile)   


# idem par Region avec usage de l'argument "..."
tapply(Meurtre,Region, quantile, probs=seq(0.1,0.5,by=0.1))   

by(states[,-6], Region, colMeans) # tapply pour dataframe





##################################
## regression lineaire simple
y = Meurtre; x = Apb # def des variables du modele y = a*x + b
reg <- lm(y ~ x)

summary(reg)
names(reg) # liste nommee

plot(x,y, type="n", xlab="Analphabetisme",ylab="Criminalite")
text(x,y,row.names(states),	col=as.numeric(Region))
abline(reg, col=2) # method abline pour objet "lm"
title("Regression lineaire")

# prevision: nouvelle obs de X
xnew <- 2.3
reg$coef[2]*xnew + reg$coef[1] # valeur y predite "a la main"

xnew <- data.frame(x=c(1.9,2.3))
predict(reg, xnew, se.fit = TRUE)$fit # avec R
