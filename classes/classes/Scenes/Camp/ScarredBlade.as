package classes.Scenes.Camp 
{
import classes.*;
import classes.GlobalFlags.kFLAGS;
import classes.Scenes.SceneLib;
import classes.internals.*;

public class ScarredBlade extends Monster
	{
		override public function won(hpVictory:Boolean,pcCameWorms:Boolean):void {
			SceneLib.sheilaScene.badEndScarredBlade();
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			SceneLib.sheilaScene.breakScarredBlade();
		}
		
		public function ScarredBlade() 
		{
			this.a = "the ";
			this.short = "scarred blade";
			this.plural = false;
			this.createBreastRow();
			this.balls = 0;
			this.ballSize = 0;
			this.tallness = 36;
			this.skinTone = "metallic";
			this.long = "The sword you're fighting is a no ordinary sword. It's a lethicite-infused metal curved saber etched with scars. It seems to eagerly seek flesh.";
			this.pronoun1 = "it";
			this.pronoun2 = "it";
			this.pronoun3 = "its";
			initStrTouSpeInte(80, 100, 75, 50);
			initLibSensCor(0, 0, 100);
			this.weaponName = "scarred blade";
			this.weaponVerb="slash";
			this.weaponAttack = 50 + (11 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL]);
			this.armorName = "lethicite";
			this.armorDef = 15 + (2 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL]);
			this.bonusHP = 400;
			this.lust = 0;
			this.lustVuln = 0;
			this.temperment = TEMPERMENT_LUSTY_GRAPPLES;
			this.level = 17;
			this.gems = 0;
			this.drop = new WeightedDrop(weapons.B_SCARB, 1);
			this.str += 16 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL];
			this.tou += 20 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL];
			this.spe += 15 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL];
			this.inte += 10 * flags[kFLAGS.NEW_GAME_PLUS_LEVEL];			
			this.newgamebonusHP = 1220;
			checkMonster();
		}
		
	}

}