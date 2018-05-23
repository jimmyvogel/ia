package ia.orleans.fr.MoocIA1.coupling.interaction;

/**
 * An Interaction020 is an Interaction010 with a valence. 
 */
public class Interaction025 extends Interaction020{
 
	public Interaction025(String label){
		super(label);
	}
 
	public void setValence(int valence){
		super.setValence(valence);
	}
 
	public int getValence(){
		return super.getValence();
	}
 
	@Override
	public String toString(){
		return this.getLabel() + "," + this.getValence();
	}
 
}
