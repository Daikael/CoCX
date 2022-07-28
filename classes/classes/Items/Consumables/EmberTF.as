/**
 * Ormael - 28.07.2017
 */
package classes.Items.Consumables
{
import classes.BaseContent;
import classes.BodyParts.Arms;
import classes.BodyParts.Ears;
import classes.BodyParts.Eyes;
import classes.BodyParts.Face;
import classes.BodyParts.Horns;
import classes.BodyParts.LowerBody;
import classes.BodyParts.Skin;
import classes.BodyParts.Tail;
import classes.BodyParts.Tongue;
import classes.BodyParts.Wings;
import classes.CoC;
import classes.CockTypesEnum;
import classes.GlobalFlags.kFLAGS;
import classes.PerkLib;
import classes.Races;
import classes.Races.DragonRace;
import classes.Scenes.SceneLib;

public class EmberTF extends BaseContent
{

	public function EmberTF() {
		super();
	}

public function dragonTFeffects(drakesHeart:Boolean = false):void {
	var changes:int = 0;
	var changeLimit:int = 2 + player.additionalTransformationChances;
	//Temporary storage
	var temp:Number = 0;
	if (player.blockingBodyTransformations()) changeLimit = 0;
	//Gain Dragon Dick
	if (changes < changeLimit && player.dragonCocks() < player.cockTotal() && rand(3) == 0) {
		var choices:Array = [];
		var select:int;
		temp = player.cockTotal();
		//Build an array of all the locations for TF'able cocks.
		while (temp > 0) {
			temp--;
			if (player.cocks[temp].cockType != CockTypesEnum.DRAGON) choices[choices.length] = temp;
		}
		//Randomly choose one of those locations
		select = choices[rand(choices.length)];
		transformations.CockDragon(select).applyEffect();
		//lose lust if sens>=50, gain lust if else
		dynStats("lus", 10)
		player.addCurse("sen", 10, 1);
		changes++;
	}
	//-Existing horns become draconic, max of 4, max length of 1'
	if (player.horns.type != Horns.DRACONIC_X4_12_INCH_LONG && changes < changeLimit && rand(5) == 0) {
		//No dragon horns yet.
		if (player.horns.type != Horns.DRACONIC_X2 && player.horns.type != Horns.DRACONIC_X4_12_INCH_LONG && player.horns.type != Horns.ORCHID) {
			//Already have horns
			if (player.horns.count > 0) {
				//High quantity demon horns
				if (player.horns.type == Horns.DEMON && player.horns.count > 4) {
					CoC.instance.transformations.HornsDraconicQuadruple.applyEffect();
        }	else {
					CoC.instance.transformations.HornsDraconicDual.applyEffect();
				}
				changes++;
			}
			//No horns
			else {
				//-If no horns, grow a pair
				CoC.instance.transformations.HornsDraconicDual.applyEffect();
        changes++;
			}
		}
		//ALREADY DRAGON
		else {
			if (player.horns.type == Horns.DRACONIC_X2) {
				if (player.horns.count < 12) {
					if (rand(2) == 0) {
						outputText("\n\nYou get a headache as an inch of fresh horns escapes from your pounding skull.");
						player.horns.count += 1;
					}
					else {
						outputText("\n\nYour head aches as your horns grow a few inches longer.  They get even thicker about the base, giving you a menacing appearance.");
						player.horns.count += 2 + rand(4);
					}
					if (player.horns.count >= 12) outputText("  <b>Your horns settle down quickly, as if they're reached their full size.</b>");
					changes++;
				}
				//maxxed out, new row
				else {
					//--Next horns growth adds second row and brings length up to 12\"
					CoC.instance.transformations.HornsDraconicQuadruple.applyEffect();
          changes++;
				}
			}
		}
	}
	//Gain Dragon Ears
	if (changes < changeLimit && rand(3) == 0 && player.ears.type != Ears.DRAGON) {
		outputText("\n\n");
		CoC.instance.transformations.EarsDraconic.applyEffect();
		changes++;
	}
	//Gain Dragon Eyes
	if (player.ears.type == Ears.DRAGON && player.eyes.type != Eyes.DRACONIC && rand(3) == 0 && changes < changeLimit) {
    outputText("\n\n");
    CoC.instance.transformations.EyesDraconic.applyEffect();
		changes++;
	}
	//Gain Dragon Tongue
	if (changes < changeLimit && rand(3) == 0 && player.tongue.type != Tongue.DRACONIC) {
		outputText("\n\n");
    CoC.instance.transformations.TongueDraconic.applyEffect();
    changes++;
		//Note: This type of tongue should be eligible for all things you can do with demon tongue... Dunno if it's best attaching a boolean just to change the description or creating a whole new tongue type.
	}
	//(Pending Tongue Masturbation Variants; if we ever get around to doing that.)
	//Gain Dragon Head OR Dragon Fangs
    if (changes < changeLimit && rand(3) == 0 && player.tongue.type == Tongue.DRACONIC && (player.faceType != Face.DRAGON && player.faceType != Face.DRAGON_FANGS)) {
        outputText("\n\n");
        CoC.instance.transformations.FaceDragonFangs.applyEffect();
        changes++;
    }
    else if (changes < changeLimit && rand(3) == 0 && player.tongue.type == Tongue.DRACONIC && player.faceType == Face.DRAGON_FANGS) {
        outputText("\n\n");
        CoC.instance.transformations.FaceDragon.applyEffect();
        changes++;
    }
	//Gain Dragon Scales
	if (player.hasPartialCoat(Skin.DRAGON_SCALES) && changes < changeLimit && rand(3) == 0) {
		outputText("\n\n");
		CoC.instance.transformations.SkinDragonScales(Skin.COVERAGE_COMPLETE, {
			colors: DragonRace.DragonScaleColors
		}).applyEffect();
		changes++;
	}
	if (!player.isDagonScaleCovered() && changes < changeLimit && rand(3) == 0) {
		var color:String;
		if (rand(10) == 0) {
			color = randomChoice("purple","silver");
		} else {
			color = randomChoice("red","green","white","blue","black");
		}
		//layer.scaleColor = color;
		outputText("\n\n");
		CoC.instance.transformations.SkinDragonScales(Skin.COVERAGE_LOW, {
			color: color
		}).applyEffect();
		changes++;
	}
	//Gain Dragon Legs
	if (player.lowerBody != LowerBody.DRAGON && changes < changeLimit && rand(3) == 0) {
		outputText("\n\n");
		transformations.LowerBodyDraconic(2).applyEffect();
		changes++;
	}
	//Arms
	if (player.arms.type != Arms.DRACONIC && player.lowerBody == LowerBody.DRAGON && changes < changeLimit && rand(3) == 0) {
		outputText("\n\n");
		CoC.instance.transformations.ArmsDraconic.applyEffect();
    changes++;
	}
	//Gain Dragon Tail
	if (player.tailType != Tail.DRACONIC && changes < changeLimit && rand(3) == 0) {
		outputText("\n\n");
		CoC.instance.transformations.TailDraconic.applyEffect();
    changes++
	}
	/*
	//9999 - prolly not gonna do this!
	Tail Slam Attack Effects:
	Deals ⅓ normal damage, but pierces 30 defense (stacks with perks) and has a (strength / 2) chance of stunning the opponent that turn.
	Note: Dunno how much defense critters usually have, but this is meant as a surprise attack of sorts, so it pierces a good amount of it.
	Tail Slam Attack Description:
	You spin around quickly, whipping your tail spikes at [enemy].
	Hit: Your tail slams against it/" + emberMF("him","her") + " with brutal force, the spikes on the tip extending to puncture flesh.
	Miss: Unfortunately, you lose your sense of depth as you whirl, and the tip swings harmlessly through the air in front of your target.
	*/
	//Grow Dragon Wings
	if (player.wings.type != Wings.DRACONIC_HUGE && changes < changeLimit && rand(3) == 0) {
		if (player.wings.type == Wings.NONE) {
			outputText("\n\n");
			CoC.instance.transformations.WingsDraconicSmall.applyEffect();
    }
		//(If Small Dragon Wings Present)
		else if (player.wings.type == Wings.DRACONIC_SMALL) {
			outputText("\n\n");
			CoC.instance.transformations.WingsDraconicLarge.applyEffect();
    }
		//even larger dragon wings ^^
		else if (player.wings.type == Wings.DRACONIC_LARGE) {
			outputText("\n\n");
			CoC.instance.transformations.WingsDraconicHuge.applyEffect();
    }
		//(If other wings present)
		else {
			outputText("\n\n");
			CoC.instance.transformations.WingsDraconicSmall.applyEffect();
    }
		changes++;
	}
	//Get Dragon Breath (Tainted version)
	//Can only be obtained if you are considered a dragon-morph, once you do get it though, it won't just go away even if you aren't a dragon-morph anymore.
	if (player.racialScore(Races.DRAGON, false) >= 4) {
		if (changes < changeLimit && !player.hasPerk(PerkLib.DragonFireBreath)) {
			outputText("\n\nYou feel something awakening within you... then a sudden sensation of choking grabs hold of your throat, sending you to your knees as you clutch and gasp for breath.  It feels like there's something trapped inside your windpipe, clawing and crawling its way up.  You retch and splutter and then, with a feeling of almost painful relief, you expel a bellowing roar from deep inside of yourself... with enough force that clods of dirt and shattered gravel are sent flying all around.  You look at the small crater you have literally blasted into the landscape with a mixture of awe and surprise.");
			outputText("\n\nIt seems " + (drakesHeart ? "the flower" : "Ember's dragon blood") + " has awaked some kind of power within you... your throat and chest feel very sore, however; you doubt you can force out more than one such blast before resting.  (<b>Gained Perk: Dragon fire breath!</b>)");
			player.createPerk(PerkLib.DragonFireBreath, 0, 0, 0, 0);
			if (SceneLib.emberScene.emberAffection() >= 75 && !drakesHeart) outputText("\n\nEmber immediately dives back in to soothe your battered throat and mouth with another kiss.");
			changes++;
		}
		if (changes < changeLimit && !player.hasPerk(PerkLib.DragonIceBreath)) {
			outputText("\n\nYou feel something awakening within you... then a sudden sensation of choking grabs hold of your throat, sending you to your knees as you clutch and gasp for breath.  It feels like there's something trapped inside your windpipe, clawing and crawling its way up.  You retch and splutter and then, with a feeling of almost painful relief, you expel a bellowing roar from deep inside of yourself... with enough force that clods of dirt and shattered gravel are sent flying all around.  You look at the small crater you have literally blasted into the landscape with a mixture of awe and surprise.");
			outputText("\n\nIt seems " + (drakesHeart ? "the flower" : "Ember's dragon blood") + " has awaked some kind of power within you... your throat and chest feel very cold, however; you doubt you can force out more than one such blast before resting.  (<b>Gained Perk: Dragon ice breath!</b>)");
			player.createPerk(PerkLib.DragonIceBreath, 0, 0, 0, 0);
			if (SceneLib.emberScene.emberAffection() >= 75 && !drakesHeart) outputText("\n\nEmber immediately dives back in to soothe your battered throat and mouth with another kiss.");
			changes++;
		}
		if (changes < changeLimit && !player.hasPerk(PerkLib.DragonLightningBreath)) {
			outputText("\n\nYou feel something awakening within you... then a sudden sensation of choking grabs hold of your throat, sending you to your knees as you clutch and gasp for breath.  It feels like there's something trapped inside your windpipe, clawing and crawling its way up.  You retch and splutter and then, with a feeling of almost painful relief, you expel a bellowing roar from deep inside of yourself... with enough force that clods of dirt and shattered gravel are sent flying all around.  You look at the small crater you have literally blasted into the landscape with a mixture of awe and surprise.");
			outputText("\n\nIt seems " + (drakesHeart ? "the flower" : "Ember's dragon blood") + " has awaked some kind of power within you... your throat and chest feel like it was electrocuted, however; you doubt you can force out more than one such blast before resting.  (<b>Gained Perk: Dragon lightning breath!</b>)");
			player.createPerk(PerkLib.DragonLightningBreath, 0, 0, 0, 0);
			if (SceneLib.emberScene.emberAffection() >= 75 && !drakesHeart) outputText("\n\nEmber immediately dives back in to soothe your battered throat and mouth with another kiss.");
			changes++;
		}
		if (changes < changeLimit && !player.hasPerk(PerkLib.DragonDarknessBreath)) {
			outputText("\n\nYou feel something awakening within you... then a sudden sensation of choking grabs hold of your throat, sending you to your knees as you clutch and gasp for breath.  It feels like there's something trapped inside your windpipe, clawing and crawling its way up.  You retch and splutter and then, with a feeling of almost painful relief, you expel a bellowing roar from deep inside of yourself... with enough force that clods of dirt and shattered gravel are sent flying all around.  You look at the small crater you have literally blasted into the landscape with a mixture of awe and surprise.");
			outputText("\n\nIt seems " + (drakesHeart ? "the flower" : "Ember's dragon blood") + " has awaked some kind of power within you... your throat and chest feel very... strange and you can't put a finger what this feeling exactly is, however; you doubt you can force out more than one such blast before resting.  (<b>Gained Perk: Dragon darkness breath!</b>)");
			player.createPerk(PerkLib.DragonDarknessBreath, 0, 0, 0, 0);
			if (SceneLib.emberScene.emberAffection() >= 75 && !drakesHeart) outputText("\n\nEmber immediately dives back in to soothe your battered throat and mouth with another kiss.");
			changes++;
		}
	}
	//grow up to 11 feet tall
	if (changes < changeLimit && rand(2) == 0 && player.basetallness < 132) {
		temp = rand(5) + 3;
		//Slow rate of growth after some tresholds
		if (player.basetallness >= 120) temp = Math.floor(temp / 3.5);
		if (player.basetallness >= 96 && player.basetallness < 120) temp = Math.floor(temp / 2);
		//Never 0
		if (temp == 0) temp = 1;
		if (temp < 5) outputText("\n\nYou shift uncomfortably as you realize you feel off balance.  Gazing down, you realize you have grown SLIGHTLY taller.");
		if (temp >= 5 && temp < 7) outputText("\n\nYou feel dizzy and slightly off, but quickly realize it's due to a sudden increase in height.");
		if (temp == 7) outputText("\n\nStaggering forwards, you clutch at your head dizzily.  You spend a moment getting your balance, and stand up, feeling noticeably taller.");
		player.tallness += temp;
		changes++;
	}
	var canReactMale:Boolean = player.hasCock() && (drakesHeart || SceneLib.emberScene.hasVagina());
	var canReactFemale:Boolean = player.hasVagina() && (drakesHeart || SceneLib.emberScene.hasCock());
	if (player.racialScore(Races.DRAGON, false) >= 4 && rand(3) == 0 && (canReactMale || canReactFemale)) {
		outputText("\n\nA sudden swell of lust races through your ");
		if (canReactMale) {
			outputText(cockDescript(0));
			if (canReactFemale) outputText(" and ");
		}
		if (canReactFemale) outputText(vaginaDescript());
        outputText(", making you wish " + (drakesHeart ? "you had a dragon to go with." : "you could have sex with Ember right here and now") + ".  All you can think about now is fucking " + (drakesHeart ? "a dragon-morph" : SceneLib.emberScene.emberMF("him", "her")) + "; ");
        if (canReactMale) {
			if (drakesHeart)
				outputText("filling a womb with your seed and fertilizing those eggs");
			else {
				outputText("filling her womb with your seed and fertilizing her eggs");
				if (canReactFemale) outputText(" even while ");
			}
		}
		if (canReactFemale) {
			outputText("taking that hard, spurting cock inside your own [vagina]");
		}
		outputText("... too late, you realize that <b>" + (drakesHeart ? "the flower" : "Ember's blood") + " has sent your draconic body into ");
		if (canReactMale && (rand(2) == 0 || !canReactFemale)) { //If hermaphrodite, the chance is 50/50.
			outputText("rut");
			player.goIntoRut(false);
			changes++;
		}
		else {
			outputText("heat");
			player.goIntoHeat(false);
			changes++;
		}
		outputText("</b>.");
	}
	if (changes == 0) outputText("\n\nRemarkably, " + (drakesHeart ? "the flower" : "Ember's blood") + " has no effect.  Maybe next time?");
	flags[kFLAGS.TIMES_TRANSFORMED] += changes;
}
}
}
