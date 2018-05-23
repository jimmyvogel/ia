## Tutorial ACM sur donnees "ours"
## et exemple (rapide) de Classification Hierarchique
## D. Chauveau - GSON 2018
#############################
library(ade4)

######################################
# data "ours" incluses dans package ade4
data(ours)
######################################

summary(ours) # que des factor (qualitatifs)

# ACM
d <- dudi.acm(ours,scan=F,nf=3) # calcule 3 axes

names(d) # contenu de la liste resultat
dim(d$co) # nb de points-colonne x nb axes conserves
# = 35 = p = nb de modalites de la table disjonctive ours
dim(d$li) # nb pts-ligne=individus=38 ici

i<-inertia.dudi(d, col.inertia=T,row.inertia=F)
i$TOT # decomposition de l'inertie, voir nb d'axes


print(head(round(i$TOT,3)))
scatterutil.eigen(d$eig,nf=3,box=T,sub="") # eboulis des valeurs propres, cf ACP

# col = points-colonnes
# col.rel = contrib relatives = cos2, sign=sgn coord.
# col.cum = cos2 cumules
# col.abs= contr absolues = parts d'inerties
head(i$col.cum)

# graphiques standard ade4 :
# plan individus avec barycentres/modalites des facteurs
scatter(d)

# Plan modalites seul avec coloration/facteur
# trace sans symbol de point
plot(d$co$Comp1, d$co$Comp2, type="n",xlab="CP1",ylab="CP2") 
cc <- as.numeric(as.factor(substr(row.names(d$co),1,5)))
sc=i$col.cum[,2]/100 # taille labels propto cos2cum plan principal 
sc[sc>=0.5] <- 1; sc[sc<0.5] <- 0.7 # avec seuils
title(main="plan principal modalites")
text(d$co$Comp1, d$co$Comp2,row.names(d$co),cex=sc,col=cc)
abline(h=0, v=0, col = "gray60") # axes 



# extrait de la table de Burt associee
dim(acm.burt(ours,ours))
acm.burt(ours,ours)[1:9,1:9] # 2 premieres vars


####### Classification hierarchique
## CAH sur les Composantes principales  de l'ACM
d <- dudi.acm(ours,scan=F,nf=10) # calcule 10 axes

library(cluster)

dim(d$co) # nb de points-colonne x nb axes conserves


# CAH differents criteres de fusion de classes
method="ward"		  # inertie
method="single"		# dist du min
method="average"	# 
method="complete"	# dist du max

ca1<-agnes(d$co, diss=FALSE, 	# data individus-caracteres
           metric="euclidean", # metrique entre individus
           stand=T,			# sur data normees ou non
           method=method		# critere de fusion de classes cf SAS
  )

plot(ca1, which=2) # default plot avec labels races

## ameliorer la lisibilite: dendro horiz avec labels = row.names 
## et var citat. en rouge
colLab <- function(n) {
  if(is.leaf(n)) {
    a <- attributes(n)
    # attr(n, "label") <- Iden[n]        #  change the node label 
    #   attr(n, "label") <- substr(Iden[n],1,15)        #  change the node label 
    # 	attr(n, "nodePar") <- c(a$nodePar, lab.col = 1) #  change the node color
    # attr(n, "nodePar") <- c(a$nodePar, lab.cex=0.9)
    if (substr(attr(n, "label"), start=1, stop=5) == "citat") 
      attr(n,"nodePar") <- c(a$nodePar, lab.col=2, lab.cex=0.9) # red 
  }
  n
}

dg <- as.dendrogram(ca1); dg <- dendrapply(dg, colLab)
par(mar=c(5.5,4.0,4.0,5.5)) # extend margin
plot(dg, horiz=T, main=paste("CAH: method=",method))


