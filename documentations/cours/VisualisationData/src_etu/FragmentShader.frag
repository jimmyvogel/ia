varying vec4 center;
varying vec4 position;
varying vec3 normal;

vec4 eclairage(vec4 colFrag,vec3 position, vec3 normal){
  vec4 res;
  normal=normalize(normal);
  // la position de la lumière est imposée par le shader
  vec3 lightvec = vec3(10.0,0.0,1.);

  vec3 rayDirection=normalize(lightvec-position);

  float lightAngle=max(dot(normal,rayDirection),0.0);

  //vec3 R=reflect(-lightvec,normal);
  float specular=pow(dot(normal,normalize(-position)),8192.0);
  vec3 diffusecolor = colFrag.xyz;
  // la lumière spéculaire est fixée par le shader
  vec3 specularcolor = vec3(1.0,1.0,1.0);    

  // Donne la couleur définitive au fragment
  res.rgb = lightAngle * diffusecolor + specular * specularcolor;
  res.a = 1.0;
  return res;
}

void main(){

    //Rayon
    float rayon = 1.2;

    //eye - position du point : comme on multiplie la position par ModelVueProjection avant de l'envoyé
    //                          au fragment, eye=(0,0,0,1) donc on a juste l'inverse de la position
  	vec4 v = -position;

  	//Equation
  	//(v.v)*t*t + (2.0*v.(pos − center))*t + ((pos − center).(pos − center) − r * r) = 0
  	float a = dot(v.xyz,v.xyz);
  	float b = 2.0*dot(v.xyz, position.xyz-center.xyz);
  	float c = dot(position.xyz-center.xyz, position.xyz-center.xyz) - rayon*rayon;

  	//Determinant b² - 4.0*a*c
  	float determinant = b*b - 4.0 * a * c;

  	//Si pas d'intersection:suppression
  	if(determinant<0.0){
  		discard;
  	}else{

  		//Calcul des solutions,  <--- plusieurs tests pour supprimer l'intérieur pour l'éclairage (fail)
  		//float x1 = (-b - sqrt(determinant)) / (2.0*a);
  		//float x = sqrt(a*pow(x1,2.0));
  		//float y = sqrt(b*x1);
  		//float z = sqrt(dot(position.xyz-center.xyz, position.xyz-center.xyz));
  		//float val = sqrt(pow(position.x-center.x, 2.0)+pow(position.y-center.y, 2.0)+pow(position.z-center.y, 2.0));
  		//vec3 vecTrouve = vec3(x,y,z);
  		//if(position.xyz==vecTrouve){
		  gl_FragColor = eclairage(gl_Color, position.xyz, normal);
		  //}
    }

}
