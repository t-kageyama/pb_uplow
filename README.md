# pb_uplow
====

Overview

## Version
0.0.1

## Description
Tiny program to do toLower, toUpper on Mac OSX's Pasteboard.

## Requirement
* Mac OSX 10.14
* Xcode 10.2.1
* Automator

## Usage
* copy objc/printpb directory into your Mac.
* Build printpb project with your Xcode.
* Copy built executable binary of printpb project to your directly.
* Copy automator/toLower.workflow, automator/toUpper.workflow into your ?Users/__YOUR_USER_ID__/Library/Services/ directory.
* Open toLower.workflow and toUpper.workflow with Automator.app and replace __\_\_YOUR_PRINT_PB_ABS_PATH\_\___ with your printpb executable binary's fullpath.
* Assign keyboard short cut to above Automator workflow with Preference.app's Keyboard -> Short cut -> Srvice.
* For example, I use Command+Shift+L for make lower case, Command+Shift+U for make upper case.
* Copy some strings into your Mac's pasteboard and hit short cut which you assigned at above step.
* Then, past string from pasteboard to your favorite editor application.
* Enjoy!

## Licence

[MIT](https://github.com/t-kageyama/pb_uplow/blob/master/LICENSE)

## Author

[t-kageyama](https://github.com/t-kageyama)
