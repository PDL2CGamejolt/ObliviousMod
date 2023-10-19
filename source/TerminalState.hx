import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import sys.io.File;
import lime.app.Application;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import openfl.filters.ShaderFilter;
import haxe.ds.Map;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.*;
import flixel.util.FlxTimer;
import flash.system.System;
import flixel.system.FlxSound;

using StringTools;

import PlayState; // why the hell did this work LMAO.

class TerminalState extends MusicBeatState
{
	// dont just yoink this code and use it in your own mod. this includes you, psych engine porters. (leftover from DNB because that's where the code is from)
	// if you ingore this message and use it anyway, atleast give credit. (It's IGNORE not ingore)
  // okay, credit to the DNB team for the code. - Vanta
  
	public var curCommand:String = "";
	public var previousText:String = "Vanta Engine Dev Console, built on the Vs Dave Developer Console [Version BETA]:linebreak:All Rights Reserved.:linebreak:>";
	public var displayText:FlxText;

	var expungedActivated:Bool = false;

	public var CommandList:Array<TerminalCommand> = new Array<TerminalCommand>();
	public var typeSound:FlxSound;

	// [BAD PERSON] was too lazy to finish this lol.
	var unformattedSymbols:Array<String> = [
		"period", "backslash", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero", "shift", "semicolon", "alt", "lbracket",
		"rbracket", "comma", "plus"
	];

	var formattedSymbols:Array<String> = [
		".", "/", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "", ";", "", "[", "]", ",", "="
	];

	public var fakeDisplayGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	public var expungedTimer:FlxTimer;

  //ayo what?
  //MAKE HANDS?!? WHAT THE FRICK IS A "MAKE HANDS"?!?!

	var curExpungedAlpha:Float = 0;

	override public function create():Void
	{
		Main.fps.visible = false;
		PlayState.isStoryMode = false;
		displayText = new FlxText(0, 0, FlxG.width, previousText, 32);
		displayText.setFormat(Paths.font("fixedsys.ttf"), 16);
		displayText.size *= 2;
		displayText.antialiasing = false;
		typeSound = FlxG.sound.load(Paths.sound('terminal_space'), 0.6);
		FlxG.sound.playMusic(Paths.music('TheAmbience', 'shared'), 0.7);

		CommandList.push(new TerminalCommand("help", "Displays this menu.", function(arguments:Array<String>)
		{
			UpdatePreviousText(false); // resets the text
			var helpText:String = "";
			for (v in CommandList)
			{
				if (v.showInHelp)
				{
					helpText += (v.commandName + " - " + v.commandHelp + "\n");
				}
			}
			UpdateText("\n" + helpText);
		}));

		CommandList.push(new TerminalCommand("characters", "Shows the list of characters. So far, there is only makehands.dat", function(arguments:Array<String>)
		{
			UpdatePreviousText(false); // resets the text
			UpdateText("\nmakehands.dat\nSo far, only makehands.dat is available");
		}));
		CommandList.push(new TerminalCommand("admin", "Shows the admin list, use grant to grant rights.", function(arguments:Array<String>)
		{
			if (arguments.length == 0)
			{
				UpdatePreviousText(false); // resets the text
				UpdateText("\n:linebreak:To add extra users, add the grant parameter and the name. (Example: admin grant makehands.dat)");
			}
			else if (arguments.length != 2)
			{
				UpdatePreviousText(false); // resets the text
				UpdateText(":linebreak:No version of the :addquote:admin:addquote: command takes" + " " + arguments.length
					+ " parameter(s).");
			}
			else
			{
				if (arguments[0] == "grant")
				{
					switch (arguments[1])
					{
						default:
							UpdatePreviousText(false); // resets the text
							UpdateText("\n" + arguments[1] + " is not a valid user or character.");
						case "makehands.dat":
							UpdatePreviousText(false); // resets the text
							UpdateText(":linebreak:Loading...");
							expungedActivated = true;
							new FlxTimer().start(3, function(timer:FlxTimer)
							{
								expungedReignStarts();
							});
						case "vanta.dat":
							UpdatePreviousText(false); // resets the text
							UpdateText("hehehe barry ai cover");
							new FlxTimer().start(2, function(timer:FlxTimer)
							{
								fancyOpenURL("https://www.youtube.com/watch?v=_Wj6LdCP6K8");
								System.exit(0);
							});
					}
				}
				else
				{
					UpdateText("\nInvalid Parameter"); // todo: translate.
				}
			}
		}));
		CommandList.push(new TerminalCommand("clear", "Clears the screen.", function(arguments:Array<String>)
		{
			previousText = "> ";
			displayText.y = 0;
			UpdateText("");
		}));
		CommandList.push(new TerminalCommand("open", "Searches for a text file with the specified ID, and if it exists, display it.", function(arguments:Array<String>)
		{
			UpdatePreviousText(false); // resets the text
			var tx = "";
			switch (arguments[0].toLowerCase())
			{
				default:
					tx = "File not found.";
				case "vanta":
					tx = "The one who was devolved into saying only YOU GET THE POINT";
                                case "makehands":
					tx = "what is this even";
                                case "earlyweezietot":
					tx = "The same as T3";
			// case sensitive!!
			switch (arguments[0])
			{
				case "cGVyZmVjdGlvbg":
					tx = "wait, why is this here?";
				case "bGlhcg":
					tx = "OH CRAP YOU FOUND THE HIDDEN THING";
				case "YmVkdGltZSBzb25n":
					tx = "how did you even know it? I do not even know what this is.";
				case "Y29udmVyc2F0aW9u":
					tx = "Oh my goodness!";
			}}
			UpdateText("\n" + tx);
		}));
		CommandList.push(new TerminalCommand("secret mod leak", "DO NOT LEAK THIS ENGINE, PLEASE.", function(arguments:Array<String>)
		{
			MathGameState.accessThroughTerminal = true;
			FlxG.switchState(new MathGameState());
		}, false, true));

		add(displayText);

		super.create();
	}

	public function UpdateText(val:String)
	{
		displayText.text = previousText + val;
	}

	public function UpdatePreviousText(reset:Bool)
	{
		previousText = displayText.text + (reset ? "\n> " : "");
		displayText.text = previousText;
		curCommand = "";
		var finalthing:String = "";
		var splits:Array<String> = displayText.text.split("\n");
		if (splits.length <= 22)
		{
			return;
		}
		var split_end:Int = Math.round(Math.max(splits.length - 22, 0));
		for (i in split_end...splits.length)
		{
			var split:String = splits[i];
			if (split == "")
			{
				finalthing = finalthing + "\n";
			}
			else
			{
				finalthing = finalthing + split + (i < (splits.length - 1) ? "\n" : "");
			}
		}
		previousText = finalthing;
		displayText.text = finalthing;
		if (displayText.height > 720)
			displayText.y = 720 - displayText.height;
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (expungedActivated)
		{
			curExpungedAlpha = Math.min(curExpungedAlpha + elapsed, 1);
			if (fakeDisplayGroup.exists && fakeDisplayGroup != null)
			{
				for (text in fakeDisplayGroup.members)
				{
					text.alpha = curExpungedAlpha;
				}
			}
			return;
		}
		var keyJustPressed:FlxKey = cast(FlxG.keys.firstJustPressed(), FlxKey);

		if (keyJustPressed == FlxKey.ENTER)
		{
			var calledFunc:Bool = false;
			var arguments:Array<String> = curCommand.split(" ");
			for (v in CommandList)
			{
				if (v.commandName == arguments[0]
					|| (v.commandName == curCommand && v.oneCommand)) // argument 0 should be the actual command at the moment
				{
					arguments.shift();
					calledFunc = true;
					v.FuncToCall(arguments);
					break;
				}
			}
			if (!calledFunc)
			{
				UpdatePreviousText(false); // resets the text
				UpdateText(":linebreak:Unknown command :addquote:" + arguments[0] + "\"");
			}
			UpdatePreviousText(true);
			return;
		}

		if (keyJustPressed != FlxKey.NONE)
		{
			if (keyJustPressed == FlxKey.BACKSPACE)
			{
				curCommand = curCommand.substr(0, curCommand.length - 1);
				typeSound.play();
			}
			else if (keyJustPressed == FlxKey.SPACE)
			{
				curCommand += " ";
				typeSound.play();
			}
			else
			{
				var toShow:String = keyJustPressed.toString().toLowerCase();
				for (i in 0...unformattedSymbols.length)
				{
					if (toShow == unformattedSymbols[i])
					{
						toShow = formattedSymbols[i];
						break;
					}
				}
				if (FlxG.keys.pressed.SHIFT)
				{
					toShow = toShow.toUpperCase();
				}
				curCommand += toShow;
				typeSound.play();
			}
			UpdateText(curCommand);
		}
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.BACKSPACE)
		{
			curCommand = "";
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			Main.fps.visible = !FlxG.save.data.disableFps;
			FlxG.switchState(new MainMenuState());
		}
	}

	function expungedReignStarts()
	{

		add(fakeDisplayGroup);

		var expungedLines:Array<String> = [
			'YOU GET THE POINT'
		];
		var i:Int = 0;
		var camFollow = new FlxObject(FlxG.width / 2, -FlxG.height / 2, 1, 1);

		#if windows
		if (FlxG.save.data.selfAwareness)
		{
			expungedLines.push("Hacking into " + Sys.environment()["COMPUTERNAME"] + "...");
		}
		#end

		FlxG.camera.follow(camFollow, 1);

		expungedActivated = true;
		expungedTimer = new FlxTimer().start(FlxG.elapsed * 2, function(timer:FlxTimer)
		{
			var lastFakeDisplay = fakeDisplayGroup.members[i - 1];
			var fakeDisplay:FlxText = new FlxText(0, 0, FlxG.width, "> " + expungedLines[new FlxRandom().int(0, expungedLines.length - 1)], 19);
			fakeDisplay.setFormat(Paths.font("fixedsys.ttf"), 16);
			fakeDisplay.size *= 2;
			fakeDisplay.antialiasing = false;

			var yValue:Float = lastFakeDisplay == null ? displayText.y + displayText.textField.textHeight : lastFakeDisplay.y
				+ lastFakeDisplay.textField.textHeight;
			fakeDisplay.y = yValue;
			fakeDisplayGroup.add(fakeDisplay);
			if (fakeDisplay.y > FlxG.height)
			{
				camFollow.y = fakeDisplay.y - FlxG.height / 2;
			}
			i++;
		}, FlxMath.MAX_VALUE_INT);

		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound("expungedGrantedAccess", "preload"), function()
		{
			expungedTimer.cancel();
			fakeDisplayGroup.clear();

			});
			FlxG.sound.play(Paths.sound('iTrollYou', 'shared'), function()
			{
				new FlxTimer().start(1, function(timer:FlxTimer)
				{
					FlxG.save.flush();
					PlayState.SONG = Song.loadFromJson("noitailihnna");
					PlayState.SONG.validScore = false;
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		});
	}
}

class TerminalCommand
{
	public var commandName:String = "undefined";
	public var commandHelp:String = "if you see this you are what the bad users on youtube call a raged kid."; // hey im not homosexual. kinda mean ngl
	public var FuncToCall:Dynamic;
	public var showInHelp:Bool;
	public var oneCommand:Bool;

	public function new(name:String, help:String, func:Dynamic, showInHelp = true, oneCommand:Bool = false)
	{
		commandName = name;
		commandHelp = help;
		FuncToCall = func;
		this.showInHelp = showInHelp;
		this.oneCommand = oneCommand;
	}
}
