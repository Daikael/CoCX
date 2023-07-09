package classes.Scenes.API {
import classes.CoC;
import classes.Scenes.SceneLib;

import coc.view.Color;
import coc.view.UIUtils;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class ExplorationEntry {
	public static const REVEAL_NOT:int  = 0;
	public static const REVEAL_KIND:int = 1;
	public static const REVEAL_FULL:int = 2;
	public static const RADIUS:Number   = 16;
//	public static const LABEL_TEXT_FORMAT:Object = {
//		color: "#000000",
//		align: "center"
//	};
//	public static const LABEL_OUTLINE:String     = "#888800";
	private static const BORDER_WIDTH:Number   = 3;
	private static const BORDER_CLEARED:String = "#222222";
	private static const BORDER_UNKNOWN:String = "#222222";
	private static const BORDER_NEXT:String    = "#0080ff";
	private static const BORDER_PLAYER:String  = "#ffaa00";
	private static const COLOR_DISABLED:String = "#666666";
	private static const COLOR_DEFAULT:String  = "#aaaaaa";
	private static const EncounterKinds:Object = {
		"walk"    : {label: "Walk", color: "#eeeeee"},
		"item"    : {label: "Item", color: "#00ff00"},
		"treasure": {label: "Treasure", color: "#80ff00"},
		"npc"     : {label: "NPC", color: "#ff80ff"},
		"place"   : {label: "Place", color: "#88aaff"},
		"special" : {label: "Special", color: "#ff00ff"},
		"event"   : {label: "Event", color: "#eeee00"},
		"monster" : {label: "Monster", color: "#aa0000"},
		"boss"    : {label: "Boss", color: "#ff0000"},
		"trap"    : {label: "Trap", color: "#ff8000"}
	}
	
	public var encounter:SimpleEncounter;
	public var color:String;
	public var label:String;
	public var tooltipHeader:String;
	public var tooltipText:String;
	public var isNext:Boolean;
	public var isCleared:Boolean;
	public var isDisabled:Boolean; // no encounter, cleared, or off-road
	public var isPlayerHere:Boolean;
	public var revealLevel:int; // 0: not revealed, 1: kind, 2: full
	public var reenter:Boolean;
	
	public function get isFullyRevealed():Boolean { return revealLevel == REVEAL_FULL }
	public function get encounterName():String { return encounter ? encounter.encounterName() : "(null)"}
	public function ExplorationEntry() {
		setEmpty();
	}
	
	public function render():Sprite {
		var s:Sprite   = new Sprite();
		var g:Graphics = s.graphics;
		
		var borderColor:uint = Color.convertColor32(
				isPlayerHere ? BORDER_PLAYER
						: isDisabled ? BORDER_CLEARED
								: isNext ? BORDER_NEXT
										: isCleared ? BORDER_CLEARED : BORDER_UNKNOWN
		);
		
		g.clear();
		g.lineStyle(BORDER_WIDTH, borderColor);
		g.beginFill(Color.convertColor32(isPlayerHere ? COLOR_DISABLED : color));
		g.drawCircle(RADIUS, RADIUS, RADIUS);
		g.endFill();
		
		var mainTextFormat:TextFormat = CoC.instance.mainView.mainText.defaultTextFormat;
		var tfLabel:TextField         = UIUtils.newTextField({
			x                : 0,
			y                : 2 * RADIUS,
			width            : 2 * RADIUS,
			autoSize         : TextFieldAutoSize.CENTER,
			text             : label,
			defaultTextFormat: {
				font : mainTextFormat.font,
				size : Number(mainTextFormat.size || 12) - 4,
				color: mainTextFormat.color,
				align: 'center'
			}
		});
//		tfLabel.filters       = [UIUtils.outlineFilter(LABEL_OUTLINE)];
		s.addChild(tfLabel)
		
		s.mouseChildren = false;
		if (isNext) {
			s.buttonMode = true;
			s.addEventListener(MouseEvent.CLICK, onClick);
		}
		s.addEventListener(MouseEvent.ROLL_OVER, onHover);
		s.addEventListener(MouseEvent.ROLL_OUT, onDim);
		
		return s;
	}
	
	private function onClick(event:MouseEvent):void {
		SceneLib.explorationEngine.entryClick(this);
	}
	private function onHover(event:MouseEvent):void {
		if (!tooltipText && !tooltipHeader) return;
		CoC.instance.mainView.toolTipView.showForElement(event.target as DisplayObject, tooltipHeader, tooltipText)
	}
	private function onDim(event:MouseEvent):void {
		CoC.instance.mainView.toolTipView.hide();
	}
	
	public function setEmpty():void {
		encounter     = null;
		label         = "";
		color         = COLOR_DISABLED;
		tooltipHeader = "";
		tooltipText   = "";
		isNext        = false;
		isDisabled    = true;
		isCleared     = false;
		isPlayerHere  = false;
		revealLevel   = REVEAL_NOT;
		reenter       = false;
	}
	
	public function setupForEncounter(e:SimpleEncounter):void {
		encounter  = e;
		isCleared  = false;
		isDisabled = false;
		reenter    = !!e.reenter;
		setRevealLevel(REVEAL_NOT);
	}
	public function incReveal():void {
		if (revealLevel == REVEAL_NOT) revealKind();
		else revealFull();
	}
	public function revealKind():void {
		revealLevel     = REVEAL_KIND;
		var kind:String = encounter.getKind();
		if (kind) {
			if (kind in EncounterKinds) {
				var entry:*   = EncounterKinds[kind];
				label         = entry.label;
				tooltipHeader = label;
				tooltipText   = ('hint' in entry) ? entry.hint : "Trigger this encounter";
				color         = ('color' in entry) ? entry.color : COLOR_DEFAULT;
			} else {
				label         = kind;
				tooltipHeader = label;
			}
		} else {
			label         = "ERROR";
			tooltipHeader = label;
			tooltipText   = "This encounter doesn't kave 'kind' property configured. This is a bug. You can still safely trigger it";
		}
	}
	public function setRevealLevel(level:int):void {
		revealLevel = level;
		if (level == REVEAL_NOT) {
			label         = "???";
			color         = COLOR_DEFAULT;
			tooltipHeader = "Unknown Encounter";
			tooltipText   = "Trigger this encounter";
		} else if (level == REVEAL_KIND) {
			revealKind();
		} else if (level == REVEAL_FULL) {
			revealFull();
		}
	}
	
	public function revealFull():void {
		revealKind();
		revealLevel   = REVEAL_FULL;
		label         = encounter.getLabel();
		tooltipHeader = encounter.getTooltipHeader();
		tooltipText   = encounter.getTooltipHint();
	}
	
	public function markCleared():void {
		revealFull();
		color         = COLOR_DISABLED;
		isNext        = false;
		isCleared     = true;
		tooltipHeader = "";
		tooltipText   = "";
	}
	public function markDisabled():void {
		color         = COLOR_DISABLED;
		isDisabled    = true;
		isNext        = false;
		tooltipHeader = "";
		tooltipText   = "";
	}
}
}
