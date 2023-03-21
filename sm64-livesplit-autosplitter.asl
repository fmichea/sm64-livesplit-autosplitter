// Version: 3.0.1

// Code: https://github.com/n64decomp/sm64/
// Address map: https://github.com/SM64-TAS-ABC/STROOP/tree/Development/STROOP/Mappings
// Sometimes needs to be offset for endianness: long:0, short:-2 or +2, byte:0 or +3????

state("Project64") {
	// This looks like it always has value DEBUG_FUNCTION_VALUE in the correct ROM.
	// Used to determine which ROM is currently loaded in PJ64 automatically.
	uint debugFunctionJP : "Project64.exe", 0xD6A1C, 0x2CA6E0;
	uint debugFunctionUS : "Project64.exe", 0xD6A1C, 0x2CB1C0;

	uint gameRunTimeJP : "Project64.exe", 0xD6A1C, 0x32C640;
	uint gameRunTimeUS : "Project64.exe", 0xD6A1C, 0x32D580;

	uint globalTimerJP : "Project64.exe", 0xD6A1C, 0x32C694;
	uint globalTimerUS : "Project64.exe", 0xD6A1C, 0x32D5D4;

	byte stageIndexJP : "Project64.exe", 0xD6A1C, 0x32CE9A; // N64 addr: 0x8032CE98
	byte stageIndexUS : "Project64.exe", 0xD6A1C, 0x32DDFA; // N64 addr: 0x8032DDF8

	uint animationJP : "Project64.exe", 0xD6A1C, 0x339E0C; // N64 addr: 0x80339E00 + 0xC (struct field)
	uint animationUS : "Project64.exe", 0xD6A1C, 0x33B17C; // N64 addr: 0x8033B170 + 0xC (struct field)

	ushort starCountJP : "Project64.exe", 0xD6A1C, 0x339EA8; // N64 addr: 0x80339E00 + 0xAA (struct field)
	ushort starCountUS : "Project64.exe", 0xD6A1C, 0x33B218; // N64 addr: 0x8033B170 + 0xAA (struct field)

	uint musicJP : "Project64.exe", 0xD6A1C, 0x222A1C;
	uint musicUS : "Project64.exe", 0xD6A1C, 0x22261C;

	ushort hudCameraModeJP : "Project64.exe", 0xD6A1C, 0x3314FA; // N64 addr: 0x803314F8
	ushort hudCameraModeUS : "Project64.exe", 0xD6A1C, 0x33260A; // N64 addr: 0x80332608

	float positionXJP : "Project64.exe", 0xD6A1C, 0x339E3C; // N64 addr: 0x80339E00 + 0x3C (struct field) + 0x0 (array offset)
	float positionXUS : "Project64.exe", 0xD6A1C, 0x33B1AC; // N64 addr: 0x8033B170 + 0x3C (struct field) + 0x0 (array offset)

	float positionYJP : "Project64.exe", 0xD6A1C, 0x339E40; // N64 addr: 0x80339E00 + 0x3C (struct field) + 0x4 (array offset)
	float positionYUS : "Project64.exe", 0xD6A1C, 0x33B1B0; // N64 addr: 0x8033B170 + 0x3C (struct field) + 0x4 (array offset)

	float positionZJP : "Project64.exe", 0xD6A1C, 0x339E44; // N64 addr: 0x80339E00 + 0x3C (struct field) + 0x8 (array offset)
	float positionZUS : "Project64.exe", 0xD6A1C, 0x33B1B4; // N64 addr: 0x8033B170 + 0x3C (struct field) + 0x8 (array offset)

	byte warpDestinationJP : "Project64.exe", 0xD6A1C, 0x339EDA; // N64 addr: 0x80339ED8 + 0x4 (struct field)
	byte warpDestinationUS : "Project64.exe", 0xD6A1C, 0x33B24A; // N64 addr: 0x8033B248 + 0x4 (struct field)

	// Files from gSaveBuffer, each file is 0x70 apart.
	uint fileAFlagsJP : "Project64.exe", 0xD6A1C, 0x207B08;
	uint fileAFlagsUS : "Project64.exe", 0xD6A1C, 0x207708;

	uint fileBFlagsJP : "Project64.exe", 0xD6A1C, 0x207B78;
	uint fileBFlagsUS : "Project64.exe", 0xD6A1C, 0x207778;

	uint fileCFlagsJP : "Project64.exe", 0xD6A1C, 0x207BE8;
	uint fileCFlagsUS : "Project64.exe", 0xD6A1C, 0x2077E8;

	uint fileDFlagsJP : "Project64.exe", 0xD6A1C, 0x207C58;
	uint fileDFlagsUS : "Project64.exe", 0xD6A1C, 0x207858;

	// Non-stop code writes 0/2400 to this address when enabled, changing interactions.
	ushort nonStopInteractionOverwriteJP : "Project64.exe", 0xD6A1C, 0x24DC1E; // N64 addr: 0x8024DC1C (found in Gameshark Code).
	ushort nonStopInteractionOverwriteUS : "Project64.exe", 0xD6A1C, 0x24DDBE; // N64 addr: 0x8024DDBC (found in Gameshark Code).

	byte menuSelectedButtonIDJP : "Project64.exe", 0xD6A1C, 0x1A7BD3; // N64 addr: 0x801A7BD0
	byte menuSelectedButtonIDUS : "Project64.exe", 0xD6A1C, 0x1A7D13; // N64 addr: 0x801A7D10

	short menuClickPosJP : "Project64.exe", 0xD6A1C, 0x1A7BE8;
	short menuClickPosUS : "Project64.exe", 0xD6A1C, 0x1A7D28;
}

startup {
	Func<string[], List<string[]>> buildKeywords = delegate(string[] phrases) {
		List<string[]> result = new List<string[]>();

		foreach (string phrase in phrases) {
			string[] words = phrase.ToLower().Split(' ');
			result.Add(words);
		}

		return result;
	};

	// ********** USER_CUSTOMIZATION_BEGIN **********
	//
	// This auto-splitter uses certain keywords in split names in order to detect special types of splits. Each
	// is explained here. Some rules:
	//
	//     - You may only modify this part of the code to add your own keywords and maintain upstream support.
	//     - Keywords must be lowercase below, but they will match all cases, they must always match a full word (eg. "dw" will match "dw (9)" but not "wdw (39)").
	//     - Keywords may only be alpha-numeric values (no special characters).
	//     - You may include a phrase instead of a word, it will then match all cases/spacing of that phrase. (eg. "mips clip" matches "MipS    Clip")
	//
	// Please note that these changes will apply to all of your splits. Remember to port any changes you make to
	// new version whenever updating this script.

	// NO_RESET_SECONDS_LEEWAY: number of seconds given to double-reset and actually reset timer on [noreset] splits.
	//     Set to 0 to disable double-resetting behavior.
	int NO_RESET_SECONDS_LEEWAY = 3;

	// BOWSER_FIGHT_KEYWORDS: Any split name containing these keywords will split only once bowser fight is won.
	List<string[]> BOWSER_FIGHT_KEYWORDS = buildKeywords(new string[] {
		"bowser",
		"key",
	});

	// BOWSER_STAGE_KEYWORDS: Any split name containing one of these keywords will split on pipe entry within bowser
	//    stages (dark world, fire sea, sky).
	List<string[]> BOWSER_STAGE_KEYWORDS = buildKeywords(new string[] {
		"pipe",
	});

	// KEY_UNLOCK_KEYWORDS: Any split name containing these keywords will split only once a key door is unlocked.
	List<string[]> KEY_UNLOCK_KEYWORDS = buildKeywords(new string[] {
		"upstairs",
		"basement",
	});

	// MIPS_CLIP_KEYWORDS: Any split name containing these keywords will split on DDD entry (when entering XCAM).
	List<string[]> MIPS_CLIP_KEYWORDS = buildKeywords(new string[] {
		"mips clip",
	});

	// ********** USER_CUSTOMIZATION_END **********

	byte BOB_STAGE_INDEX = 9;
	byte CCM_STAGE_INDEX = 5;
	byte WF_STAGE_INDEX = 24;
	byte JRB_STAGE_INDEX = 12;
	byte BBH_STAGE_INDEX = 4;
	byte SSL_STAGE_INDEX = 8;
	byte LLL_STAGE_INDEX = 22;
	byte HMC_STAGE_INDEX = 7;
	byte DDD_STAGE_INDEX = 23;
	byte WDW_STAGE_INDEX = 11;
	byte THI_STAGE_INDEX = 13;
	byte TTM_STAGE_INDEX = 36;
	byte SL_STAGE_INDEX = 10;
	byte TTC_STAGE_INDEX = 14;
	byte RR_STAGE_INDEX = 15;

	byte BITDW_STAGE_INDEX = 17;
	byte BITFS_STAGE_INDEX = 19;
	byte BITS_STAGE_INDEX = 21;

	byte BOWSER1_STAGE_INDEX = 30;
	byte BOWSER2_STAGE_INDEX = 33;
	byte BOWSER3_STAGE_INDEX = 34;

	byte TOTWC_STAGE_INDEX = 29;
	byte VCUTM_STAGE_INDEX = 18;
	byte WMOTR_STAGE_INDEX = 31;
	byte COTMC_STAGE_INDEX = 28;
	byte AQUA_STAGE_INDEX =  20;
	byte PSS_STAGE_INDEX = 27;

	byte CASTLE_INSIDE_STAGE_INDEX = 6; // Basement + Lobby + Upstairs + Tippy
	byte CASTLE_OUTSIDE_FRONT_STAGE_INDEX = 16; // Garden & Moat (Outside Front)
	byte CASTLE_OUTSIDE_BACK_STAGE_INDEX = 26; // Castle Courtyard (Outside Back)

	// Arrays used to quickly check which stage we are in.
	bool[] BOWSER_FIGHT_STAGE_INDEXES = new bool[0x100];
	BOWSER_FIGHT_STAGE_INDEXES[BOWSER1_STAGE_INDEX] = true;
	BOWSER_FIGHT_STAGE_INDEXES[BOWSER2_STAGE_INDEX] = true;
	BOWSER_FIGHT_STAGE_INDEXES[BOWSER3_STAGE_INDEX] = true;

	bool[] BITX_STAGE_INDEXES = new bool[0x100];
	BITX_STAGE_INDEXES[BITDW_STAGE_INDEX] = true;
	BITX_STAGE_INDEXES[BITFS_STAGE_INDEX] = true;
	BITX_STAGE_INDEXES[BITS_STAGE_INDEX] = true;

	bool[] STAGE_INDEXES = new bool[0x100];
	STAGE_INDEXES[AQUA_STAGE_INDEX] = true;
	STAGE_INDEXES[BBH_STAGE_INDEX] = true;
	STAGE_INDEXES[BITDW_STAGE_INDEX] = true;
	STAGE_INDEXES[BITFS_STAGE_INDEX] = true;
	STAGE_INDEXES[BITS_STAGE_INDEX] = true;
	STAGE_INDEXES[BOB_STAGE_INDEX] = true;
	STAGE_INDEXES[CCM_STAGE_INDEX] = true;
	STAGE_INDEXES[DDD_STAGE_INDEX] = true;
	STAGE_INDEXES[HMC_STAGE_INDEX] = true;
	STAGE_INDEXES[JRB_STAGE_INDEX] = true;
	STAGE_INDEXES[LLL_STAGE_INDEX] = true;
	STAGE_INDEXES[PSS_STAGE_INDEX] = true;
	STAGE_INDEXES[RR_STAGE_INDEX] = true;
	STAGE_INDEXES[SL_STAGE_INDEX] = true;
	STAGE_INDEXES[SSL_STAGE_INDEX] = true;
	STAGE_INDEXES[THI_STAGE_INDEX] = true;
	STAGE_INDEXES[TOTWC_STAGE_INDEX] = true;
	STAGE_INDEXES[TTC_STAGE_INDEX] = true;
	STAGE_INDEXES[TTM_STAGE_INDEX] = true;
	STAGE_INDEXES[VCUTM_STAGE_INDEX] = true;
	STAGE_INDEXES[WDW_STAGE_INDEX] = true;
	STAGE_INDEXES[WF_STAGE_INDEX] = true;
	STAGE_INDEXES[WMOTR_STAGE_INDEX] = true;
	STAGE_INDEXES[COTMC_STAGE_INDEX] = true;

	bool[] CASTLE_STAGE_INDEXES = new bool[0x100];
	CASTLE_STAGE_INDEXES[CASTLE_INSIDE_STAGE_INDEX] = true;
	CASTLE_STAGE_INDEXES[CASTLE_OUTSIDE_FRONT_STAGE_INDEX] = true;
	CASTLE_STAGE_INDEXES[CASTLE_OUTSIDE_BACK_STAGE_INDEX] = true;

	// Short-hand used to
	Dictionary<string, byte> STAGE_NAMES_TO_INDEX = new Dictionary<string, byte>();
	STAGE_NAMES_TO_INDEX["aqua"] = AQUA_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["bbh"] = BBH_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["bob"] = BOB_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["bow1"] = BOWSER1_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["bow2"] = BOWSER2_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["bow3"] = BOWSER3_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["ccm"] = CCM_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["cotmc"] = COTMC_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["ddd"] = DDD_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["dw"] = BITDW_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["fs"] = BITFS_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["hmc"] = HMC_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["jrb"] = JRB_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["lll"] = LLL_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["pss"] = PSS_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["rr"] = RR_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["sky"] = BITS_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["sl"] = SL_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["ssl"] = SSL_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["thi"] = THI_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["totwc"] = TOTWC_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["ttc"] = TTC_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["ttm"] = TTM_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["vcutm"] = VCUTM_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["wdw"] = WDW_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["wf"] = WF_STAGE_INDEX;
	STAGE_NAMES_TO_INDEX["wmotr"] = WMOTR_STAGE_INDEX;

	// Settings for this auto splitter.
	string GAME_VERSION_JP = "gameVersionJP";
	string GAME_VERSION_US = "gameVersionUS";

	string LAUNCH_ON_START = "launchOnStart";
	string DISABLE_RESET_AFTER_END = "disableResetAfterEnd";
	string DISABLE_RTA_MODE = "disableRTAMode";
	string DISABLE_BOWSER_REDS_DELAYED_SPLIT = "disableBowserRedsDelayedSplit";
	string DISABLE_AUTO_START_ON_FILE_D = "disableAutoStartOnFileD";

	// Splitting time is controlled depending on the type of split this is.
	int SPLIT_TYPE_MANUAL = -1;
	int SPLIT_TYPE_CASTLE_MOVEMENT = 0;
	int SPLIT_TYPE_KEY_GRAB = 1;
	int SPLIT_TYPE_KEY_DOOR_UNLOCK = 2;
	int SPLIT_TYPE_BOWSER_PIPE_ENTRY = 3;
	int SPLIT_TYPE_MIPS_CLIP = 4;
	int SPLIT_TYPE_STAR_GRAB = 5;
	int SPLIT_TYPE_STAR_DOOR_ENTRY = 6;
	int SPLIT_TYPE_STAGE_ENTRY = 7;
	int SPLIT_TYPE_STAGE_EXIT = 8;
	int SPLIT_TYPE_FINAL_STAR_GRAB = 9;

	// Constant values used within the code.
	uint ACT_STAR_DANCE_EXIT = 0x1302;
	uint ACT_STAR_DANCE_WATER = 0x1303;
	uint ACT_STAR_DANCE_NO_EXIT = 0x1307;

	uint ACT_UNLOCKING_KEY_DOOR = 0x132e;

	uint ACT_ENTERING_STAR_DOOR = 0x1331;

	uint ACT_JUMBO_STAR_CUTSCENE = 0x1909;

	uint[] DOOR_XCAM_COUNT_ACTIONS = new uint[]{
		0x1320, // ACT_PULLING_DOOR
		0x1321, // ACT_PUSHING_DOOR
		ACT_UNLOCKING_KEY_DOOR,
		ACT_ENTERING_STAR_DOOR,
	};

	uint DEBUG_FUNCTION_VALUE = 0x27bdffd8;

	uint STAR_SELECT_MUSIC = 0x800d1600;

	ushort FIXED_CAMERA_HUD = 0x4;
	ushort FIXED_CAMERA_CDOWN_HUD = 0xC;

	ushort NON_STOP_OVERWRITE_VALUE_GAMESHARK = 0x2400;
	ushort NON_STOP_OVERWRITE_VALUE_USAMUNE = 0x0;

	uint KEY_FLAGS = 0x10 | 0x20;

	// Allows defining a 3D rectangular box to checkpoint mario's position for various splitting conditions.
	Func<byte, float, float, float, float, float, float, dynamic> create3DBox = delegate(byte stageIndex, float x1, float y1, float z1, float x2, float y2, float z2) {
		dynamic box = new ExpandoObject();

		box.stageIndex = stageIndex;
		box.x1 = x1;
		box.y1 = y1;
		box.z1 = z1;
		box.x2 = x2;
		box.y2 = y2;
		box.z2 = z2;

		return box;
	};

	// Measured outside the 8 star door on castle lobby side.
	// Actual measured values and their corresponding visual direction:
	//    X (depth to door):       -2800 (after door, also left side), -2300 (before door)
	//    Y (height above ground):   512 (ground),                       704 (double jump)
	//    Z (width of hallway):    -1587 (right side),                 -1100 (left side),
	dynamic STAR_DOOR_8_POSITION = create3DBox(
		CASTLE_INSIDE_STAGE_INDEX,
		-2800, 500, -1600,
		-2200, 800, -1050
	);

	// Measured outside the 30 star door on SBLJ stairs side.
	// Actual measured values and their corresponding visual direction:
	//    X (depth to door):           0 (before door),  600 (after door)
	//    Y (height above ground): -1074 (floor),       -465 (triple jump max height seen)
	//    Z (width around door):    1750 (left side),   2300 (right side)
	dynamic STAR_DOOR_30_POSITION = create3DBox(
		CASTLE_INSIDE_STAGE_INDEX,
		0, -1090, 1700,
		600, -200, 2300
	);

	// Measured outside the 50 star door on upstairs side.
	// Actual measured values and their corresponding visual direction:
	//    X (width around door):   -615 (right side),   206 (left side),
	//    Y (height above ground): 2253 (ground),      2418 (double jump)
	//    Z (depth into the door): 4400 (before door), 4900 (after door)
	dynamic STAR_DOOR_50_POSITION = create3DBox(
		CASTLE_INSIDE_STAGE_INDEX,
		-600, 2200, 4400,
		230, 2500, 4900
	);

	// Measured outside the 70 star door on tippy side.
	// Actual measured values and their corresponding visual direction:
	//    X (width around door):   -450 (left side),    65 (right side)
	//    Y (height above ground): 3174 (ground),     3500 (double jump)
	//    Z (depth into the door): 3670 (after door), 4100 (before door)
	dynamic STAR_DOOR_70_POSITION = create3DBox(
		CASTLE_INSIDE_STAGE_INDEX,
		-450, 3160, 3670,
		65, 3700, 4100
	);

	// Regexes used to parse clean up split name into proper groups.
	System.Text.RegularExpressions.Regex BRACKET_TYPE1 = new System.Text.RegularExpressions.Regex(@"(AS:)?\[(?<values>[\w\d,=-]+)\]");
	System.Text.RegularExpressions.Regex BRACKET_TYPE2 = new System.Text.RegularExpressions.Regex(@"(AS:)?\((?<values>[\w\d,=-]+)\)");

	// Flags within the splitter information (in brackets).
	System.Text.RegularExpressions.Regex STAR_COUNT = new System.Text.RegularExpressions.Regex(@"^(?<starCount>\d+)$");
	System.Text.RegularExpressions.Regex ENTRY = new System.Text.RegularExpressions.Regex(@"^entry=(?<stageID>(\w+|\d+))$");
	System.Text.RegularExpressions.Regex EXIT = new System.Text.RegularExpressions.Regex(@"^exit=(?<stageID>(\w+|\d+))$");
	System.Text.RegularExpressions.Regex STAR_DOOR = new System.Text.RegularExpressions.Regex(@"^star-door=(?<starCount>(8|30|50|70))$");
	System.Text.RegularExpressions.Regex MODE = new System.Text.RegularExpressions.Regex(@"^run-mode=(?<modeName>(romhack|rta))$");

	// TODO(#6): AutoSplitter64 compatibility
	// System.Text.RegularExpressions.Regex XCAM_COUNT = new System.Text.RegularExpressions.Regex(@"^xcam=(?<count>\d+)$");
	// System.Text.RegularExpressions.Regex DOOR_XCAM_COUNT = new System.Text.RegularExpressions.Regex(@"^door-xcam=(?<count>\d+)$");
	// System.Text.RegularExpressions.Regex FADE_IN_COUNT = new System.Text.RegularExpressions.Regex(@"^fade-in=(?<count>\d+)$");
	// System.Text.RegularExpressions.Regex FADE_OUT_COUNT = new System.Text.RegularExpressions.Regex(@"^fade-out=(?<count>\d+)$");

	// Helper attributes related to LiveSplit.
	vars.timerModel = new TimerModel { CurrentState = timer };

	// Working data which can be changed in various places.
	Func<ExpandoObject> initSplitConfigData = delegate() {
		dynamic data = new ExpandoObject();

		data.starCountRequirement = -1;
		data.entryStageID = -1;
		data.exitStageID = -1;
		data.starDoorID = -1;

		data.type = SPLIT_TYPE_CASTLE_MOVEMENT;

		data.isNoReset = false;
		data.isForcedFade = false;
		data.isForcedImmediate = false;

		return data;
	};

	Func<ExpandoObject> initSplitConditionsData = delegate() {
		dynamic data = new ExpandoObject();

		data.isSplittingOnFade = false;
		data.isSplittingImmediately = false;

		return data;
	};

	Func<ExpandoObject> initRunLiveData = delegate() {
		dynamic data = new ExpandoObject();

		data.previousStage = 0;
		data.selectedFileID = -1;

		data.wantToReset = false;
		data.wantToResetTiming = 0;

		return data;
	};

	Func<ExpandoObject> initRunConfigData = delegate() {
		dynamic data = new ExpandoObject();

		data.isJapaneseVersion = false;
		data.isRTAMode = false;
		data.relaxedFadeMatch = false;

		data.lastSplitName = "";
		data.lastFirstSplitName = "";

		return data;
	};

	Func<ExpandoObject> initVarsData = delegate() {
		dynamic data = new ExpandoObject();

		data.splitConfig = initSplitConfigData();
		data.splitConditions = initSplitConditionsData();
		data.runLiveData = initRunLiveData();
		data.runConfig = initRunConfigData();

		data.updateCounter = (uint) 0;

		return data;
	};

	// resetVarsDataForSplitChange re-initializes configuration related to split.
	Action<dynamic, string> resetVarsDataForSplitChange = delegate(dynamic varsD, string splitName) {
		varsD.data.splitConfig = initSplitConfigData();
		varsD.data.splitConditions = initSplitConditionsData();
		varsD.data.runConfig.lastSplitName = splitName;
	};

	// resetVarsDataForFirstSplitChange re-initializes configuration related to run configuration.
	Action<dynamic, string> resetVarsDataForFirstSplitChange = delegate(dynamic varsD, string splitName) {
		varsD.data.runConfig = initRunConfigData();
		varsD.data.runConfig.lastFirstSplitName = splitName;
	};

	vars.data = initVarsData();

	// Settings are copied to this for testing purposes.
	Func<ExpandoObject> initSettingsData = delegate() {
		dynamic settingsD = new ExpandoObject();

		settingsD.isResetEnabled = false;
		settingsD.currentTimerPhase = TimerPhase.NotRunning;
		settingsD.currentSplitIndex = -1;
		settingsD.splitCount = 0;
		settingsD.forceLaunchOnStart = false;
		settingsD.forceJPGameVersion = false;
		settingsD.forceUSGameVersion = false;
		settingsD.disableResetAfterEnd = false;
		settingsD.disableRTAMode = false;
		settingsD.disableBowserRedsDelayedSplit = false;
		settingsD.disableAutoStartOnFileD = false;

		return settingsD;
	};

	vars.settings = initSettingsData();

	// Debugging function.
	Func<dynamic, string> varsToString = delegate(dynamic varsD) {
		string result = "";

		result += "\n\n";
		result += string.Format("    varsD.data.splitConfig.type = {0}\n", varsD.data.splitConfig.type);
		result += string.Format("    varsD.data.splitConfig.starCountRequirement = {0}\n", varsD.data.splitConfig.starCountRequirement);
		result += string.Format("    varsD.data.splitConfig.entryStageID = {0}\n", varsD.data.splitConfig.entryStageID);
		result += string.Format("    varsD.data.splitConfig.exitStageID = {0}\n", varsD.data.splitConfig.exitStageID);
		result += string.Format("    varsD.data.splitConfig.starDoorID = {0}\n", varsD.data.splitConfig.starDoorID);
		result += string.Format("    varsD.data.splitConfig.isNoReset = {0}\n", varsD.data.splitConfig.isNoReset);
		result += string.Format("    varsD.data.splitConfig.isForcedFade = {0}\n", varsD.data.splitConfig.isForcedFade);
		result += string.Format("    varsD.data.splitConfig.isForcedImmediate = {0}\n", varsD.data.splitConfig.isForcedImmediate);
		result += "\n";
		result += string.Format("    varsD.data.splitConditions.isSplittingOnFade = {0}\n", varsD.data.splitConditions.isSplittingOnFade);
		result += string.Format("    varsD.data.splitConditions.isSplittingImmediately = {0}\n", varsD.data.splitConditions.isSplittingImmediately);
		result += "\n";
		result += string.Format("    varsD.data.runConfig.isJapaneseVersion = {0}\n", varsD.data.runConfig.isJapaneseVersion);
		result += string.Format("    varsD.data.runConfig.isRTAMode = {0}\n", varsD.data.runConfig.isRTAMode);
		result += string.Format("    varsD.data.runConfig.relaxedFadeMatch = {0}\n", varsD.data.runConfig.relaxedFadeMatch);
		result += string.Format("    varsD.data.runConfig.lastSplitName = {0}\n", varsD.data.runConfig.lastSplitName);
		result += string.Format("    varsD.data.runConfig.lastFirstSplitName = {0}\n", varsD.data.runConfig.lastFirstSplitName);
		result += "\n";
		result += string.Format("    varsD.data.runLiveData.selectedFileID = {0}\n", varsD.data.runLiveData.selectedFileID);
		result += string.Format("    varsD.data.runLiveData.previousStage = {0}\n", varsD.data.runLiveData.previousStage);
		result += string.Format("    varsD.data.runLiveData.wantToReset = {0}\n", varsD.data.runLiveData.wantToReset);
		result += string.Format("    varsD.data.runLiveData.wantToResetTiming = {0}\n", varsD.data.runLiveData.wantToResetTiming);
		result += "\n";
		result += string.Format("    varsD.settings.isResetEnabled = {0}\n", varsD.settings.isResetEnabled);
		result += string.Format("    varsD.settings.currentTimerPhase = {0}\n", varsD.settings.currentTimerPhase);
		result += string.Format("    varsD.settings.currentSplitIndex = {0}\n", varsD.settings.currentSplitIndex);
		result += string.Format("    varsD.settings.splitCount = {0}\n", varsD.settings.splitCount);
		result += string.Format("    varsD.settings.forceLaunchOnStart = {0}\n", varsD.settings.forceLaunchOnStart);
		result += string.Format("    varsD.settings.disableAutoStartOnFileD = {0}\n", varsD.settings.disableAutoStartOnFileD);
		result += string.Format("    varsD.settings.forceJPGameVersion = {0}\n", varsD.settings.forceJPGameVersion);
		result += string.Format("    varsD.settings.forceUSGameVersion = {0}\n", varsD.settings.forceUSGameVersion);
		result += string.Format("    varsD.settings.disableResetAfterEnd = {0}\n", varsD.settings.disableResetAfterEnd);
		result += string.Format("    varsD.settings.disableRTAMode = {0}\n", varsD.settings.disableRTAMode);
		result += string.Format("    varsD.settings.disableBowserRedsDelayedSplit = {0}\n", varsD.settings.disableBowserRedsDelayedSplit);
		return result;
	};

	// Helper function used in code to avoid duplication related to ROM version handling.
	Func<dynamic, dynamic, uint> getGameRuntime = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.gameRunTimeJP : state.gameRunTimeUS;
	};

	Func<dynamic, dynamic, uint> getGlobalTimer = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.globalTimerJP : state.globalTimerUS;
	};

	Func<dynamic, dynamic, byte> getStageIndex = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.stageIndexJP : state.stageIndexUS;
	};

	Func<dynamic, dynamic, uint> getAnimation = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.animationJP : state.animationUS;
	};

	Func<dynamic, dynamic, ushort> getStarCount = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.starCountJP : state.starCountUS;
	};

	Func<dynamic, dynamic, uint> getMusicTrack = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.musicJP : state.musicUS;
	};

	Func<dynamic, dynamic, ushort> getHUDCameraMode = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.hudCameraModeJP : state.hudCameraModeUS;
	};

	Func<dynamic, dynamic, float> getPositionX = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.positionXJP : state.positionXUS;
	};

	Func<dynamic, dynamic, float> getPositionY = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.positionYJP : state.positionYUS;
	};

	Func<dynamic, dynamic, float> getPositionZ = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.positionZJP : state.positionZUS;
	};

	Func<dynamic, dynamic, byte> getWarpDestination = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.warpDestinationJP : state.warpDestinationUS;
	};

	Func<dynamic, dynamic, ushort> getNonStopInteractionOverwrite = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.nonStopInteractionOverwriteJP : state.nonStopInteractionOverwriteUS;
	};

	Func<dynamic, dynamic, uint> getFileFlags = delegate(dynamic varsD, dynamic state) {
		if (varsD.data.runLiveData.selectedFileID == 0) {
			return varsD.data.runConfig.isJapaneseVersion ? state.fileAFlagsJP : state.fileAFlagsUS;
		} else if (varsD.data.runLiveData.selectedFileID == 1) {
			return varsD.data.runConfig.isJapaneseVersion ? state.fileBFlagsJP : state.fileBFlagsUS;
		} else if (varsD.data.runLiveData.selectedFileID == 2) {
			return varsD.data.runConfig.isJapaneseVersion ? state.fileCFlagsJP : state.fileCFlagsUS;
		} else if (varsD.data.runLiveData.selectedFileID == 3) {
			return varsD.data.runConfig.isJapaneseVersion ? state.fileDFlagsJP : state.fileDFlagsUS;
		}
		return 0;
	};

	Func<dynamic, dynamic, uint> getFileAFlags = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.fileAFlagsJP : state.fileAFlagsUS;
	};

	Func<dynamic, dynamic, byte> getMenuSelectedButtonID = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.menuSelectedButtonIDJP : state.menuSelectedButtonIDUS;
	};

	Func<dynamic, dynamic, short> getMenuClickPos = delegate(dynamic varsD, dynamic state) {
		return varsD.data.runConfig.isJapaneseVersion ? state.menuClickPosJP : state.menuClickPosUS;
	};

	// isIn3DBox returns true if mario is currently in the defined 3D box.
	Func<dynamic, dynamic, dynamic, bool> isIn3DBox = delegate(dynamic varsD, dynamic currentD, dynamic box) {
		byte stageIndex = getStageIndex(varsD, currentD);

		float positionX = getPositionX(varsD, currentD);
		float positionY = getPositionY(varsD, currentD);
		float positionZ = getPositionZ(varsD, currentD);

		return (
			stageIndex == box.stageIndex &&
			box.x1 <= positionX && positionX <= box.x2 &&
			box.y1 <= positionY && positionY <= box.y2 &&
			box.z1 <= positionZ && positionZ <= box.z2
		);
	};

	// isStageFadeIn returns true when mario first enters a stage painting from anywhere in the castle.
	Func<byte, byte, bool> isStageFadeIn = delegate(byte stageIndex_old, byte stageIndex_current) {
		return (
			stageIndex_old != stageIndex_current &&
			CASTLE_STAGE_INDEXES[stageIndex_old] &&
			STAGE_INDEXES[stageIndex_current]
		);
	};

	// isStageFadeOut returns true when mario exists any stage to castle, or to bowser fight.
	Func<byte, byte, bool> isStageFadeOut = delegate(byte stageIndex_old, byte stageIndex_current) {
		return (
			stageIndex_old != stageIndex_current &&
			(
				(STAGE_INDEXES[stageIndex_old] && CASTLE_STAGE_INDEXES[stageIndex_current]) ||
				(STAGE_INDEXES[stageIndex_old] && BOWSER_FIGHT_STAGE_INDEXES[stageIndex_current]) ||
				(BOWSER_FIGHT_STAGE_INDEXES[stageIndex_old] && CASTLE_STAGE_INDEXES[stageIndex_current])
			)
		);
	};

	// splitWordsOnWhitespace returns all unique words from text.
	Func<string, string[]> splitWordsOnWhitespace = delegate(string text) {
		return System.Text.RegularExpressions.Regex.Split(text, @"\s+");
	};

	// parseStageID takes the id within entry=* and exit=* format, and returns the id as a byte.
	Func<string, byte> parseStageID = delegate(string stageID) {
		if (STAGE_NAMES_TO_INDEX.ContainsKey(stageID)) {
			return STAGE_NAMES_TO_INDEX[stageID];
		} else {
			try {
				return ((byte) Convert.ToInt32(stageID));
			} catch (Exception e) {
				print(string.Format("The value {0} is not in a recognizable stageID format (number or recognizable stage name): {1}", stageID, e));
				return ((byte) 0xff);
			}
		}
	};

	// parseStarDoorID taks the id within star-door=* format, and returns the id as a byte.
	Func<string, ushort> parseStarDoorID = delegate(string starCount) {
		return ((ushort) Convert.ToInt32(starCount));
	};

	// parseSplitNameForAction is an helper function to make it easier to implement instructions
	// parser inside of split names.
	Action<dynamic, string, Action<dynamic, dynamic, string[]>, Action<dynamic, dynamic, string>> parseSplitNameForAction = delegate(dynamic varsD, string splitName, Action<dynamic, dynamic, string[]> parseWords, Action<dynamic, dynamic, string> parseInstructions) {
		splitName = splitName.TrimStart('-');

		string[] splitNameWords = splitWordsOnWhitespace(splitName);

		dynamic splitConfig = varsD.data.splitConfig;
		dynamic runConfig = varsD.data.runConfig;

		if (parseWords != null) {
			parseWords(runConfig, splitConfig, splitNameWords);
		}

		System.Text.RegularExpressions.MatchCollection splitterInstructions1 = BRACKET_TYPE1.Matches(splitName);
		foreach (System.Text.RegularExpressions.Match match in splitterInstructions1) {
			foreach (string val in match.Groups["values"].Value.Split(',')) {
				parseInstructions(runConfig, splitConfig, val);
			}
		}

		System.Text.RegularExpressions.MatchCollection splitterInstructions2 = BRACKET_TYPE2.Matches(splitName);
		foreach (System.Text.RegularExpressions.Match match in splitterInstructions2) {
			foreach (string val in match.Groups["values"].Value.Split(',')) {
				parseInstructions(runConfig, splitConfig, val);
			}
		}
	};

	// hasOccurenceOfAnyPhrase returns true if the sequence of words provided contains any of the sequences of words
	// in wantedPhrases (eg. does {"this", "is", "a", "test"} contains any of {{ "is", "good" }, {"a", "test"}}.)
	Func<string[], List<string[]>, bool> hasOccurenceOfAnyPhrase = delegate(string[] words, List<string[]> wantedPhrases) {
		List<string> wordsLst = new List<string>(words);

		foreach (string[] wantedPhrase in wantedPhrases) {
			if (wantedPhrase.Length == 0) {
				continue;
			}

			string firstWord = wantedPhrase[0];
			int wordCount = wantedPhrase.Length;

			int startIdx = 0;
			while (startIdx != -1) {
				startIdx = wordsLst.IndexOf(firstWord, startIdx);

				if (startIdx != -1) {
					if (string.Join(" ", wordsLst.GetRange(startIdx, wordCount)) == string.Join(" ", wantedPhrase)) {
						return true;
					}
					startIdx++;
				}
			}
		}

		return false;
	};

	// parseRunInstructions parses run config information from the first split.
	Action<dynamic, dynamic, string> parseRunInstructions = delegate(dynamic runConfig, dynamic splitConfig, string val) {
		System.Text.RegularExpressions.MatchCollection modeMatch = MODE.Matches(val);
		if (modeMatch.Count != 0) {
			switch (modeMatch[0].Groups["modeName"].Value) {
			case "romhack":
				runConfig.relaxedFadeMatch = true;
				break;

			case "rta":
				runConfig.isRTAMode = true;
				break;
			};
		}
	};

	// parseRunConfigFromFirstSplit retrieves run information from the first split name.
	Action<dynamic, string> parseRunConfigFromFirstSplit = delegate(dynamic varsD, string splitName) {
		parseSplitNameForAction(varsD, splitName, null, parseRunInstructions);
	};

	// parseSplitConfigWords finds special split types from the split name words.
	Action<dynamic, dynamic, string[]> parseSplitConfigWords = delegate(dynamic runConfig, dynamic splitConfig, string[] words) {
		if (hasOccurenceOfAnyPhrase(words, BOWSER_FIGHT_KEYWORDS)) {
			splitConfig.type = SPLIT_TYPE_KEY_GRAB;
		} else if (hasOccurenceOfAnyPhrase(words, BOWSER_STAGE_KEYWORDS)) {
			splitConfig.type = SPLIT_TYPE_BOWSER_PIPE_ENTRY;
		} else if (hasOccurenceOfAnyPhrase(words, KEY_UNLOCK_KEYWORDS)) {
			splitConfig.type = SPLIT_TYPE_KEY_DOOR_UNLOCK;
		} else if (hasOccurenceOfAnyPhrase(words, MIPS_CLIP_KEYWORDS)) {
			splitConfig.type = SPLIT_TYPE_MIPS_CLIP;
		}
	};

	// parseSplitterInstructions takes the contents of splitter instructions (within brackets) and adjusts the current split config accordingly.
	Action<dynamic, dynamic, string> parseSplitterInstructions = delegate(dynamic runConfig, dynamic splitConfig, string val) {
		System.Text.RegularExpressions.MatchCollection starCountMatch = STAR_COUNT.Matches(val);
		if (starCountMatch.Count != 0) {
			if (splitConfig.type == SPLIT_TYPE_CASTLE_MOVEMENT) {
				splitConfig.type = SPLIT_TYPE_STAR_GRAB;
			}
			splitConfig.starCountRequirement = Convert.ToInt32(starCountMatch[0].Groups["starCount"].Value);
		}

		System.Text.RegularExpressions.MatchCollection entryMatch = ENTRY.Matches(val);
		if (entryMatch.Count != 0) {
			splitConfig.type = SPLIT_TYPE_STAGE_ENTRY;
			splitConfig.entryStageID = parseStageID(entryMatch[0].Groups["stageID"].Value);
		}

		System.Text.RegularExpressions.MatchCollection exitMatch = EXIT.Matches(val);
		if (exitMatch.Count != 0) {
			splitConfig.type = SPLIT_TYPE_STAGE_EXIT;
			splitConfig.exitStageID = parseStageID(exitMatch[0].Groups["stageID"].Value);
		}

		System.Text.RegularExpressions.MatchCollection starDoorMatch = STAR_DOOR.Matches(val);
		if (starDoorMatch.Count != 0) {
			splitConfig.type = SPLIT_TYPE_STAR_DOOR_ENTRY;
			splitConfig.starDoorID = parseStarDoorID(starDoorMatch[0].Groups["starCount"].Value);
		}

		switch (val) {
		case "fade":
			splitConfig.isForcedFade = true;
			break;

		case "immediate":
			splitConfig.isForcedImmediate = true;
			break;

		case "noreset":
			splitConfig.isNoReset = true;
			break;

		case "manual":
			splitConfig.type = SPLIT_TYPE_MANUAL;
			break;

		case "bowser":
		case "key":
			splitConfig.type = SPLIT_TYPE_KEY_GRAB;
			break;

		case "key-door":
			splitConfig.type = SPLIT_TYPE_KEY_DOOR_UNLOCK;
			break;

		case "pipe":
			splitConfig.type = SPLIT_TYPE_BOWSER_PIPE_ENTRY;
			break;

		case "mips":
			splitConfig.type = SPLIT_TYPE_MIPS_CLIP;
			break;

		case "final-star-grab":
			splitConfig.type = SPLIT_TYPE_FINAL_STAR_GRAB;
			break;
		};
	};

	// parseSplitName configures splitConfig based on information within split name.
	Action<dynamic, string> parseSplitName = delegate(dynamic varsD, string splitName) {
		parseSplitNameForAction(varsD, splitName, parseSplitConfigWords, parseSplitterInstructions);
	};

	// updateRunConditionInner is the inner logic of update based exclusively on varsD (no settings/timer use). Helpful
	// for testing of general behavior.
	Func<dynamic, dynamic, dynamic, bool> updateRunConditionInner = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		// Game version detection needs to be in update for game switching to work properly (before any current/old use).
		varsD.data.runConfig.isJapaneseVersion = (
			vars.settings.forceJPGameVersion ||
			(
				!vars.settings.forceUSGameVersion &&
				currentD.debugFunctionJP == DEBUG_FUNCTION_VALUE
			)
		);

		// LiveSplit.AutoSplitter does not run reset once the last segment has been split (game finished),
		// which prevents from easily starting a new run after finishing the game. This works around it.
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

	int DEBUG_VARS_DUMP_SECONDS = 0;

	// updateRunCondition is run before every loop, we update all the internal data.
	Func<LiveSplitState, dynamic, dynamic, dynamic, dynamic, bool> updateRunCondition = delegate(LiveSplitState timerD, dynamic settingsD, dynamic varsD, dynamic oldD, dynamic currentD) {
		// Copy settings to var to help with testing.
		varsD.settings.isResetEnabled = settingsD.ResetEnabled;
		varsD.settings.currentTimerPhase = timerD.CurrentPhase;
		varsD.settings.currentSplitIndex = timerD.CurrentSplitIndex;
		varsD.settings.splitCount = timerD.Run.Count;
		varsD.settings.forceLaunchOnStart = settingsD[LAUNCH_ON_START];
		varsD.settings.forceJPGameVersion = settingsD[GAME_VERSION_JP];
		varsD.settings.forceUSGameVersion = settingsD[GAME_VERSION_US];
		varsD.settings.disableResetAfterEnd = settingsD[DISABLE_RESET_AFTER_END];
		varsD.settings.disableRTAMode = settingsD[DISABLE_RTA_MODE];
		varsD.settings.disableBowserRedsDelayedSplit = settingsD[DISABLE_BOWSER_REDS_DELAYED_SPLIT];
		varsD.settings.disableAutoStartOnFileD = settingsD[DISABLE_AUTO_START_ON_FILE_D];

		// Whenever current selected split changes, we parse information which decides when to split.
		string currentSplitName = timerD.CurrentSplit != null ? timerD.CurrentSplit.Name.ToLower() : "";
		if (varsD.data.runConfig.lastSplitName != currentSplitName) {
			resetVarsDataForSplitChange(varsD, currentSplitName);
			parseSplitName(varsD, currentSplitName);
		}

		string currentFirstSplitName = timerD.Run.Count != 0 ? timerD.Run[0].Name.ToLower() : "";
		if (varsD.data.runConfig.lastFirstSplitName != currentFirstSplitName) {
			resetVarsDataForFirstSplitChange(varsD, currentFirstSplitName);
			parseRunConfigFromFirstSplit(varsD, currentFirstSplitName);
		}

		// DEBUGGING: Add prints here for debugging. Every DEBUG_VARS_DUMP_SECONDS seconds.
		if (DEBUG_VARS_DUMP_SECONDS != 0 && (varsD.data.updateCounter % (DEBUG_VARS_DUMP_SECONDS * 60)) == 0) {
			print(string.Format("MARIO POSITION: X:{0}, Y:{1}, Z:{2}", getPositionX(varsD, currentD), getPositionY(varsD, currentD), getPositionZ(varsD, currentD)));
			print(varsToString(varsD));
		}

		varsD.data.updateCounter += 1;

		// Call inner update logic.
		return updateRunConditionInner(varsD, oldD, currentD);
	};

	// startRunCondition determines if the timer should be started when it is currently stopped.
	Func<dynamic, dynamic, dynamic, bool> startRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		uint gameRuntime_old = getGameRuntime(varsD, oldD);
		uint gameRuntime_current = getGameRuntime(varsD, currentD);

		uint globalTimer_current = getGlobalTimer(varsD, currentD);

		byte stageIndex_old = getStageIndex(varsD, oldD);
		byte stageIndex_current = getStageIndex(varsD, currentD);

		uint animation_old = getAnimation(varsD, oldD);
		uint animation_current = getAnimation(varsD, currentD);

		uint music_old = getMusicTrack(varsD, oldD);
		uint music_current = getMusicTrack(varsD, currentD);

		byte menuSelectedButtonID_old = getMenuSelectedButtonID(varsD, oldD);
		byte menuSelectedButtonID_current = getMenuSelectedButtonID(varsD, currentD);

		short menuClickPos_current = getMenuClickPos(varsD, currentD);

		// First frame of the logo appears on frame 4 (1.33s after launch).
		if (!varsD.settings.forceLaunchOnStart && globalTimer_current == 4) {
			return true;
		}

		// As soon as game is relaunched if option is selected, quite inconsistent time-wise.
		if (varsD.settings.forceLaunchOnStart && stageIndex_current == 1 && gameRuntime_current < gameRuntime_old) {
			return true;
		}

		// When a file is selected on the main menu, timer also starts.
		if (
			menuSelectedButtonID_old != menuSelectedButtonID_current &&
			menuSelectedButtonID_old == 255 &&
			0 <= menuSelectedButtonID_current && menuSelectedButtonID_current < 4 &&
			(menuSelectedButtonID_current != 3 || !varsD.settings.disableAutoStartOnFileD) &&
			menuClickPos_current == -10000
		) {
			varsD.data.runConfig.selectedFileID = (int) menuSelectedButtonID_current;
			return true;
		}

		// RTA mode, timer starts when we see star select screen, we leave a stage (fade-out) or we touch a door.
		if (
			!varsD.settings.disableRTAMode &&
			varsD.data.runConfig.isRTAMode &&
			(
				isStageFadeOut(stageIndex_old, stageIndex_current) ||
				(
					animation_old != animation_current &&
					animation_current == ACT_UNLOCKING_KEY_DOOR
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

	// onResetRunCondition ensures important variable re-initialization always happens after reset.
	Action<dynamic> onResetRunCondition = delegate(dynamic varsD) {
		varsD.data.runLiveData = initRunLiveData();
	};

	// resetRunCondition determines if run should be reset, stopping the timer and resetting it to its initial value.
	Func<dynamic, dynamic, dynamic, bool> resetRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		uint gameRuntime_old = getGameRuntime(varsD, oldD);
		uint gameRuntime_current = getGameRuntime(varsD, currentD);

		byte stageIndex_current = getStageIndex(varsD, currentD);

		ushort starCount_old = getStarCount(varsD, oldD);
		ushort starCount_current = getStarCount(varsD, currentD);

		bool isResetGame = (
			stageIndex_current == 1 &&
			gameRuntime_current < gameRuntime_old
		);

		if (isResetGame && !varsD.data.runLiveData.wantToReset) {
			varsD.data.runLiveData.wantToReset = true;
			varsD.data.runLiveData.wantToResetTiming = gameRuntime_old;
		}

		bool isResetRTA = (
			!vars.settings.disableRTAMode &&
			varsD.data.runConfig.isRTAMode &&
			starCount_current < starCount_old
		);

		bool isReset = isResetRTA;

		if (varsD.data.runLiveData.wantToReset && startRunCondition(varsD, oldD, currentD)) {
			bool isNoReset = (
				varsD.data.splitConfig.isNoReset ||
				getFileAFlags(varsD, currentD) != 0
			);

			// When split is marked as no reset, reset conditions are ignored, unless a reset happens twice within
			// NO_RESET_SECONDS_LEEWAY number of seconds (when greater than 0). In this case reset does happen.
			if (isNoReset && (NO_RESET_SECONDS_LEEWAY == 0 || (NO_RESET_SECONDS_LEEWAY * 60) < vars.data.runLiveData.wantToResetTiming)) {
				vars.data.runLiveData.wantToReset = false;
				vars.data.runLiveData.wantToResetTiming = 0;
			} else {
				isReset = true;
			}
		}

		if (isReset) {
			onResetRunCondition(varsD);
			return true;
		}

		return false;
	};

	// onSplitRunCondition ensures important variable re-initialization always happens after split.
	Action<dynamic> onSplitRunCondition = delegate(dynamic varsD) {
		varsD.data.splitConditions = initSplitConditionsData();
	};

	// splitRunCondition determines whether split should happen for current segment.
	Func<dynamic, dynamic, dynamic, bool> splitRunCondition = delegate(dynamic varsD, dynamic oldD, dynamic currentD) {
		// Split configuration and conditions copy to avoid duplication.
		dynamic splitConfig = varsD.data.splitConfig;
		dynamic splitConditions = varsD.data.splitConditions;
		dynamic runConfig = varsD.data.runConfig;

		// Manual splits are fully managed by the runner.
		if (splitConfig.type == SPLIT_TYPE_MANUAL) {
			return false;
		}

		Action<bool> addLevelChangeSplittingCondition = (condition) => {
			splitConditions.isSplittingOnFade = splitConditions.isSplittingOnFade || condition;
		};

		Action<bool> addImmediateSplittingCondition = (condition) => {
			splitConditions.isSplittingImmediately = splitConditions.isSplittingImmediately || condition;
		};

		// Getting all of the data based on the right ROM region.
		byte stageIndex_old = getStageIndex(varsD, oldD);
		byte stageIndex_current = getStageIndex(varsD, currentD);

		uint animation_old = getAnimation(varsD, oldD);
		uint animation_current = getAnimation(varsD, currentD);

		uint fileKeysFlag_old = getFileFlags(varsD, oldD) & KEY_FLAGS;
		uint fileKeysFlag_current = getFileFlags(varsD, currentD) & KEY_FLAGS;

		ushort nonStopInteractionOverwrite = getNonStopInteractionOverwrite(varsD, currentD);

		bool isNonStopModeEnabled = (
			nonStopInteractionOverwrite == NON_STOP_OVERWRITE_VALUE_USAMUNE ||
			nonStopInteractionOverwrite == NON_STOP_OVERWRITE_VALUE_GAMESHARK
		);

		ushort starCount_old = getStarCount(varsD, oldD);
		ushort starCount_current = getStarCount(varsD, currentD);

		ushort hudCameraMode_old = getHUDCameraMode(varsD, oldD);
		ushort hudCameraMode_current = getHUDCameraMode(varsD, currentD);

		byte warpDestination_current = getWarpDestination(varsD, currentD);

		bool isInCastle = CASTLE_STAGE_INDEXES[stageIndex_current];
		bool isInBowserStage = BITX_STAGE_INDEXES[stageIndex_current];
		bool isInStage = STAGE_INDEXES[stageIndex_current];
		bool isInBowserFightStage = BOWSER_FIGHT_STAGE_INDEXES[stageIndex_current];

		bool isNoExitStarGrabSplitDelayed = (
			splitConfig.isForcedFade ||
			isInCastle ||
			(isInBowserStage && !varsD.settings.disableBowserRedsDelayedSplit)
		);

		bool optionalStarRequirementDone = (
			splitConfig.starCountRequirement == -1 ||
			starCount_current == splitConfig.starCountRequirement
		);

		// For the purpose of castle movement, we don't split on re-entering the same stage.
		bool isSameStageEntry = varsD.data.runLiveData.previousStage == stageIndex_current;

		// When getting the required number of stars in a non-bowser stage, we split on fadeout. If we are getting a star
		// that does not fadeout (but star count is correct), we split immediately, unless we are in castle where we split
		// on fade in (eg. toad star).
		bool isStarGrabConditionMet = (
			splitConfig.type == SPLIT_TYPE_STAR_GRAB &&
			animation_old != animation_current &&
			starCount_current == splitConfig.starCountRequirement
		);

		addLevelChangeSplittingCondition(
			isStarGrabConditionMet &&
			(
				animation_current == ACT_STAR_DANCE_EXIT ||
				animation_current == ACT_STAR_DANCE_WATER ||
				(
					animation_current == ACT_STAR_DANCE_NO_EXIT &&
					isNoExitStarGrabSplitDelayed
				)
			)
		);

		addImmediateSplittingCondition(
			isStarGrabConditionMet && (
				(
					splitConfig.isForcedImmediate && (
						animation_current == ACT_STAR_DANCE_EXIT ||
						animation_current == ACT_STAR_DANCE_WATER ||
						animation_current == ACT_STAR_DANCE_NO_EXIT
					)
				) || (
					animation_current == ACT_STAR_DANCE_NO_EXIT &&
					!isNoExitStarGrabSplitDelayed
				)
			)
		);

		// When non-stop cheat code are enabled, we split slightly differently than normal. The "normal" splitting condition
		// is on exit stage unless immediate split is added in which case the split happens immediately when the star is grabbed.
		addLevelChangeSplittingCondition(
			splitConfig.type == SPLIT_TYPE_STAR_GRAB &&
			isNonStopModeEnabled &&
			starCount_old != starCount_current &&
			starCount_current == splitConfig.starCountRequirement
		);

		// When we get a star grab animation in a bowser fight stage, we got the key.
		addLevelChangeSplittingCondition(
			splitConfig.type == SPLIT_TYPE_KEY_GRAB &&
			animation_old != animation_current &&
			(
				animation_current == ACT_STAR_DANCE_EXIT ||
				animation_current == ACT_JUMBO_STAR_CUTSCENE
			 ) &&
			isInBowserFightStage &&
			optionalStarRequirementDone
		);

		addLevelChangeSplittingCondition(
			splitConfig.type == SPLIT_TYPE_KEY_GRAB &&
			isNonStopModeEnabled &&
			fileKeysFlag_old != fileKeysFlag_current &&
			optionalStarRequirementDone
		);

		// This is the last split and we are getting the last star, split immediately.
		addImmediateSplittingCondition(
			(
				splitConfig.type == SPLIT_TYPE_FINAL_STAR_GRAB ||
				varsD.settings.currentSplitIndex == varsD.settings.splitCount - 1
			) &&
			animation_old != animation_current &&
			animation_current == ACT_JUMBO_STAR_CUTSCENE
		);

		// When we are doing castle movement split and we enter a stage.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_CASTLE_MOVEMENT &&
			isStageFadeIn(stageIndex_old, stageIndex_current) &&
			!isSameStageEntry
		);

		// When this is a key door split, we split as soon as door touch animation happens.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_KEY_DOOR_UNLOCK &&
			animation_old != animation_current &&
			animation_current == ACT_UNLOCKING_KEY_DOOR &&
			optionalStarRequirementDone
		);

		// Pipe split happens on fade-out entering the bowser fight level.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_BOWSER_PIPE_ENTRY &&
			isStageFadeOut(stageIndex_old, stageIndex_current) &&
			isInBowserFightStage &&
			optionalStarRequirementDone
		);

		// Specific level entry split happens.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_STAGE_ENTRY &&
			stageIndex_old != stageIndex_current &&
			stageIndex_current == splitConfig.entryStageID &&
			optionalStarRequirementDone
		);

		// Specific level exit split happens.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_STAGE_EXIT &&
			stageIndex_old != stageIndex_current &&
			stageIndex_old == splitConfig.exitStageID &&
			optionalStarRequirementDone
		);

		// MIPS clip is split on XCAM entering DDD by convention, detect this here.
		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_MIPS_CLIP &&
			hudCameraMode_old != hudCameraMode_current &&
			(
				hudCameraMode_current == FIXED_CAMERA_HUD ||
				hudCameraMode_current == FIXED_CAMERA_CDOWN_HUD
			) &&
			warpDestination_current == DDD_STAGE_INDEX
		);

		// Star door interaction splits when entering sliding star door.
		dynamic doorBox = null;

		if (splitConfig.starDoorID == 8) {
			doorBox = STAR_DOOR_8_POSITION;
		} else if (splitConfig.starDoorID == 30) {
			doorBox = STAR_DOOR_30_POSITION;
		} else if (splitConfig.starDoorID == 50) {
			doorBox = STAR_DOOR_50_POSITION;
		} else if (splitConfig.starDoorID == 70) {
			doorBox = STAR_DOOR_70_POSITION;
		}

		addImmediateSplittingCondition(
			splitConfig.type == SPLIT_TYPE_STAR_DOOR_ENTRY &&
			animation_old != animation_current &&
			animation_current == ACT_ENTERING_STAR_DOOR &&
			doorBox != null &&
			isIn3DBox(varsD, currentD, doorBox) &&
			optionalStarRequirementDone
		);

		// Save stage id of last stage that was entered for castle movement condition.
		if (isInStage) {
			varsD.data.runLiveData.previousStage = stageIndex_current;
		}

		bool readyToSplitImmediately = (
			(splitConditions.isSplittingImmediately && !splitConfig.isForcedFade) ||
			(splitConditions.isSplittingOnFade && splitConfig.isForcedImmediate)
		);

		bool readyToSplitOnFade = (
			(splitConditions.isSplittingImmediately && splitConfig.isForcedFade) ||
			(splitConditions.isSplittingOnFade)
		);

		// Return the result of splitting conditions check, vars are reset in onSplit to avoid duplicate splitting.
		return (
			(readyToSplitImmediately) ||
			(readyToSplitOnFade && !runConfig.relaxedFadeMatch && (isStageFadeIn(stageIndex_old, stageIndex_current) || isStageFadeOut(stageIndex_old, stageIndex_current))) ||
			(readyToSplitOnFade && runConfig.relaxedFadeMatch && stageIndex_old != stageIndex_current)
		);
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

	Func<bool, uint, uint, byte, uint, ushort, uint, dynamic> mockStateBuilder = delegate(bool isJP, uint gameRuntime, uint globalTimer, byte stageIndex, uint animation, ushort starCount, uint music) {
		dynamic state = new ExpandoObject();

		uint defaultDebugFunctionValue = 0xf1f1f1f1;
		state.debugFunctionJP = isJP ? DEBUG_FUNCTION_VALUE : defaultDebugFunctionValue;
		state.debugFunctionUS = isJP ? defaultDebugFunctionValue : DEBUG_FUNCTION_VALUE;

		uint defaultGameRuntime = 0xf2f2f2f2;
		state.gameRunTimeJP = isJP ? gameRuntime : defaultGameRuntime;
		state.gameRunTimeUS = isJP ? defaultGameRuntime : gameRuntime;

		uint defaultGlobalTimer = 0xf3f3f3f3;
		state.globalTimerJP = isJP ? globalTimer : defaultGlobalTimer;
		state.globalTimerUS = isJP ? defaultGlobalTimer : globalTimer;

		byte defaultStageIndex = 0xf4;
		state.stageIndexJP = isJP ? stageIndex : defaultStageIndex;
		state.stageIndexUS = isJP ? defaultStageIndex : stageIndex;

		uint defaultAnimation = 0xf5f5f5f5;
		state.animationJP = isJP ? animation : defaultAnimation;
		state.animationUS = isJP ? defaultAnimation : animation;

		ushort defaultStarCount = 0xf6f6;
		state.starCountJP = isJP ? starCount : defaultStarCount;
		state.starCountUS = isJP ? defaultStarCount : starCount;

		uint defaultMusic = 0xf7f7f7f7;
		state.musicJP = isJP ? music : defaultMusic;
		state.musicUS = isJP ? defaultMusic : music;

		ushort defaultNonStopValue = 0xf8f8;
		state.nonStopInteractionOverwriteJP = /* isJP ? nonStopValue : */ defaultNonStopValue;
		state.nonStopInteractionOverwriteUS = /* isJP ? */ defaultNonStopValue /* : nonStopValue */;

		byte defaultMenuSelectedButtonID = 0xf9;
		state.menuSelectedButtonIDJP = defaultMenuSelectedButtonID;
		state.menuSelectedButtonIDUS = defaultMenuSelectedButtonID;

		short defaultMenuClickPos = 0xfa;
		state.menuClickPosJP = defaultMenuClickPos;
		state.menuClickPosUS = defaultMenuClickPos;

		uint defaultFileAMagic = 0x00000000;
		state.fileAFlagsJP = defaultFileAMagic;
		state.fileAFlagsUS = defaultFileAMagic;

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

		varsD.data.runConfig.previousStage = 10;

		bool isReset = resetRunCondition(varsD, oldD, currentD);
		assertCondition(isJP, isReset, "testResetWhenGameRestarted: reset returned false");
		assertCondition(isJP, varsD.data.runConfig.previousStage == 0, "testResetWhenGameRestarted: previous stage was not reset to 0");
	};

	// FIXME: does not work anymore with delayed split.
	// testResetWhenGameRestarted(true);
	// testResetWhenGameRestarted(false);

	Action<bool> testResetWhenRTAModeAndStarsReduction = delegate(bool isJP) {
		dynamic varsD = mockVarsBuilder();
		varsD.data.runConfig.isRTAMode = true;

		dynamic oldD = mockStateBuilder(isJP, 0, 0, 1, 0, 60, 0);
		dynamic currentD = mockStateBuilder(isJP, 1, 0, 1, 0, 58, 0);

		bool isUpdate = updateRunConditionInner(varsD, oldD, currentD);
		assertCondition(isJP, isUpdate, "testResetWhenRTAModeAndStarsReduction: update returned false");

		varsD.data.runConfig.previousStage = 10;

		bool isReset = resetRunCondition(varsD, oldD, currentD);
		assertCondition(isJP, isReset, "testResetWhenRTAModeAndStarsReduction: reset returned false");
		assertCondition(isJP, varsD.data.runConfig.previousStage == 0, "testResetWhenRTAModeAndStarsReduction: previous stage was not reset to 0");
	};

	// FIXME: Does not pass anymore.
	// testResetWhenRTAModeAndStarsReduction(true);
	// testResetWhenRTAModeAndStarsReduction(false);

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
	vars.functions.onSplitRunCondition = onSplitRunCondition;
	vars.functions.splitRunCondition = splitRunCondition;
	vars.functions.updateRunCondition = updateRunCondition;

	// Configure settings for this splitter now that we know it works.
	settings.Add("expertMode", false, "MANUAL/EXPERT MODE (I know what I'm doing)");

	settings.Add("generalSettings", true, "General Settings", "expertMode");
	settings.Add(LAUNCH_ON_START, false, "Start on game launch instead of logo first frame (logo is more consistent, at 1.33s offset)", "generalSettings");
	settings.Add(DISABLE_AUTO_START_ON_FILE_D, false, "Disable automatic start start on file D select.", "generalSettings");
	settings.Add(DISABLE_RESET_AFTER_END, false, "Disable timer reset after game end (final star grab)", "generalSettings");
	settings.Add(DISABLE_RTA_MODE, false, "Disable stage RTA mode.", "generalSettings");
	settings.Add(DISABLE_BOWSER_REDS_DELAYED_SPLIT, false, "Disable bowser reds delayed split (default: split on pipe entry)", "generalSettings");

	settings.Add("gameVersion", false, "Force Game Region (defaults to automatic detection, only use if detection fails)", "expertMode");
	settings.Add(GAME_VERSION_JP, false, "JP: I am using a Japanese region ROM", "gameVersion");
	settings.Add(GAME_VERSION_US, false, "US: I am using a United States region ROM", "gameVersion");
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

onSplit {
	vars.functions.onSplitRunCondition(vars);
}

update {
	return vars.functions.updateRunCondition(timer, settings, vars, old, current);
}
