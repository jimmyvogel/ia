package ia.orleans.fr.MoocIA1.environnement;

import ia.orleans.fr.MoocIA1.coupling.interaction.Interaction;

/**
 * An Environment simulates the enaction of an intended primitive interaction
 * and returns the resulting enacted primitive interaction.
 */
public interface Environment {
 
	public Interaction enact(Interaction intendedInteraction);
 
}