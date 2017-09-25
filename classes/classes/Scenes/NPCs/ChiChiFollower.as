/**
 * ...
 * @author Liadri
 */
package classes.Scenes.NPCs 
{
	import classes.*;
	import classes.GlobalFlags.kFLAGS;
	
	public class ChiChiFollower extends NPCAwareContent
	{
		
		public function ChiChiFollower() 
		{}

public function EnterOfTheChiChi():void {
	clearOutput();
	outputText("You step into the arena once more, but this time your opponent is slightly different. While of small stature like other mice you’ve met in He’Xin’Dao, this mouse morph has pinkish red hair and oriental clothes. She wears a pair of spiked gloves, her fists are clenched slightly at her sides, and she clearly sports a pair of C cup breasts under her clothes. The announcer screams out the participant names as usual, their enthusiastic introductions something you’ve grown used to.\n\n");
	outputText("\"<i>In the left corner, coming from another world, [name], Champion of Ingnam! And in the right corner, from a land far away to the east, the martial arts master, Chi Chi of the four winds!</i>\"\n\n");
	if (flags[kFLAGS.CHI_CHI_FOLLOWER] > 0) {
		outputText("Hey that's the waitress of the exotic food restaurant. Chi Chi adopt a battle stance as she catch fire and turn into a living inferno.\n\n");
		outputText("\"<i>Get ready because this one dishes will be EXTRA spicy! You prefer inferno or Hell? I’m going to leave you with fifth level burns!!!</i>\"");
	}
	else outputText("Chi Chi, as it’s obviously her name, adopts a battle stance. Her fists, tail and legs suddenly light aflame!");
	flags[kFLAGS.CHI_CHI_AFFECTION] = 0;
	flags[kFLAGS.CHI_CHI_LVL_UP] = 1;
	startCombat(new ChiChi());
	doNext(playerMenu);
}

public function WonFirstFight():void {
	clearOutput();
	
	flags[kFLAGS.CHI_CHI_FOLLOWER] = 2;
	player.orgasm();
	cleanupAfterCombat();
	return;
}

public function LostFirstFight():void {
	clearOutput();
	if (player.HP < 1) {
		outputText("\"<i>Is that all you’ve got? How dare you even call yourself a champion? You barely know how to fight! You tried well, albeit, not well enough. If you intend to actually call yourself a warrior, perhaps someday you should seek me out in town, I could teach you...  if you have knowledge of the basics that is. I don’t teach my skill to just anyone.</i>\"\n\n");
		outputText("The mouse girl leaves you half conscious on the arena sand as the medics come to your rescue.\n\n");
	}
	else {
		outputText("Declared the winner, the burning mouse approaches you. She looks angry and it's likely because you forfeited.\n\n");
		outputText("\"<i>I’m disappointed. You pretend to be a champion, yet you seem to consider battles a kid’s game. Do you have any idea what would have happened in a real fight? You tried well, albeit, not well enough because obviously you cowered down. I’m interested in you however so perhaps someday you should seek me out in town. I could teach you how to fight better than that...  if you have knowledge of the basics that is. I don’t teach my skill to just anyone.</i>\"\n\n");
		outputText("The fiery mouse girl leaves you there as she heads out of the ring.\n\n");
	}
	flags[kFLAGS.CHI_CHI_AFFECTION] = 20;
	player.orgasm();
	cleanupAfterCombat();
	return;
}

public function MeetingChiChiInHeXinDao():void {
	clearOutput();
	outputText("You spot Chi Chi meditating by the river. There are various scorched wooden dummies next to her and it’s obvious the monk was practicing her techniques. You barely take two steps towards her before the mouse stands up and looks you straight in the eye.\n\n");
	if (flags[kFLAGS.CHI_CHI_AFFECTION] > 20) {
		outputText("\"<i>I take it you're here to continue our training. Are you ready?</i>\"\n\n");
	}
	else {
		outputText("\"<i>I knew you would be coming. You're here to learn martial arts and it's my duty as a sensei to teach a prospective student.</i>\"\n\n");
		outputText("She sizes you up for a moment.\n\n");
		if (flags[kFLAGS.TIMES_TRAINED_WITH_JOJO] < 16 && player.findPerk(PerkLib.Enlightened) < 0) {
			outputText("\"<i>Sadly, you barely have an understanding of the discipline to begin with. You will need to train with a less experienced master first. I heard a mouse fancying himself a monk wanders the woods, I suggest you seek him out and learn what you can from him first. Once you are done, come back to me.</i>\"\n\n");
			doNext(camp.returnToCampUseOneHour);
		}
		else {
			outputText("\"<i>I see you’ve had some novice training in the art of the lotus. Not bad but the lotus were pacifists to begin with, what I’m about to teach you is an entirely new discipline, forged in the fire of the demon war. Are you ready?</i>\"\n\n");
			flags[kFLAGS.CHI_CHI_AFFECTION] += 10;
		}
	}
	menu();
	if (flags[kFLAGS.CHI_CHI_SAM_TRAINING] < 2) addButton(0, "Yes", TrainingSoulArtsWithChiChi);//usunąć if () jak dodam ostatni trening/walke
	addButton(1, "No", NotReadyForTheTraining);
	//addButton(2, "", SoulskilsManualsShop);manuals shop
	addButton(4, "Leave", camp.returnToCampUseOneHour);
}

public function NotReadyForTheTraining():void {
	outputText("You tell her you will come back when you are.\n\n");
	outputText("\"<i>Take your time, there is no shortcut through this.</i>\"\n\n");
	doNext(camp.returnToCampUseOneHour);
}

public function TrainingSoulArtsWithChiChi():void {
	clearOutput();
	if (flags[kFLAGS.CHI_CHI_DAILY_TRAINING] < 1) {
		if (flags[kFLAGS.CHI_CHI_SAM_TRAINING] >= 1 && flags[kFLAGS.CHI_CHI_SAM_TRAINING] < 2) {
			outputText("As you head to practice on the dummy, Chi Chi holds you back.\n\n");
			if (flags[kFLAGS.CHI_CHI_AFFECTION] > 60) {
				outputText("You go to see Chi Chi, still a little hesitant to continue this particular lesson.\n\n");
				outputText("\"<i>Good to see you’re back, it’s about time we resume your training.</i>\"\n\n");
			}
			else {
				outputText("\"<i>Not today. You have already mastered the basics. Now, we will delve deeper into the darkest recesses of martial arts. If you want to win a battle, you have to be ready to bleed and suffer for it. The point of this lesson is that while caution is important to avoid unnecessary injuries, it is sometimes better to take an injury than to lose a battle entirely. ");
				outputText("Your opponent uses lust to break your mind and steal your soul, the direct counteragent to lust is pain and rage, pure and simple. If, and only if, you're ready to accept them entirely, can you achieve greater heights of power.</i>\"\n\n");
				outputText("The mouse suddenly strikes at a nearby dummy like lightning. A bloody red aura runs along her body's length as she deals blows that would likely shatter stone and bend the hardest steel. However, as she finishes the target, propelling it toward the ground with such violence that it explodes on impact, you quickly notice the steep price she had to pay to achieve such power. ");
				outputText("Her body is covered with wounds and her arms are limp. She uses what looks like a different ability to heal her wounds, but she clearly looks exhausted.\n\n");
				outputText("\"<i>It’s your turn now... I want you to attack this dummy so hard you will feel your bones crack. Do not stop until the pain is so strong you can no longer fight!</i>\"\n\n");
			}
			outputText("You spend several hours punching the dummy so hard it actually hurts. You feel blood on your fists and legs by the end, however you also feel sturdier as a result, the pain being lighter than the last time.");
			if (player.tou < 100) {
				dynStats("tou", 2);
			}
			player.HP -= player.maxHP() * 0.5;
			if (player.tou >= 100) {
				if (player.findPerk(PerkLib.MightyFist) < 0) {
					player.createPerk(PerkLib.MightyFist, 0, 0, 0, 0);
					outputText(" <b>You've gained the Mighty Fist perk.</b>");
				}
				flags[kFLAGS.CHI_CHI_SAM_TRAINING] = 2;
				flags[kFLAGS.CHI_CHI_AFFECTION] += 30;
			}
			outputText("\n\n");
		}
		else {
			outputText("You're ready to begin your training and tell her as such.\n\n");
			outputText("Chi Chi nods, then proceeds to show you a whole new form of combat, this one much more aggressive than that of the Lotus. Soon you manage to learn a few additional stances, as well as how to control the energy flow in your body to increase the power of an impact. She has you training on the dummies for several hours to increase your stamina. ");
			outputText("As the flow of your movements and energy starts to become automatic, you discover your kicks and punches have become way stronger.");
			if (player.str < 100) {
				dynStats("str", 2);
			}
			if (player.spe < 100) {
				dynStats("spe", 2);
			}
			flags[kFLAGS.CHI_CHI_SAM_TRAINING] = 1;
			if (player.str >= 100 && player.spe >= 100) {
				if (player.findPerk(PerkLib.MightyFist) < 0) {
					outputText(" Chi Chi, noticing that you’re training hard, hands you a scroll.\n\n");
					outputText("\"<i>This is a scroll containing the technique Overlimit. Use it with caution, because if abused, this technique can and WILL kill you.</i>\"\n\n");
					outputText("<b>You learned the martial power Overlimit.</b>\n\n");
					if (!player.hasStatusEffect(StatusEffects.KnowsOverlimit)) player.createStatusEffect(StatusEffects.KnowsOverlimit, 0, 0, 0, 0);
				}
				flags[kFLAGS.CHI_CHI_SAM_TRAINING] = 1;
				flags[kFLAGS.CHI_CHI_AFFECTION] += 30;
			}
			outputText("\n\n");
		}
		flags[kFLAGS.CHI_CHI_DAILY_TRAINING] = 1;
		doNext(camp.returnToCampUseFourHours);
	}
	else {
		outputText("Liadri what does Chi Chi say when PC want train with her more than once a day?\n\n");
		doNext(MeetingChiChiInHeXinDao2);
	}
}

public function SoulskilsManualsShop():void {
	
}

public function MeetingChiChiInHeXinDao2():void {
	clearOutput();
	outputText("Chi Chi cross her arm impatiently.\n\n");
	outputText("\"<i>Anything else I can do for you [name]?</i>\"\n\n");
	menu();
	//addButton(0, "Yes", TrainingSoulArtsWithChiChi);
	addButton(1, "No", NotReadyForTheTraining);
	//addButton(2, "", SoulskilsManualsShop);manuals shop
	addButton(4, "Leave", camp.returnToCampUseOneHour);
}

	}
}