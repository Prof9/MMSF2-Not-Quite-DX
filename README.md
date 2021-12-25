# Mega Man Star Force 2 Not Quite DX

This repository holds the source code for Mega Man Star Force 2 Not Quite DX.

**Looking for the download link? Grab the patch from [The Rockman EXE Zone](https://forums.therockmanexezone.com/mega-man-star-force-2-not-quite-dx-t16660.html)!**

## Reporting Bugs

Please report any bugs and suggestions in the project topic on The Rockman EXE
Zone Forums:

[https://forums.therockmanexezone.com/mega-man-star-force-2-not-quite-dx-t16660.html](https://forums.therockmanexezone.com/mega-man-star-force-2-not-quite-dx-t16660.html)

## Credits

 *  **[Prof. 9](https://twitter.com/Prof9)** - Planning, Programming

## Setup

Place the following ROM files in the `_rom` folder. See `_rom\roms_go_here.txt`
for details.

* Mega Man Star Force 2: Zerker x Saurian - US version
* Mega Man Star Force 2: Zerker x Ninja - US version

Place the required third-party tools in the `_tools` folder. See
`_tools\tools_go_here.txt` for details.

 *  **[armips](https://github.com/Kingcom/armips/)** by Kingcom. 
    [v0.11.0-g4616b00](https://github.com/Kingcom/armips/tree/4616b009959a8675eb2c9af66470b30c4083dffb)
    is used, but any newer version should also work. (v0.11.0 stable does NOT
    work.)
 *  **[Nintendo DS/GBA Compressors](https://www.romhacking.net/utilities/826/)**
    by CUE. Version 1.4 is used, but any newer version should also work.
 *  **ndstool** from devkitPro. Version 2.0.1 is used, but any newer version
    should also work.

Compatible versions of [TextPet](https://github.com/Prof9/TextPet)
and [SFArcTool](https://github.com/Prof9/SFArcTool) are included.

You may also want to use [BNSpriteEditor](https://github.com/brianuuu/BNSpriteEditor)
by brianuuu to modify `.spr.bin` files.

## Building

Building is only supported on Windows 10 and up.

Run the following command:

```
make <target>
```

Where `<target>` is `zxs-us` or `zxn-us` for Zerker x Saurian or Zerker x Ninja
respectively.

This will produce the following files:

* `<target>-out.nds` - Actual MMSF2 Not Quite DX ROM.
* `<target>-out.tpl` - Text dump (TextPet format).
* `<target>-out.txt` - Text dump (plain text)

## Legal

This project is not endorsed by or affiliated with Capcom in any way. Mega Man
and Mega Man Star Force are registered trademarks of Capcom. All rights belong
to their respective owners.
