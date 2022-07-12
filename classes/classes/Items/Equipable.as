/**
 * Created by aimozg on 09.01.14.
 */
package classes.Items {
import classes.CoC_Settings;
import classes.ItemType;
import classes.Stats.StatUtils;

/**
 * Superclass for items that could be equipped by player (armor, weapon, jewelry, ...).
 *
 * ## Call order
 *
 * Call order when player equips itemA into slotX while having itemB equipped:
 * (This is implemented in Player.internalEquipItem)
 *
 * 1. Test
 * 1.1. Test `itemA.canEquip`. If false, stop.
 * 1.2. Test `itemB.canUnequip`. If false, stop.
 * 2. Unequip itemB
 * 2.1. Call `itemB.beforeUnequip` (calls `itemB.unequipText`) and save itemReturn
 * 2.2. Put 'nothing' into slotX
 * 2.3. Call `itemB.afterUnequip` (effects go here)
 * 3. Equip itemA
 * 3.1. Call `itemA.beforeEquip` (calls `itemA.equipText`) and save itemActual
 * 3.2. Put itemActual into slotX
 * 3.3. Call `itemActual.afterEquip` (effects go here)
 * 4. Remove itemB from inventory.
 * 5. Add itemReturn to inventory.
 * (4 and 5 are done by calling function)
 *
 * Variations:
 * - If force=true, skip test
 * - All functions mentioned above have doOutput parameter
 * - When loading a save only afterEquip(doOutput=false) is called. Can be checked by game.isLoadingSave
 * - Skip certain sections for items flagged as 'nothing'
 *
 * ## What to override in subclasses
 *
 * - To add effect when equipped: `afterEquip` and `afterUnequip`. Note that it is called when loading a save, too. Guard the section with `if (!game.isLoadingSave) { ... }`.
 * - To add requirements to wear/remove: `canEquip` and `canUnequip`
 * - To display different text: `equipText` and `unequipText`.
 * - To transform item into another when equipping: `beforeEquip`.
 * - To transform item into another when unequipping: `beforeUnequip`.
 */
public class Equipable extends Useable {
	
	private var _name:String;
	private var _buffs:Object;
	private var _buffsStack:Boolean = false;
	
	public function get name():String {
		return _name;
	}
	
	public function Equipable(id:String, shortName:String, name:String, longName:String, value:Number, description:String) {
		super(id, shortName, longName, value, description);
		this._name = name || this.shortName;
	}
	
	override public function get description():String {
		var s:String = _description;
		var s2:String = effectDescription();
		if (s && s2) return s + "\n" + s2;
		return s;
	}
	public function effectDescription():String {
		var desc:String = "";
		desc += "\nBase value: "+value;
		if (_buffs) {
			desc += "\nSpecial:"
			for (var key:String in _buffs) {
				desc += " "+StatUtils.explainBuff(key, _buffs[key]);
			}
		}
		return desc;
	}
	
	override public function canUse():Boolean {
		return canEquip(true);
	}
	
	/**
	 * Slot ids this item could be equipped into
	 */
	public function slots():/*int*/Array {
		CoC_Settings.errorAMC("Equipable("+id+")", "slots");
		return [];
	}
	
	/**
	 * Test if player can equip the item.
	 * Should NOT check empty target slot (but can check other slots).
	 * (ex. equipping large weapon can check for no shield but shouldn't check for no weapon)
	 * @param doOutput Player tries equipping the item, if fails, print why. And do any side effects related to failed equip attempt.
	 * @return
	 */
	public function canEquip(doOutput:Boolean):Boolean {
		return true;
	}
	
	/**
	 * Test if player can unequip the item
	 * @param doOutput Player tries unequiping the item, if fails, print why. And do any side effects related to failed unequip attempt.
	 * @return true if player can unequip the item
	 */
	public function canUnequip(doOutput:Boolean):Boolean {
		if (isNothing) return false;
		if (cursed) {
			if (doOutput) outputText("<b>You cannot remove a cursed item!</b>");
			return false;
		}
		return true;
	}
	
	/**
	 * Called when player is equipping the item.
	 * Can transform item into another here.
	 * It is NOT called when loading a save, do not add any effects here.
	 * It is NOT called it item transforms into another.
	 * Do not apply equipment effects here.
	 * @param doOutput
	 * @return Actual item to be put into slot, or null
	 */
	public function beforeEquip(doOutput:Boolean):Equipable {
		if (doOutput) equipText();
		return this;
	}
	
	public function equipText():void {
		outputText("You equip "+longName+". ");
	}
	
	/**
	 * Called after player has equipped the item.
	 * Also called during save load.
	 * Apply equipment effects here.
	 * @param doOutput
	 */
	public function afterEquip(doOutput:Boolean):void {
		if (_buffs) {
			// don't write into savefile
			if (_buffsStack) {
				game.player.buff(tagForBuffs).addStats(_buffs).withText(name).withOptions({save:false});
			} else {
				game.player.buff(tagForBuffs).setStats(_buffs).withText(name).withOptions({save:false});
			}
		}
	}
	
	/**
	 * Called when player removes the item.
	 * canUnequip is already called (or ignored)
	 * Do not undo the effects here
	 * @param doOutput
	 * @return Actual item to place into inventory (could be nothing)
	 */
	public function beforeUnequip(doOutput:Boolean):ItemType {
		if (doOutput) unequipText();
		return this;
	}
	
	public function unequipText():void {
		outputText("You unequip "+longName+". ");
	}
	
	/**
	 * Called after player removes the item.
	 * Undo effects here
	 * @param doOutput
	 */
	public function afterUnequip(doOutput:Boolean):void {
		if (_buffs) {
			if (game.player.countSameEquippedItems(this) == 0 || !_buffsStack) {
				game.player.buff(tagForBuffs).remove();
			} else  {
				game.player.buff(tagForBuffs).subtractStats(_buffs);
			}
		}
	}
	
	/**
	 * Give buffs when equipping this item.
	 * Only use when constructing the item type!
	 * @param buffs
	 * @param stack Stack buffs from identical items
	 * @return this
	 */
	public function withBuffs(buffs:Object, stack:Boolean=true):Equipable {
		this._buffs = buffs;
		this._buffsStack = stack;
		return this;
	}
	
	public function hasBuff(statname:String):Boolean {
		return _buffs && statname in _buffs;
	}
}
}
