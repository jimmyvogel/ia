#ifndef GRILLE_HPP
#define GRILLE_HPP
#include <iostream>
using namespace std;


class myGrid{
private :
  
  int witdh;
  int height;
  bool ** content;
  
public :
  myGrid(int x, int y, int nbcells){
    this->width = x;
    this->height = y;
    content = new bool[height];
    for(int i = 0; i< height;i++){
      content[i] = new bool[width];
    }
    for(int j= 0; j< nbcells ;j++){
      int xcells = rand()%width;
      int ycells = rand()%height;
      this->setState(xcells,ycells,true);
    }
  }
  
  ~myGrid(){
    if(content != NULL){
      for(int i = 0 ; i< height ; i++){
	delete [] content[i];
      }
      delete [] content;
    }
  }
  
  //observer
  bool getState(int x, int y){
    if(y >= 0 && y<height){
      if( x >= 0 && x < width) {
	return content[x][y];
      }
    }
    else return false; 
  }

  int getGridWeight(){
    return this->height;
  }

  int getGridWidth(){
    return this->width;
  }

  bool * getLine(int nb){
    return content[nb];
  }
  
  //assesseur
  void setState(int x, int y, bool b){
    if(y >= 0 && y < height){
      if(x >=0 && x < width){
	content[x][y]=true; 
      }
    }
  }

  void setLine(int l , bool * b){
    if(b != NULL){
      if( l >= 0 && l < heigth){
	for(int i =0; i < width; i++){
	  content[l][i] = l[b];
	}
      }
    }
  }

  
};

#endif
