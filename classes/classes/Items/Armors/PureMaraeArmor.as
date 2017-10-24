package classes.Items.Armors 
{
	import classes.GlobalFlags.kFLAGS;
import classes.GlobalFlags.kGAMECLASS;
import classes.ItemType;
	import classes.Items.Armor;
	import classes.Player;
	
	/**
	 * ...
	 * @author Kitteh6660
	 */
	public class PureMaraeArmor extends Armor
	{
		public function PureMaraeArmor() 
		{
			super("DB.Armr","D.B.Armor","divine bark armor","a suit of divine bark armor",60,7200,"This suit of armor is finely made from the white bark you've received from Marae as a reward.","Heavy");
		}
		//każde 1 armor point kosztuje 120
		override public function get supportsBulge():Boolean { return true; }
		
		override public function get def():Number { return 60 - int(game.player.cor / 2); }
		
		override public function useText():void
		{
			outputText("You strip yourself naked before you proceed to put on the armor. ");
			
			outputText("\n\nFirst, you clamber into the breastplate. ");
            if (kGAMECLASS.player.isBiped()) //Some variants.
            {
                if (kGAMECLASS.player.lowerBody == 0) outputText("Then you put your feet into your boots. With the boots fully equipped, you move on to the next piece. ");
                else outputText("Then you attempt to put your feet into your boots. You realize that the boots are designed for someone with normal feet. You have to modify the boots to fit and when you do put on your boots, your feet are exposed. ");
			}
			outputText("Next, you put on your reinforced bark bracers to protect your arms.\n\n");
            if (!kGAMECLASS.player.isTaur()) {
                outputText("Last but not least, you put your silken loincloth on to cover your groin. You thank Rathazul for that and you know that you easily have access to your ");
                if (kGAMECLASS.player.hasCock()) outputText(kGAMECLASS.player.multiCockDescriptLight());
                if (kGAMECLASS.player.hasCock() && kGAMECLASS.player.hasVagina()) outputText(" and ");
                if (kGAMECLASS.player.hasVagina()) outputText(kGAMECLASS.player.vaginaDescript());
                //Genderless
                if (!kGAMECLASS.player.hasCock() && !kGAMECLASS.player.hasVagina()) outputText("groin");
                outputText(" should you need to. ");
                if (kGAMECLASS.player.hasCock()) {
                    if (kGAMECLASS.player.biggestCockArea() >= 40 && kGAMECLASS.player.biggestCockArea() < 100) {
                        outputText("Large bulge forms against your silken loincloth. ");
					}
                    if (kGAMECLASS.player.biggestCockArea() >= 100) {
                        outputText("Your manhood is too big to be concealed by your silken loincloth. Part of your " + kGAMECLASS.player.cockDescriptShort(kGAMECLASS.player.biggestCockIndex()) + " is visible. ");
                        if (kGAMECLASS.player.cor < 33) outputText("You let out a sigh. ");
                        else if (kGAMECLASS.player.cor >= 33 && kGAMECLASS.player.cor < 66) outputText("You blush a bit, not sure how you feel. ");
                        else if (kGAMECLASS.player.cor >= 66 || game.flags[kFLAGS.PC_FETISH] > 0) outputText("You admire how your manhood is visible. ");
                    }
				}
                if (kGAMECLASS.player.cor >= 66 || game.flags[kFLAGS.PC_FETISH] > 0) {
					outputText("You'd love to lift your loincloth and show off whenever you want to. ");
				}
			}
			else {
				outputText("Last but not least, you take a silken loincloth in your hand but stop short as you examine your tauric body. There is no way you could properly conceal your genitals! ");
                if (kGAMECLASS.player.cor < 33) outputText("You let out a sigh. Being a centaur surely is inconvenient! ");
                else if (kGAMECLASS.player.cor >= 33 && kGAMECLASS.player.cor < 66) outputText("You blush a bit, not sure how you feel. ");
                else if (kGAMECLASS.player.cor >= 66 || game.flags[kFLAGS.PC_FETISH] > 0) outputText("Regardless, you are happy with what you are right now. ");
                outputText("You leave the silken loincloth in your possessions for the time being.");
			}
			outputText("You are suited up and all good to go. ");
		}
	}

}
