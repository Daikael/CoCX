package classes.Races {
import classes.BodyData;
import classes.BodyParts.*;
import classes.MutationsLib;
import classes.PerkLib;
import classes.Race;

/**
 * Tier 1: kitsune
 * Tier 2: nine-tailed kitsune
 * Tier 3: nine-tailed kitsune of balance
 * Tier 4: Inari
 */
public class KitsuneRace extends Race {
	
	// weighted with white being rare
	public static const BasicKitsuneHairColors:/*String*/Array = ["white", "black", "black", "black", "red", "red", "red"];
	public static const BasicKitsuneHairColorSet:/*String*/Array = ["white", "black", "red"];
	public static const BasicKitsuneFurColors:/*String*/Array = ["orange and white", "black", "black and white", "red", "red and white", "white"];
	public static const ElderKitsuneColors:/*String*/Array = ["metallic golden", "golden blonde", "metallic silver", "silver blonde", "snow white", "iridescent gray"];
	
	public static const KitsuneHairColors:/*String*/Array = BasicKitsuneHairColorSet.concat(ElderKitsuneColors);
	public static const KitsuneFurColors:/*String*/Array = BasicKitsuneFurColors.concat(ElderKitsuneColors);
	
	public function KitsuneRace(id:int) {
		super("Kitsune", id);
		addScores()
				.eyeType(Eyes.FOX, +1)
				.earType(Ears.FOX, +1, -1)
				.customScoreRequirement("tail", "2+ fox tails",
						function (body:BodyData):Boolean {
							return body.tailType == Tail.FOX && body.tailCount >= 2;
						},
						function (body:BodyData):int {
							return body.tailCount;
						},
						-7
				)
				.customRequirement("skin", "fur or magical tatoo",
						function (body:BodyData):Boolean {
							return body.skinCoatType == Skin.FUR
									|| body.skinBasePattern == Skin.PATTERN_MAGICAL_TATTOO
						}, +1)
				.armType(ANY(Arms.HUMAN, Arms.KITSUNE, Arms.FOX), +1)
				.legType(ANY(LowerBody.FOX, LowerBody.HUMAN), +1, -1)
				.faceType(ANY(Face.ANIMAL_TOOTHS, Face.HUMAN, Face.FOX), +1, -1);
		addScoresAfter(5)
				.customRequirement("skin coat", "skin coat other than fur",
						function (body:BodyData):Boolean {
							return body.hasCoat && body.skinCoatType != Skin.FUR;
						}, -2
				)
				.skinBaseType(Skin.PLAIN, +1, -3)
				.hairColor(ANY(KitsuneHairColors), +1)
				.customRequirement("vagina", "Vag of Holding",
						function (body:BodyData):Boolean {
							return body.player.vaginalCapacity() >= 8000;
						},
						+1)
				.hasPerk(PerkLib.StarSphereMastery, +1)
				.hasAnyPerk([PerkLib.EnlightenedKitsune, PerkLib.CorruptedKitsune], +1)
				.hasPerk(PerkLib.NinetailsKitsuneOfBalance, +1)
				.mutationPerks([
					MutationsLib.KitsuneThyroidGland,
					MutationsLib.KitsuneThyroidGlandPrimitive,
					MutationsLib.KitsuneThyroidGlandEvolved,
					MutationsLib.KitsuneParathyroidGlands,
					MutationsLib.KitsuneParathyroidGlandsEvolved,
					MutationsLib.KitsuneParathyroidGlandsFinalForm
				])
				.chimericalBodyPerks1([
					MutationsLib.KitsuneThyroidGland,
					MutationsLib.KitsuneParathyroidGlands
				])
				.chimericalBodyPerks2([
					MutationsLib.KitsuneThyroidGlandPrimitive,
					MutationsLib.KitsuneParathyroidGlandsEvolved
				])
				.chimericalBodyPerks3([
					MutationsLib.KitsuneThyroidGlandEvolved,
					MutationsLib.KitsuneParathyroidGlandsFinalForm
				]);
		addBloodline([PerkLib.KitsunesDescendant, PerkLib.BloodlineKitsune]);
		buildTier(9, "kitsune")
				.tauricName("kitsune-taur")
				.require("2+ fox tails", function (body:BodyData):Boolean {
					return body.tailType == Tail.FOX && body.tailCount >= 2
				})
				.buffs({
					"str.mult": -0.35,
					"spe.mult": +0.25,
					"int.mult": +0.60,
					"wis.mult": +0.75,
					"lib.mult": +0.30,
					"sens": +20,
					"maxsf_mult": +0.20,
					"maxfatigue_base": +100
				})
				.end();
		buildTier(16, "nine tailed kitsune")
				.tauricName("nine tailed kitsune-taur")
				.requirePreviousTier()
				.requireTailCount(9)
				.buffs({
					"str.mult": -0.40,
					"spe.mult": +0.30,
					"int.mult": +1.10,
					"wis.mult": +1.25,
					"lib.mult": +0.45,
					"sens": +30,
					"maxsf_mult": +0.40,
					"maxfatigue_base": +300
				})
				.end();
		buildTier(21, "nine tailed kitsune of balance")
				.tauricName("nine tailed kitsune-taur of balance")
				.requirePreviousTier()
				.requirePerk(PerkLib.NinetailsKitsuneOfBalance)
				.buffs({
					"str.mult": -0.45,
					"spe.mult": +0.40,
					"int.mult": +1.25,
					"wis.mult": +1.60,
					"lib.mult": +0.80,
					"sens": +45,
					"maxsf_mult": +0.65,
					"maxfatigue_base": +500
				})
				.end();
		buildTier(26, "Inari")
				.tauricName("Inari-taur")
				.requirePreviousTier()
				.buffs({
					"str.mult": -0.50,
					"spe.mult": +0.50,
					"int.mult": +1.40,
					"wis.mult": +2.00,
					"lib.mult": +0.60,
					"sens": +60,
					"maxsf_mult": +1.00,
					"maxfatigue_base": +1000
				})
				.end()
	}
}
}
