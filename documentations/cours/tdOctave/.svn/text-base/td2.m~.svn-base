img = imread('lena.jpg');
imdb = im2double(img);
imwrite(imdb,'lena.bmp');
%img2 = imread('FibroblastCellNucleus.jpg');

%passer une image couleur , en image N&B
%imggray = rgb2gray(img2);

%imgdbgray = im2double(imggray);

%CALCULER L'HISTOGRAMME
%imgdi = histeq(imgdbgray,200);

%imshow(imgdi);

%Seuillage noir et blanc
%im2bw(img,seuil); seuil compris entre 0 et 1

%convolution produit de chaque pixels avec un masque
%Convolution en 2D, conv2
mat = [-1 0 1;-1 0 1;-1 0 1];
mat2 = [-1 -1 -1;0 0 0;1 1 1];
imgmasque = conv2(imdb,mat);
imgmasque2 = conv2(imdb,mat2);

%sauvegarder une image dnas le format souhaité
imwrite(imgmasque,'lenamasque.bmp');
imwrite(imgmasque2,'lenamasque2.bmp');

%on tente la gaussienne
gauss_f = fspecial('gaussian',25);
gaussImg = filter2(gauss_f,imdb,'valid');

%on va faire un vecteur des valeurs, que l'on va trier par ordre croissant
%on prend la valeur médiane, on appelle ca faire un filtre median
medImg = medfilt2(imdb);
imgdiff = abs(imdb-medImg);
diffbw = im2bw(imgdiff,2/255);

%générer du bruit sur l'image
imgbruit = imnoise(imdb,'salt & pepper');
%medfilter : filtre médian , remplace la valeur du pixel par la valeur médiane des pixels voisins, pour enlever le bruit
bruitfilter = medfilt2(imgbruit);

%Gaussienne du masque à la main
g = sqrt(((imgmasque.*imgmasque2) + (imgmasque.*imgmasque2))./2);
%g = g/1,414;

%chargement d'une image de cell.jpg
imgcell = imread('Cell.jpg');
%binarisation
imgcelldbl = im2double(imgcell);
%histo de limage histo = imhist(imgcell)
%trouvons le seuil , ici aps de ; à la fin de l'instruction pour afficher S dnas le aconsole
S = graythresh(imgcelldbl)
imgcellbw = im2bw(imgcelldbl,S);
%essayons d'eroder l'image pour pouvoir compter les cells
%definissons l'element structurant
ES = [0 1 0;1 1 1;0 1 0];
% par convention , les 0 sont des noirs et les 1 des blancs, 
%il faut donc faire attention avec le masque pour l'érosion. 
%Par convention, il faut donc utiliser une image blanche sur fonc noir 
%pour appliquer un element structurant

%nous allons donc inverser l'image
imgcellbwinv = ~imgcellbw;

%appliquons l'erosion 1 fois (-troisieme parametre c'est le nombre de fois)
imero = erode(imgcellbwinv,ES,1);

%dilation
imdil = imdilate(imgcellbwinv,ES);

%ouverture
imop = imopen(imgcellbwinv,ES);

%fermeture
imcl = imclose(imgcellbwinv,ES);

%Essayons d'obtenir les contours, avec la difference en valeur absolue de
%image erode - img dilate
imgedg = abs(imdil - imero);

%trouvons le skeleton a partir de l'image bw inversée
imskeleton = bwmorph(imgcellbwinv, 'skel',100);

%trouvons les elements connexes avec une fonction qui fait l'"etiquettage"
imer = erode(imskeleton,ES);
imdil100 = dilate(imer,ES,10);
[L,NUM] = bwlabel (imdil100, 8);
NUM

%affichage
figure;subplot(2,2,1);imshow(imdb);title('origine');
subplot(2,2,2);imshow(diffbw);title('diffBW');
subplot(2,2,3);imshow(imgbruit);title('bruit');
subplot(2,2,4);imshow(bruitfilter);title('bruit filter');
figure;
subplot(3,3,1);imshow(imgcell);title('Cell');
subplot(3,3,2);imshow(imgcelldbl);title('Cell dbl');
subplot(3,3,3);imshow(imgcellbw);title('CellBW');
subplot(3,3,4);imshow(imgcellbwinv);title('CellBWINV');
subplot(3,3,5);imshow(imero);title('CellERODE');
subplot(3,3,6);imshow(imdil);title('CellDIL');
subplot(3,3,7);imshow(imop);title('Cellopen');
subplot(3,3,8);imshow(imcl);title('Cellfer');
subplot(3,3,9);imshow(imgedg);title('Celledg');
figure; imshow(imgedg);title('Celledg');
figure; imshow(imskeleton);title('cell skel');
figure; imshow(imdil100);title('celldill*');



