package classes.Scenes.Combat.SpellsWhite {
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.AbstractWhiteSpell;
import classes.StatusEffects;

public class MentalShieldSpell extends AbstractWhiteSpell{
	public function MentalShieldSpell() {
		super(
				"Mental Shield",
				"Protects against lust effects for 10 rounds, halving the damage.  ",
				TARGET_SELF,
				TIMING_LASTING,
				[TAG_BUFF]
		);
		baseManaCost = 300;
	}
	
	override public function get isKnown():Boolean {
		return player.hasStatusEffect(StatusEffects.KnowsMentalShield)
	}
	
	override public function get description():String {
		return "Protects against lust effects for "+calcDuration()+" rounds, halving the damage.  "
	}
	
	override public function useResources():void {
		super.useResources();
		player.createStatusEffect(StatusEffects.CooldownSpellMentalShield,10,0,0,0);
	}
	
	override public function get currentCooldown():int {
		return player.statusEffectv1(StatusEffects.CooldownSpellMentalShield);
	}
	
	override public function isActive():Boolean {
		return player.hasStatusEffect(StatusEffects.MentalShield);
	}
	
	public function calcDuration():int {
		var mentalshieldduration:Number = 10;
		if (player.hasPerk(PerkLib.DefensiveStaffChanneling)) mentalshieldduration *= 1.1;
		return Math.round(mentalshieldduration)
	}
	
	override protected function doSpellEffect(display:Boolean = true):void {
		if (display) {
			outputText("You draw on your inner calm, forcing it out in the form of a powerful magical ward to weaken the effect of your opponent’s depraved attacks on you.");
		}
		player.createStatusEffect(StatusEffects.MentalShield,calcDuration(),0,0,0);
	}
}
}
