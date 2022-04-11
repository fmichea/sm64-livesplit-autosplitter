// Version: 0.1.0

state("Project64") {
	// This looks like it always has value vars.consts.DEBUG_FUNCTION_VALUE in the correct ROM.
	// Used to determine which ROM is loaded in PJ64 automatically.
	uint debugFunctionUS : "Project64.exe", 0xD6A1C, 0x2CB1C0;
	uint debugFunctionJP : "Project64.exe", 0xD6A1C, 0x2CA6E0;
	
	uint gameRunTimeJP : "Project64.exe", 0xD6A1C, 0x32C640;
	uint gameRunTimeUS : "Project64.exe", 0xD6A1C, 0x32D580;

	uint globalTimerJP : "Project64.exe", 0xD6A1C, 0x32C694;
	uint globalTimerUS : "Project64.exe", 0xD6A1C, 0x32D5D4;

    byte stageIndexJP  : "Project64.exe", 0xD6A1C, 0x32CE9A;
    byte stageIndexUS  : "Project64.exe", 0xD6A1C, 0x32DDFA;

	ushort animationJP : "Project64.exe", 0xD6A1C, 0x339E0C;
	ushort animationUS : "Project64.exe", 0xD6A1C, 0x33B17C;

	short starCountJP  : "Project64.exe", 0xD6A1C, 0x339EA8;
    short starCountUS  : "Project64.exe", 0xD6A1C, 0x33B218;
	
	uint musicJP : "Project64.exe", 0xD6A1C, 0x222A1C;
	uint musicUS : "Project64.exe", 0xD6A1C, 0x22261C;
}

startup {
	// Arrays used to quickly check which stage we are in.
	bool[] BOWSER_FIGHT_STAGE_INDEXES = new bool[0x100];
	BOWSER_FIGHT_STAGE_INDEXES[30] = true; // BOWSER 1 FIGHT STAGE
	BOWSER_FIGHT_STAGE_INDEXES[33] = true; // BOWSER 2 FIGHT STAGE
	BOWSER_FIGHT_STAGE_INDEXES[34] = true; // BOWSER 3 FIGHT STAGE

	byte DDD_STAGE_INDEX = 23;
	byte BITFS_STAGE_INDEX = 19;

	bool[] BOWSER_STAGE_INDEXES = new bool[0x100];
	BOWSER_STAGE_INDEXES[17] = true; // BITDW
	BOWSER_STAGE_INDEXES[BITFS_STAGE_INDEX] = true; // BITFS
	BOWSER_STAGE_INDEXES[21] = true; // BITS

	bool[] STAGE_INDEXES = new bool[0x100];
	STAGE_INDEXES[17] = true; // BITDW
	STAGE_INDEXES[BITFS_STAGE_INDEX] = true; // BITFS
	STAGE_INDEXES[21] = true; // BITS
	STAGE_INDEXES[18] = true; // VUCTM
	STAGE_INDEXES[31] = true; // WMOTR
	STAGE_INDEXES[27] = true; // PSS
	STAGE_INDEXES[9] = true;  // BOB
	STAGE_INDEXES[24] = true; // WF
	STAGE_INDEXES[12] = true; // JRB
	STAGE_INDEXES[5] = true;  // CCM
	STAGE_INDEXES[4] = true;  // BBH
	STAGE_INDEXES[7] = true;  // HMC
	STAGE_INDEXES[22] = true; // LLL
	STAGE_INDEXES[8] = true;  // SSL
	STAGE_INDEXES[DDD_STAGE_INDEX] = true; // DDD
	STAGE_INDEXES[10] = true; // SL
	STAGE_INDEXES[11] = true; // WDW
	STAGE_INDEXES[36] = true; // TTM
	STAGE_INDEXES[13] = true; // THI
	STAGE_INDEXES[14] = true; // TTC
	STAGE_INDEXES[15] = true; // RR

	bool[] CASTLE_INDEXES = new bool[0x100];
	CASTLE_INDEXES[6] = true;  // Basement + Lobby + Upstairs + Tippy
	CASTLE_INDEXES[16] = true; // Garden & Moat (Outside Front)
	CASTLE_INDEXES[26] = true; // Castle Courtyard (Outside Back)

	// Settings for this auto splitter.
	string GAME_VERSION_JP = "gameVersionJP";
	string GAME_VERSION_US = "gameVersionUS";

	string LAUNCH_ON_START = "launchOnStart";
	string DISABLE_RESET_AFTER_END = "disableResetAfterEnd";
	string DISABLE_RTA_MODE = "disableRTAMode";
	string DISABLE_BOWSER_REDS_DELAYED_SPLIT = "disableBowserRedsDelayedSplit";

	// Constant values used within the code.
	ushort STAR_GRAB_ACTION = 4866;
	ushort STAR_GRAB_ACTION_SWIMMING = 4867;
	ushort STAR_GRAB_ACTION_NO_EXIT = 4871;
	ushort KEY_DOOR_TOUCH_ACTION = 4910;
	ushort FINAL_STAR_GRAB_ACTION = 6409;
	
	uint DEBUG_FUNCTION_VALUE = 0x27bdffd8;
	
	uint STAR_SELECT_MUSIC = 0x800d1600;
	
	// Regexes used to parse out information from split name.
	System.Text.RegularExpressions.Regex STAR_COUNT_BRACKET1 = new System.Text.RegularExpressions.Regex(@"\[(?<starCount>\d+)\]");
	System.Text.RegularExpressions.Regex STAR_COUNT_BRACKET2 = new System.Text.RegularExpressions.Regex(@"\((?<starCount>\d+)\)");

	System.Text.RegularExpressions.Regex UPSTAIRS = new System.Text.RegularExpressions.Regex(@"(?i)upstairs");
	System.Text.RegularExpressions.Regex BASEMENT = new System.Text.RegularExpressions.Regex(@"(?i)basement");
	System.Text.RegularExpressions.Regex BOWSER = new System.Text.RegularExpressions.Regex(@"(?i)bowser");
	System.Text.RegularExpressions.Regex KEY = new System.Text.RegularExpressions.Regex(@"(?i)key");
	System.Text.RegularExpressions.Regex RTA = new System.Text.RegularExpressions.Regex(@"(?i)rta");

	System.Text.RegularExpressions.Regex NORESET1 = new System.Text.RegularExpressions.Regex(@"(?i)\[noreset\]");
	System.Text.RegularExpressions.Regex NORESET2 = new System.Text.RegularExpressions.Regex(@"(?i)\(noreset\)");

	System.Text.RegularExpressions.Regex MANUAL1 = new System.Text.RegularExpressions.Regex(@"(?i)\[manual\]");
	System.Text.RegularExpressions.Regex MANUAL2 = new System.Text.RegularExpressions.Regex(@"(?i)\(manual\)");

	// Helper attributes related to LiveSplit.
	vars.timerModel = new TimerModel { CurrentState = timer };

	// Working data which can be changed in various places.
	Func<ExpandoObject> initVarsData = delegate() {
		dynamic data = new ExpandoObject();
		
		data.lastSplitIndex = -1;
		data.starRequirement = -1;
		data.isManualSplit = false;
		data.isNoResetSplit = false;
		data.isBowserSplit = false;
		data.isDoorTouchSplit = false;
		data.isCastleMovementSplit = true;
		data.isSplittingOnLevelChange = false;
		data.isSplittingImmediately = false;
		data.isJapaneseVersion = false;
		data.isRTAMode = false;
		data.previousStage = 0;
		data.previousCategoryName = "";
		
		return data;
	};

	Action<dynamic, int> resetVarsDataForSplitChange = delegate(dynamic varsD, int lastSplitIndex) {
		varsD.data.isSplittingImmediately = false;
		varsD.data.isSplittingOnLevelChange = false;
		varsD.data.starRequirement = -1;
		varsD.data.lastSplitIndex = lastSplitIndex;
	};

	vars.data = initVarsData();

	// Settings are copied to this for testing purposes.
	Func<ExpandoObject> initSettingsData = delegate() {
		dynamic settingsD = new ExpandoObject();
		
		settingsD.isResetEnabled = false;
		settingsD.categoryName = "";
		settingsD.currentTimerPhase = TimerPhase.NotRunning;
		settingsD.currentSplitIndex = -1;
		settingsD.currentSplitName = "";
		settingsD.splitCount = 0;
		settingsD.forceLaunchOnStart = false;
		settingsD.forceJPGameVersion = false;
		settingsD.forceUSGameVersion = false;
		settingsD.disableResetAfterEnd = false;
		settingsD.disableRTAMode = false;
		settingsD.disableBowserRedsDelayedSplit = false;
		
		return settingsD;
	};
	
	vars.settings = initSettingsData();

	// Helper function used in code to avoid duplication.	
	Func<dynamic, dynamic, uint> getGameRuntime = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.gameRunTimeJP : state.gameRunTimeUS;
	};
	
	Func<dynamic, dynamic, uint> getGlobalTimer = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.globalTimerJP : state.globalTimerUS;
	};
	
	Func<dynamic, dynamic, byte> getStageIndex = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.stageIndexJP : state.stageIndexUS;
	};
	
	Func<dynamic, dynamic, ushort> getAnimation = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.animationJP : state.animationUS;
	};
	
	Func<dynamic, dynamic, short> getStarCount = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.starCountJP : state.starCountUS;
	};
	
	Func<dynamic, dynamic, uint> getMusicTrack = delegate(dynamic varsD, dynamic state) {
		return varsD.data.isJapaneseVersion ? state.musicJP : state.musicUS;
	};
	
	Func<byte, byte, bool> isStageFadeIn = delegate(byte stageIndex_old, byte stageIndex_current) {
		return (
			stageIndex_old != stageIndex_current &&
			CASTLE_INDEXES[stageIndex_old] &&
			STAGE_INDEXES[stageIndex_current]
		);
	};
	
	Func<byte, byte, bool> isStageFadeOut = delegate(byte stageIndex_old, byte stageIndex_current) {
		return (
			stageIndex_old != stageIndex_current &&
			(
				(STAGE_INDEXES[stageIndex_old] && CASTLE_INDEXES[stageIndex_current]) ||
				(STAGE_INDEXES[stageIndex_old] && BOWSER_FIGHT_STAGE_INDEXES[stageIndex_current])
			)
		);
	};

	Func<dynamic, dynamic, dynamic, bool> updateRunConditionInner = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		// Detect splitting mode between gameplay and RTA.
		string categoryName = varsD.settings.categoryName;
		
		if (varsD.data.previousCategoryName != categoryName) {
			System.Text.RegularExpressions.MatchCollection rtaMatches = RTA.Matches(categoryName);

			varsD.data.isRTAMode = rtaMatches.Count != 0;
			varsD.data.previousCategoryName = categoryName;
		}
		
		// Game version detection needs to be in update for game switching to work properly.
		varsD.data.isJapaneseVersion = (
			vars.settings.forceJPGameVersion ||
			(
				!vars.settings.forceUSGameVersion &&
				currentD.debugFunctionJP == DEBUG_FUNCTION_VALUE
			)
		);

		// LiveSplit.AutoSplitter does not run reset once the last segment has been split (game finished),
		// which prevents from easily starting a new run. This works around it.
		if (
			varsD.settings.isResetEnabled &&
			varsD.settings.currentTimerPhase == TimerPhase.Ended &&
			!varsD.settings.disableResetAfterEnd &&
			varsD.functions.resetRunCondition(varsD, oldD, currentD)
		) {
			varsD.timerModel.Reset();
		}

		return true;
	};

	Func<LiveSplitState, dynamic, dynamic, dynamic, dynamic, bool> updateRunCondition = delegate(LiveSplitState timerD, dynamic settingsD, dynamic varsD, dynamic oldD, dynamic currentD) {
		// DEBUGGING: Add prints here for debugging. Every 5s.
		uint gameRuntime_current = getGameRuntime(varsD, currentD);
		if (gameRuntime_current % 150 == 0) {
			// print(string.Format("{0}", varsD.data.isManualSplit));
		}

		// Copy settings to var to help with testing.
		varsD.settings.isResetEnabled = settingsD.ResetEnabled;
		varsD.settings.categoryName = timerD.Run.CategoryName;
		varsD.settings.currentTimerPhase = timerD.CurrentPhase;
		varsD.settings.currentSplitIndex = timerD.CurrentSplitIndex;
		if (timerD.CurrentSplit != null) {
			varsD.settings.currentSplitName = timerD.CurrentSplit.Name;
		}
		varsD.settings.splitCount = timerD.Run.Count;
		varsD.settings.forceJPGameVersion = settingsD[GAME_VERSION_JP];
		varsD.settings.forceUSGameVersion = settingsD[GAME_VERSION_US];
		varsD.settings.disableResetAfterEnd = settingsD[DISABLE_RESET_AFTER_END];
		varsD.settings.disableRTAMode = settingsD[DISABLE_RTA_MODE];
		varsD.settings.disableBowserRedsDelayedSplit = settingsD[DISABLE_BOWSER_REDS_DELAYED_SPLIT];
		
		// Call inner update logic.
		return updateRunConditionInner(varsD, oldD, currentD);
	};

	Func<dynamic, dynamic, dynamic, bool> startRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		uint gameRuntime_old = getGameRuntime(varsD, oldD);
		uint gameRuntime_current = getGameRuntime(varsD, currentD);
	
		uint globalTimer_current = getGlobalTimer(varsD, currentD);
		
		byte stageIndex_old = getStageIndex(varsD, oldD);
		byte stageIndex_current = getStageIndex(varsD, currentD);
		
		ushort animation_old = getAnimation(varsD, oldD);
		ushort animation_current = getAnimation(varsD, currentD);

		uint music_old = getMusicTrack(varsD, oldD);
		uint music_current = getMusicTrack(varsD, currentD);
		
		// First frame of the logo appears on frame 4 (1.33s after launch).
		if (!varsD.settings.forceLaunchOnStart && globalTimer_current == 4) {
			return true;
		}
		
		// As soon as game is relaunched if option is selected, quite inconsistent time-wise.
		if (varsD.settings.forceLaunchOnStart && stageIndex_current == 1 && gameRuntime_current < gameRuntime_old) {
			return true;
		}
				
		// RTA mode, timer starts when we see star select screen, we leave a stage (fade-out) or we touch a door.
		if (
			!varsD.settings.disableRTAMode &&
			varsD.data.isRTAMode &&
			(
				isStageFadeOut(stageIndex_old, stageIndex_current) ||
				(
					animation_old != animation_current &&
					animation_current == KEY_DOOR_TOUCH_ACTION
				) ||
				(
					music_old != music_current &&
					music_current == STAR_SELECT_MUSIC
				)
			)
		) {
			return true;
		}
		
		return false;
	};

	Action<dynamic> onResetRunCondition = delegate(dynamic varsD) {
		varsD.data.previousStage = 0;
	};

	Func<dynamic, dynamic, dynamic, bool> resetRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		if (varsD.data.isNoResetSplit) {
			return false;
		}

		uint gameRuntime_old = getGameRuntime(varsD, oldD);
		uint gameRuntime_current = getGameRuntime(varsD, currentD);

		byte stageIndex_current = getStageIndex(varsD, currentD);

		short starCount_old = getStarCount(varsD, oldD);
		short starCount_current = getStarCount(varsD, currentD);

		bool isResetGame = (
			stageIndex_current == 1 &&
			gameRuntime_current < gameRuntime_old
		);

		bool isResetRTA = (
			!vars.settings.disableRTAMode &&
			varsD.data.isRTAMode &&
			starCount_current < starCount_old
		);

		if (isResetGame || isResetRTA) {
			onResetRunCondition(varsD);
			return true;
		}

		return false;
	};
	
	Func<dynamic, dynamic, dynamic, bool> splitRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		if (varsD.data.lastSplitIndex != varsD.settings.currentSplitIndex) {
			resetVarsDataForSplitChange(varsD, varsD.settings.currentSplitIndex);
					
			string splitName = varsD.settings.currentSplitName;

			System.Text.RegularExpressions.MatchCollection manual1Matches = MANUAL1.Matches(splitName);
			System.Text.RegularExpressions.MatchCollection manual2Matches = MANUAL2.Matches(splitName);
			varsD.data.isManualSplit = manual1Matches.Count != 0 || manual2Matches.Count != 0;
			
			System.Text.RegularExpressions.MatchCollection noReset1Matches = NORESET1.Matches(splitName);
			System.Text.RegularExpressions.MatchCollection noReset2Matches = NORESET2.Matches(splitName);
			varsD.data.isNoResetSplit = noReset1Matches.Count != 0 || noReset2Matches.Count != 0;

			System.Text.RegularExpressions.MatchCollection bowserMatches = BOWSER.Matches(splitName);
			System.Text.RegularExpressions.MatchCollection keyMatches = KEY.Matches(splitName);
			varsD.data.isBowserSplit = bowserMatches.Count != 0 || keyMatches.Count != 0;

			System.Text.RegularExpressions.MatchCollection upstairsMatches = UPSTAIRS.Matches(splitName);
			System.Text.RegularExpressions.MatchCollection basementMatches = BASEMENT.Matches(splitName);
			varsD.data.isDoorTouchSplit = (upstairsMatches.Count != 0 || basementMatches.Count != 0);

			System.Text.RegularExpressions.MatchCollection starCountBracket1 = STAR_COUNT_BRACKET1.Matches(splitName);
			if (starCountBracket1.Count != 0) {
				varsD.data.starRequirement = Convert.ToInt32(starCountBracket1[0].Groups["starCount"].Value);
			}
			
			System.Text.RegularExpressions.MatchCollection starCountBracket2 = STAR_COUNT_BRACKET2.Matches(splitName);
			if (starCountBracket2.Count != 0) {
				varsD.data.starRequirement = Convert.ToInt32(starCountBracket2[0].Groups["starCount"].Value);
			}

			varsD.data.isCastleMovementSplit = (
				!varsD.data.isDoorTouchSplit &&
				!varsD.data.isBowserSplit &&
				varsD.data.starRequirement == -1
			);
		}
		
		if (varsD.data.isManualSplit) {
			return false;
		}

		Action<bool> addLevelChangeSplittingCondition = (condition) => {
			if (!varsD.data.isSplittingOnLevelChange) {
				varsD.data.isSplittingOnLevelChange = condition;
			}
		};
		
		Action<bool> addImmediateSplittingCondition = (condition) => {
			if (!varsD.data.isSplittingImmediately) {
				varsD.data.isSplittingImmediately = condition;
			}
		};
		
		// Getting all of the data based on the right ROM region.
		byte stageIndex_old = getStageIndex(varsD, oldD);
		byte stageIndex_current = getStageIndex(varsD, currentD);

		ushort animation_old = getAnimation(varsD, oldD);
		ushort animation_current = getAnimation(varsD, currentD);
		
		short starCount_current = getStarCount(varsD, currentD);
		
		bool isInCastle = CASTLE_INDEXES[stageIndex_current];
		bool isInBowserStage = BOWSER_STAGE_INDEXES[stageIndex_current];
		bool isInStage = STAGE_INDEXES[stageIndex_current];
		bool isInBowserFightStage = BOWSER_FIGHT_STAGE_INDEXES[stageIndex_current];

		bool isNoExitStarGrabSplitDelayed = isInCastle || (isInBowserStage && !varsD.settings.disableBowserRedsDelayedSplit);
		bool optionalStarReqDone = (varsD.data.starRequirement == -1 || starCount_current == varsD.data.starRequirement);

		// For the purpose of castle movement, we don't split on re-entering the same stage. Since DDD and BITFS entry are
		// pretty much the same, we count those two as the same stage as well.
		bool isSameStageEntry = (
			varsD.data.previousStage == stageIndex_current ||
			(varsD.data.previousStage == DDD_STAGE_INDEX && stageIndex_current == BITFS_STAGE_INDEX) ||
			(varsD.data.previousStage == BITFS_STAGE_INDEX && stageIndex_current == DDD_STAGE_INDEX)
		);

		// When getting the required number of stars in a non-bowser stage, we split on fadeout. If we are getting a star
		// that does not fadeout (but star count is correct), we split immediately, unless we are in castle where we split
		// on fade in (eg. toad star).
		addLevelChangeSplittingCondition(
			!varsD.data.isDoorTouchSplit &&
			!varsD.data.isBowserSplit &&
			animation_old != animation_current &&
			starCount_current == varsD.data.starRequirement &&
			(
				animation_current == STAR_GRAB_ACTION ||
				animation_current == STAR_GRAB_ACTION_SWIMMING ||
				(animation_current == STAR_GRAB_ACTION_NO_EXIT && isNoExitStarGrabSplitDelayed)
			)		
		);
		
		addImmediateSplittingCondition(
			!varsD.data.isDoorTouchSplit &&
			!varsD.data.isBowserSplit &&
			animation_old != animation_current &&
			animation_current == STAR_GRAB_ACTION_NO_EXIT &&
			!isNoExitStarGrabSplitDelayed &&
			starCount_current == varsD.data.starRequirement
		);
		
		// When we get a star grab animation in a bowser fight stage, we got the key.
		addLevelChangeSplittingCondition(
			varsD.data.isBowserSplit &&
			animation_old != animation_current &&
			animation_current == STAR_GRAB_ACTION &&
			isInBowserFightStage &&
			optionalStarReqDone
		);
		
		// When we are doing castle movement split and we enter a stage.
		addImmediateSplittingCondition(
			varsD.data.isCastleMovementSplit &&
			stageIndex_old != stageIndex_current &&
			!isSameStageEntry &&
			(isInStage || isInBowserFightStage)
		);
			
		// This is the last split and we are getting the last star, split immediately.
		addImmediateSplittingCondition(
			varsD.settings.currentSplitIndex == varsD.settings.splitCount - 1 &&
			animation_old != animation_current &&
			animation_current == FINAL_STAR_GRAB_ACTION
		);
		
		// When this is a key door split, we split as soon as door touch animation happens.
		addImmediateSplittingCondition(
			varsD.data.isDoorTouchSplit &&
			animation_old != animation_current &&
			animation_current == KEY_DOOR_TOUCH_ACTION &&
			optionalStarReqDone
		);

		// Save stage id of last stage that was entered for castle movement condition.
		if (isInStage) {
			varsD.data.previousStage = stageIndex_current;
		}

		// Split but make sure to reset conditions to avoid infinite splitting.
		if (varsD.data.isSplittingImmediately || (varsD.data.isSplittingOnLevelChange && stageIndex_old != stageIndex_current)) {
			varsD.data.isSplittingImmediately = false;
			varsD.data.isSplittingOnLevelChange = false;
			return true;
		}

		return false;
	};
	
	// Testing: unit testing is not available for these scripts, this is the best I can think of.
	Func<dynamic> mockVarsBuilder = delegate() {
		dynamic varsD = new ExpandoObject();

		Action resetFunc = delegate() {
			varsD.timerModel.resetCallCount += 1;
		};
		
		varsD.timerModel = new ExpandoObject();
		varsD.timerModel.resetCallCount = 0;
		varsD.timerModel.Reset = resetFunc;
		
		varsD.data = initVarsData();
		varsD.settings = initSettingsData();
		return varsD;
	};

	Func<bool, uint, uint, byte, ushort, short, uint, dynamic> mockStateBuilder = delegate(bool isJP, uint gameRuntime, uint globalTimer, byte stageIndex, ushort animation, short starCount, uint music) {
		dynamic state = new ExpandoObject();
		
		uint defaultDebugFunctionValue = 0xf1f1f1f1;
		state.debugFunctionJP = isJP ? DEBUG_FUNCTION_VALUE : defaultDebugFunctionValue;
		state.debugFunctionUS = isJP ? defaultDebugFunctionValue : DEBUG_FUNCTION_VALUE;
		
		uint defaultGameRuntime = 0xf2f2f2f2;
		state.gameRunTimeJP = isJP ? gameRuntime : defaultGameRuntime;
		state.gameRunTimeUS = isJP ? defaultGameRuntime : gameRuntime;
		
		uint defaultGlobalTimer = 0xf7f7f7f7;
		state.globalTimerJP = isJP ? globalTimer : defaultGlobalTimer;
		state.globalTimerUS = isJP ? defaultGlobalTimer : globalTimer;
		
		byte defaultStageIndex = 0xf3;
		state.stageIndexJP = isJP ? stageIndex : defaultStageIndex;
		state.stageIndexUS = isJP ? defaultStageIndex : stageIndex;
		
		ushort defaultAnimation = 0xf4;
		state.animationJP = isJP ? animation : defaultAnimation;
		state.animationUS = isJP ? defaultAnimation : animation;
		
		short defaultStarCount = 0xf5;
		state.starCountJP = isJP ? starCount : defaultStarCount;
		state.starCountUS = isJP ? defaultStarCount : starCount;
		
		uint defaultMusic = 0xf6f6f6f6;
		state.musicJP = isJP ? music : defaultMusic;
		state.musicUS = isJP ? defaultMusic : music;
		
		return state;
	};
	
	bool hasTestErrors = false;

	Action<bool, bool, string> assertCondition = delegate(bool isJP, bool result, string message) {
		if (!result) {
			message += isJP ? " (JP)" : " (US)";
			
			if (!hasTestErrors) {
				settings.Add("testErrors", true, "Errors running tests");
				hasTestErrors = true;
			}
			
			
			settings.Add(message, false, message, "testErrors");
		}		
	};

	Action<bool> testDoesNotResetNormalConditions = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();

		dynamic oldD = mockStateBuilder(isJP, 0, 0, 1, 0, 0, 0);
		dynamic currentD = mockStateBuilder(isJP, 1, 0, 1, 0, 0, 0);
		
		bool isUpdate = updateRunConditionInner(varsD, oldD, currentD);
		assertCondition(isJP, isUpdate, "testDoesNotResetNormalConditions: update returned false");

		bool isReset = resetRunCondition(varsD, oldD, currentD);
		assertCondition(isJP, !isReset, "testDoesNotResetNormalConditions: reset returned true");
	};

	testDoesNotResetNormalConditions(true);
	testDoesNotResetNormalConditions(false);
	
	Action<bool> testResetWhenGameRestarted = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();

		dynamic oldD = mockStateBuilder(isJP, 1, 0, 1, 0, 0, 0);
		dynamic currentD = mockStateBuilder(isJP, 0, 0, 1, 0, 0, 0);
		
		bool isUpdate = updateRunConditionInner(varsD, oldD, currentD);
		assertCondition(isJP, isUpdate, "testResetWhenGameRestarted: update returned false");
		
		varsD.data.previousStage = 10;
		
		bool isReset = resetRunCondition(varsD, oldD, currentD);
		assertCondition(isJP, isReset, "testResetWhenGameRestarted: reset returned false");
		assertCondition(isJP, varsD.data.previousStage == 0, "testResetWhenGameRestarted: previous stage was not reset to 0");
	};
	
	testResetWhenGameRestarted(true);
	testResetWhenGameRestarted(false);
	
	Action<bool> testResetWhenRTAModeAndStarsReduction = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();
		varsD.data.isRTAMode = true;

		dynamic oldD = mockStateBuilder(isJP, 0, 0, 1, 0, 60, 0);
		dynamic currentD = mockStateBuilder(isJP, 1, 0, 1, 0, 58, 0);
		
		bool isUpdate = updateRunConditionInner(varsD, oldD, currentD);
		assertCondition(isJP, isUpdate, "testResetWhenRTAModeAndStarsReduction: update returned false");
		
		varsD.data.previousStage = 10;
		
		bool isReset = resetRunCondition(varsD, oldD, currentD);
		assertCondition(isJP, isReset, "testResetWhenRTAModeAndStarsReduction: reset returned false");
		assertCondition(isJP, varsD.data.previousStage == 0, "testResetWhenRTAModeAndStarsReduction: previous stage was not reset to 0");
	};
	
	testResetWhenRTAModeAndStarsReduction(true);
	testResetWhenRTAModeAndStarsReduction(false);
	
	Action<bool> testStartRunOnFrame4 = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();

		dynamic state1 = mockStateBuilder(isJP, 1, 0, 1, 0, 0, 0);
		dynamic state2 = mockStateBuilder(isJP, 0, 1, 1, 0, 0, 0);
		dynamic state3 = mockStateBuilder(isJP, 1, 4, 1, 0, 0, 0);
		
		bool isUpdate = updateRunConditionInner(varsD, state1, state2);
		assertCondition(isJP, isUpdate, "testStartRunOnFrame4: update returned false");
	
		bool isStart = startRunCondition(varsD, state1, state2);
		assertCondition(isJP, !isStart, "testStartRunOnFrame4: start returned true before frame 4");
		
		isStart = startRunCondition(varsD, state2, state3);
		assertCondition(isJP, isStart, "testStartRunOnFrame4: start did not return true on frame 4");		
	};
	
	testStartRunOnFrame4(true);
	testStartRunOnFrame4(false);
	
	Action<bool> testStartForceOnLaunch = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();
		varsD.settings.forceLaunchOnStart = true;

		dynamic state1 = mockStateBuilder(isJP, 1, 0, 1, 0, 0, 0);
		dynamic state2 = mockStateBuilder(isJP, 0, 1, 1, 0, 0, 0);
		dynamic state3 = mockStateBuilder(isJP, 1, 4, 1, 0, 0, 0);
		
		bool isUpdate = updateRunConditionInner(varsD, state1, state2);
		assertCondition(isJP, isUpdate, "testStartForceOnLaunch: update returned false");
	
		bool isStart = startRunCondition(varsD, state1, state2);
		assertCondition(isJP, isStart, "testStartForceOnLaunch: start did not returned true on relaunch");
		
		isStart = startRunCondition(varsD, state2, state3);
		assertCondition(isJP, !isStart, "testStartForceOnLaunch: start returned true on frame 4");
	};
	
	testStartForceOnLaunch(true);
	testStartForceOnLaunch(false);
	
	// FIXME: complete testing.

	// Functions to be used in the various right places.
	vars.functions = new ExpandoObject();
	vars.functions.startRunCondition = startRunCondition;
	vars.functions.onResetRunCondition = onResetRunCondition;
	vars.functions.resetRunCondition = resetRunCondition;
	vars.functions.splitRunCondition = splitRunCondition;
	vars.functions.updateRunCondition = updateRunCondition;

	// Configure settings for this splitter now that we know it works.
	if (hasTestErrors) {
		return;
	}
	
	settings.Add("generalSettings", true, "General Settings");
	settings.Add(LAUNCH_ON_START, false, "Start on game launch instead of logo first frame (logo is more consistent, at 1.33s offset)", "generalSettings");
	settings.Add(DISABLE_RESET_AFTER_END, false, "Disable timer reset after game end (final star grab)", "generalSettings");
	settings.Add(DISABLE_RTA_MODE, false, "Disable stage RTA mode.", "generalSettings");
	settings.Add(DISABLE_BOWSER_REDS_DELAYED_SPLIT, false, "Disable bowser reds delayed split (default: split on pipe entry)", "generalSettings");

    settings.Add("gameVersion", false, "Force Game Version (defaults to automatic detection, recommended)");
	settings.Add(GAME_VERSION_JP, false, "JP", "gameVersion");
    settings.Add(GAME_VERSION_US, false, "US", "gameVersion");
}

start {
	return vars.functions.startRunCondition(vars, old, current);
}

reset {
	return vars.functions.resetRunCondition(vars, old, current);
}

onReset {
	vars.functions.onResetRunCondition(vars);
}

split {
	return vars.functions.splitRunCondition(vars, old, current);
}

update {
	return vars.functions.updateRunCondition(timer, settings, vars, old, current);
}