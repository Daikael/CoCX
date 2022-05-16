/**
 * Original code by aimozg on 27.01.14.
 * Extended for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
    import classes.PerkClass;
import classes.PerkLib;
import classes.PerkType;
import classes.Player;

public class NaturalPunchingBagMutation extends PerkType
    {
        //v1 contains the mutation tier
        override public function desc(params:PerkClass = null):String {
            var descS:String = "";
            var pTier:int = player.perkv1(IMutationsLib.NaturalPunchingBagIM);
            if (pTier == 1){
                descS = "Increases the damage reduction from Bouncy body by 5% and increase your natural toughness";
            }
            else if (pTier == 2){
                descS = "Increases the damage reduction from Bouncy body by 15%, continue to increase your natural toughness and healing items are more effective";
            }
            else if (pTier == 3){
                descS = "Increases the damage reduction from Bouncy body by 35%, continue to increase your natural toughness, healing/wrath/stat boosting items are more effective and allows you to keep the effect of bouncy body as long as you are below 4 feet tall";
            }
            if (descS != "")descS += ".";
            return descS;
        }

        //Name. Need it say more?
        override public function name(params:PerkClass=null):String {
            var sufval:String;
            switch (player.perkv1(IMutationsLib.NaturalPunchingBagIM)){
                case 2:
                    sufval = "(Primitive)";
                    break;
                case 3:
                    sufval = "(Evolved)";
                    break;
                default:
                    sufval = "";
            }
            return "Natural Punching Bag" + sufval;
        }

        //Mutation Requirements
        public static function pReqs(pTier:int = 0):void{
            try{
                //This helps keep the requirements output clean.
                IMutationsLib.NaturalPunchingBagIM.requirements = [];
                if (pTier == 0){
                    IMutationsLib.NaturalPunchingBagIM.requireFatTissueMutationSlot()
                    .requirePerk(PerkLib.BouncyBody)
                    .requireCustomFunction(function (player:Player):Boolean {
                        return player.isGoblinoid();
                    }, "Goblin race");
                }
                else{
                    var pLvl:int = pTier * 30;
                    IMutationsLib.NaturalPunchingBagIM.requireLevel(pLvl);
                }
            }catch(e:Error){
                trace(e.getStackTrace());
            }
        }

        //Perk Max Level
        //Ignore the variable. Reusing the function that triggers this elsewhere and they need the int.
        public static function perkLvl(useless:int = 0):int{
            return 3;
        }

        //Mutations Buffs
        public static function pBuffs(pTier:int = 1):Object{
            var pBuffs:Object = {};
            var buffVal:Number = 0;
            if (pTier == 1) buffVal = 0.05;
            if (pTier == 2) buffVal = 0.15;
            if (pTier == 3) buffVal = 0.35;
            pBuffs['tou.mult'] = buffVal;
            return pBuffs;
        }

        public function NaturalPunchingBagMutation() {
            super("Natural Punching Bag IM", "Natural Punching Bag", ".");
        }

        override public function keepOnAscension(respec:Boolean = false):Boolean {
            return true;
        }
    }
}