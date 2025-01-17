/**
 * @author Stadler (mostly) and Ormael (choice of enemies encounters and other events)
 * Area with lvl 30-45 enemies.
 * Currently a Work in Progress.
 */

package classes.Scenes.Areas 
{
import classes.*;
import classes.GlobalFlags.kFLAGS;
import classes.Scenes.API.Encounters;
import classes.Scenes.API.GroupEncounter;
import classes.Scenes.Areas.Ocean.*;
import classes.Scenes.NPCs.CeaniScene;
import classes.Scenes.Places.Boat.SharkGirlScene;
import classes.Scenes.SceneLib;

use namespace CoC;
	
	public class Ocean extends BaseContent
	{
		public var ceaniScene:CeaniScene = new CeaniScene();
		public var sharkGirlScene:SharkGirlScene = new SharkGirlScene();
		public var scyllaScene:ScyllaScene = new ScyllaScene();
		
		public function Ocean() {
			onGameInit(init);
		}

		private var _oceanEncounter:GroupEncounter = null;
		public function get oceanEncounter():GroupEncounter {
			return _oceanEncounter;
		}

		private function init():void {
			_oceanEncounter = Encounters.group("ocean", {
				name: "fishing",
				when: function ():Boolean {
					return player.hasKeyItem("Fishing Pole") >= 0
				},
				call: fishing
			}, {
				name: "nothing",
				chance:  0.25,
				call: findNothing
			}, {
				name: "ceani",
				when: function ():Boolean {
					return (model.time.hours >= 12 && model.time.hours <= 22) && flags[kFLAGS.CEANI_FOLLOWER] < 1 && flags[kFLAGS.CEANI_ARCHERY_TRAINING] >= 4
				},
				chance: oceanChance,
				call: ceaniScene.oceanInteractionsAfterArcheryTraining
			}, {
				name: "seaanemone",
				call: function ():void {
					flags[kFLAGS.ANEMONE_OR_SEA_ANEMONE] = 2;
					player.createStatusEffect(StatusEffects.NearWater,0,0,0,0);
					player.createStatusEffect(StatusEffects.InWater,0,0,0,0);
					SceneLib.boat.anemoneScene.mortalAnemoneeeeee();
				}
			}, {
				name: "scylla",
				call: function ():void {
					player.createStatusEffect(StatusEffects.NearWater,0,0,0,0);
					player.createStatusEffect(StatusEffects.InWater,0,0,0,0);
					scyllaScene.oceanScyllaEncounter();
				}
			}, {
				name: "sharkgirl",
				call: function ():void {
					flags[kFLAGS.SHARK_OR_TIGERSHARK_GIRL] = 1;
					player.createStatusEffect(StatusEffects.NearWater,0,0,0,0);
					player.createStatusEffect(StatusEffects.InWater,0,0,0,0);
					sharkGirlScene.oceanSharkGirlEncounter();
				}
			}, {
				name: "tigersharkgirl",
				call: function ():void {
					flags[kFLAGS.SHARK_OR_TIGERSHARK_GIRL] = 2;
					player.createStatusEffect(StatusEffects.NearWater,0,0,0,0);
					player.createStatusEffect(StatusEffects.InWater,0,0,0,0);
					sharkGirlScene.oceanTigersharkGirlEncounter();
				}
			}, {
				name: "sharkgirlpack",
				call: function ():void {
					flags[kFLAGS.SHARK_OR_TIGERSHARK_GIRL] = 1;
					player.createStatusEffect(StatusEffects.NearWater,0,0,0,0);
					player.createStatusEffect(StatusEffects.InWater,0,0,0,0);
					sharkGirlScene.oceanSharkGirlsPackEncounter();
				}
			})
		}

		public function exploreOcean():void {
			clearOutput();
			flags[kFLAGS.DISCOVERED_OCEAN]++;
			doNext(camp.returnToCampUseOneHour);
			oceanEncounter.execEncounter();
			flushOutputTextToGUI();
		}

		public function oceanChance():Number {
			var temp:Number = 0.5;
			temp *= player.npcChanceToEncounter();
			return temp;
		}

		private function findNothing():void {
			clearOutput();
			outputText("You row for over an hour, until your arms practically burn with exhaustion from all the rowing.\n\n");
			if (rand(2) == 0) {
				//50/50 strength/speed
				if (rand(2) == 0 && player.str < 150) {
					outputText("Despite the exaustion, you feel like you have become stronger.");
					dynStats("str", .5);
				}
				//Toughness
				else if (player.spe < 150) {
					outputText("Despite the exaustion, you feel like you have become faster.");
					dynStats("spe", .5);
				}
			}
			doNext(camp.returnToCampUseTwoHours);
		}

		private function fishing():void {
			clearOutput();
			outputText("This is a calm day on the ocean, you managed to hold your boat just a mile or two away from the brewing storm that constantly rage over the area and, while you found nothing of note, couldn’t help yourself but to enjoy a few hour using your newly acquired fishing pole.\n\n");
			outputText("<b>You got a fish!</b>");
			inventory.takeItem(consumables.FREFISH, camp.returnToCampUseOneHour);
		}
	}

}