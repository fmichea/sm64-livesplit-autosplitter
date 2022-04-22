sm64-livesplit-autosplitter.asl - Super Mario 64 Livesplit Auto-Splitter
========================================================================

This is my personal autosplitter for livesplit to be used with Project64 1.6 for Super Mario 64.

It is heavily (**heavily**) inspired by a few other auto-splitters, however these did not quite do it for me[*](#footnotes), so I decided
to write my own. Still this would not exist without them, so please check them out:

- https://github.com/ColinT/banana-split
- https://github.com/andysandford/sm64-livesplit-autosplitter
- https://github.com/aglab2/LiveSplitAutoSplitters

You are welcome to try this splitter as well, it has worked well for me so far, however there might be bugs that slipped in.
If you report those, I will try to address them. I also welcome feature requests if you have any.

Here is a list of features of this auto splitter:
 
- **Zero Configuration**: all splitting defaults should be sane for the customs that SM64 community uses. Shouldn't need to configure anything.
- **Automatic ROM Version Detection**: the script detects which version is loaded in PJ64 memory automatically.
   - Supports both US and JP game versions.
   - Game ROM version can be switched at any time. No LiveSplit restart required.
   - Setting version in configuration is not required (and even discouraged).
- **Automatic Split Configuration**: the script uses the name of the splits for automatic detection. See Split Name Format, it
	follows the community convention for splitting the game.
- **RTA Mode**: automated RTA resetting/splitting to be used with usamune ROM.
- **Miscellaneous Features/Fixes**:
    - Resetting after game end resets timer correctly by default.

# Installation

## Stable Version

- Go to the releases here: https://github.com/fmichea/sm64-livesplit-autosplitter/releases and download the ASL
  file attached to latest release.
- Open ``Livesplit``, select your SM64 layout, right click -> ``Edit Layout``.
- If not already present, click ``"+"`` button, ``"Control"`` and add ``"Scriptable Auto Splitter"``.
- Click ``"Layout Settings"`` and find ``"Scriptable Auto Splitter"`` tab.
- Under ``Script Path`` select the ASL script.
- You should now see settings in the box: **DO NOT CHANGE ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING**.
- ``Save`` and done.

![Settings](./images/settings.jpg)

## Development Version

- Download the ASL script directly from main here: https://raw.githubusercontent.com/fmichea/sm64-livesplit-autosplitter/main/sm64-livesplit-autosplitter.asl
- Install using the same process as stable version.

Please note that development version may contain bugs.

# Split Name Format

There are a few types of splits that can be defined, here are some examples:

- Star requirement split (stage, single star): when grabbing a certain number of stars. These split depending on a
  few conditions.
    - ``HMC (15)``
    - ``Mips + SSL [24]``
- Bowser stage splits: split when entering the pipe at the end of Dark World, Fire Sea or Sky.
    - ``Dark World Pipe``
- Bowser fight splits: split on bowser only after the key has been grabbed.
    - ``Bowser 3``
    - ``Key 1 (9)``
- Door unlock split: split when touching either the basement door or the upstairs door.
    - ``Upstairs [74]``
    - ``Basement (26)``
- Castle movement split: when measuring time between two stages
    - ``Lakitu Skip``
    - ``Mips`` (special, splits on XCAM)
- Door interaction splits: split happens after a certain number of door interactions, more on this later.
- Stage entry and exit splits: split happens when entering or exit a specific stage.

A few modifiers are also available and will be explained in the more advanced format below.

## Main Format and Keywords

### Star Requirement Split

This splits after a certain number of stars has been collected. To specify a number of stars, add "\[10\]" or "(10)" somewhere in the split name.

The splitting moment depends on a few conditions. Once the correct number of stars has been grabbed:

- If the star grab animation with stage exit is happening, the split will happen on fadeout.
- If the star grab animation does not exit stage (100 coins star), the split happens immediately. Exception: For bowser reds, split happens
  on pipe entry by default (settings can change this).
- If the star is grabbed in the castle, not a stage, the split happens when entering the next stage (fade in).

The timing for splitting can be overridden by the following modifiers. If a split uses both one of the following
modifiers, and a star count condition, then star count condition must be fulfilled at the time the splitting
condition happens.

### Bowser Fight Split

To be considered a bowser split, the split name must contain ``bowser`` or ``key``. It will split on bowser key grab fadeout.

### Bowser Stage Split

To be considered a bowser stage split, the split name must contain ``pipe``. It will split on pipe entry fadeout.

### Castle Movement Split

If split is not in any other category, it is a castle movement split, which means it splits on next level entry. The previous level exited does
not count, which allows re-entering it to EXIT COURSE back to castle lobby.

## Advanced Format

### Key Door Unlock Split

To be considered a key door split, the split name must contain either ``basement`` or ``upstairs`` in its name. It will split on
the key door unlock animation. If the door is already unlocked, it will not split.

### Star Door Entry Split

To be considered a star door entry split, it must contain the following splitter instruction: ``[star-door=70]``. Acceptable star
doors are 8, 30, 50 and 70. It will split when the door is being entered. Can be used to split the two BLJs separately in 16 star
for example.

### Stage Entry and Exit

This forces the split to happen when entering or exiting a specific stage. The syntax is ``[entry=bob]`` or ``[exit=36]``. All
vanilla stages have a shortcut ([here](#stage-name-shortcuts)) but numbers are allowed for both instructions in order to
support ROM Hacks.

### Miscellaneous

- For standard star count requirement splits, it is possible to change the default splitting time using ``[fade]`` or ``[immediate]``.
- It is possible to prevent emulator reset from resetting run on specific split using ``[noreset]``. If reset happens twice in a row
  within 5 seconds then the reset does happen (force timer reset).
- If a split is marked with ``[manual]`` then you are responsible for splitting.
- **Importantly**: all instructions can be merged into one block comma separated, eg. ``[26,immediate,noreset]``

## Examples

![70 Star](./images/70_star.jpg)

- "WF (9)" would split on stage exit at 9 stars.
- "THI + Toad (43)", toad is grabbed after the stage, split happens on TTM entry.

![16 Star](./images/16_star.jpg)

- "Mips Clip" is a castle movement split and splits on stage entry to DDD.
- "BLJs" splits movement from FS to Sky. Note that it is fine to re-enter FS to exit to lobby.
	This is the only stage that can be re-entered without splitting.

### Advanced Info

Within the ASL script, there is a section called ``USER_CUSTOMIZATION_BEGIN``, in which you can customize all
of the keywords for bowser fight, bowser stage and key unlock if the default ones do not fit your needs. Remember
to port these changes every time you upgrade the script.

RTA Mode
--------

RTA mode is enabled when "RTA" is present in the category name for the splits. It adds reset and start conditions, with usamune ROM in mind.

Reset: If star count decreases, the timer is reset.

Additional start conditions:

- Star select screen is displayed (either through painting entry or usamune ROM menu)
- Stage is exited (fade-out)
- A key door is touched.
	
Splitting conditions (incl. last split) are identical.

## Examples (with Usamune ROM Interaction)

### Segment RTA (Stage EXIT)

![16 Star - HMC exit to end](./images/segment_rta_exit.jpg)

This relies heavily on Usamune providing the right configuration for this segment. In this case, we are doing RTA from HMC exit
to end of the game.

To reset:

- Enter HMC stage.
- Under "MENU > DATA > For 16 Star" select "15". To reset your splits, flip between "9" and "15".
- Do a quick star in HMC to exit stage, timer will start on exit.

### Segment RTA (Door)

![70 Star - Upstairs RTA](./images/segment_rta_door.jpg)

Like previously, Usamune ROM needs to provide configuration you need. In this case we will do 70 upstairs RTA from door touch.

To reset:

- Exit to lobby.
- Under "MENU > DATA > For 70 Star" select "34". To reset your splits, flip between "OFF" and "34".
- Touch the upstairs door, timer will star with door unlocking animation.

### Single Stage RTA

![WF 70/120 Stage RTA](./images/stage_rta.jpg)

In the single stage RTA case, star count requirements should be starting from 0 stars. Usamune interaction looks like this:

Once in a while:

- Under "MENU > STAGE > STARTXT", select "1 Star", press A, increase CNT to 255 (each digit can be increased independently) and
  press A again. This removes the textboxes when certain number of stars are collected. Otherwise too hard to manage correctly.

To reset:

- If painting entry is desired, get in position. Otherwise usamune ROM stage select can be used.
- Under "MENU > DATA > For 0 Star", flip between OFF and DWEND. DWEND should be selected at the start of stage RTA. This resets all stars in stage.
- Enter painting or select stage in menu, this will start the timer.

# Additional Notes

## Footnotes:

* Among the issues I ran into in various other auto-splitters:
  - Too much configuration. Needs to be configured for each split file (category) differently.
  - Does not support castle movement splits.
  - Only supports one game version (only US, only JP).
  - Issues with split undo not being possible, eg. on final star last split.
  - Misses (reset, ...) due to refresh rate.
  - Generally liked some features of each one, but couldn't quite use any 100%.

## Split Names Shortcuts

For entry and exit splits, here are all of the shortcuts that can be used to refer to the different stages in vanilla:

| Full Stage Name             | Shortcut  |
|-----------------------------|-----------|
| Aquarium                    | ``aqua``  |
| Big Boo's Haunt             | ``bbh``   |
| Bob-Omb Battlefield         | ``bob``   |
| Bowser 1                    | ``bow1``  |
| Bowser 2                    | ``bow2``  |
| Bowser 3                    | ``bow3``  |
| Bowser in the Dark World    | ``dw``    |
| Bowser in the Fire Sea      | ``fs``    |
| Bowser in the Sky           | ``sky``   |
| Cavern of the Metal Cap     | ``cotmc`` |
| Cool Cool Mountain          | ``ccm``   |
| Dire, Dire Docks            | ``ddd``   |
| Hazy Maze Cave              | ``hmc``   |
| Jolly Roger Bay             | ``jrb``   |
| Lethal Lava Land            | ``lll``   |
| Rainbow Ride                | ``rr``    |
| Shifting Sand Land          | ``ssl``   |
| Snowman's Land              | ``sl``    |
| Tall, Tall Mountain         | ``ttm``   |
| The Princess's Secret Slide | ``pss``   |
| Tick Tock Clock             | ``ttc``   |
| Tiny Huge Island            | ``thi``   |
| Tower of the Wing Cap       | ``totwc`` |
| Vanish Cap Under the Moat   | ``vcutm`` |
| Wet Dry World               | ``wdw``   |
| Whomp's Fortress            | ``wf``    |
| Wing Mario Over the Rainbow | ``wmotr`` |
