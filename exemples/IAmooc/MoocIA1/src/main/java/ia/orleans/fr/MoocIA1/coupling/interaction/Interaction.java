package ia.orleans.fr.MoocIA1.coupling.interaction;

import ia.orleans.fr.MoocIA1.coupling.Experiment;
import ia.orleans.fr.MoocIA1.coupling.Result;

public interface Interaction{
 
	/**
	 * @return The interaction's label
	 */
	public String getLabel();
 
	/**
	 * @return The interaction's experience
	 */
	public Experiment getExperience();
 
	/**
	 * @return The interaction's result
	 */
	public Result getResult();
 
	/**
	 * @param experience: The interaction's experience.
	 */
	public void setExperience(Experiment experience) ;
 
	/**
	 * @param result: The interaction's result.
	 */
	public void setResult(Result result);
 
}