# flutter_loc

![Pub Version](https://img.shields.io/pub/v/flutter_loc) ![Publisher](https://img.shields.io/pub/publisher/flutter_loc) ![Pub Points](https://img.shields.io/pub/points/flutter_loc) ![License](https://img.shields.io/github/license/micazi/flutter_loc)

**`flutter_loc`** is a powerful localization tool for Flutter, streamlining multilingual support with automated parsing of hard-coded strings and providing quick replacement techniques for convenience.

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Developer Experience](#developer-experience)
5. [Features / Requests](#features-and-requests)
6. [Powered by darted_cli](#powered-by-darted_cli)
7. [License](#license)

---

## Features

- **Automated Localization Parsing**: Automatically parse hard-coded strings for streamlined workflow.
- **JSON Handling**: Effortlessly generate JSON-based localization data.
- **File Integration**: Seamlessly integrate localization files into your Flutter project.
- **Multilingual Support**: Simplifies adding and managing multiple languages in your app.
- **Interactive CLI**: Provides user-friendly prompts for efficient localization management.
- **Cross-Platform Support**: Fully compatible with Windows, macOS, and Linux.

---

## Installation

1. Activate the package globally via Dart's pub tool:

```bash
dart pub global activate flutter_loc
```

Once activated, you can use the `flutter_loc` command directly in your terminal.

## Usage

#### 1. Generate Localization Files

Extract hard-coded strings in your working directory with a single command:

```bash
flutter_loc extract -d /your/working/directory
```

This will extract all of the caught hard-coded strings in all of the dart files in that directory, and dump them into a special `flutter_loc.txt` file.

#### 2. Work with the `flutter_loc.txt` file

You will find a txt file generated similar to this:

```txt
##PATH-START{file://D:\path\to\test.dart}##
#----------#
##MATCH-LINE{28}##
(17) 'Hard-coded string 1' ===> "" !;;!


##MATCH-LINE{126}##
(29) "Hard-coded string 2 with double quotes" ===> "" !;;!


##MATCH-LINE{126}##
(29) "some line with two strings, this is the first" ===> "" !;;!
(65) "And this is the second" ===> "" !;;!


##MATCH-LINE{152}##
(28) """ Triple-quotes
Multiline
hard-coded strings
""" ===> "" !;;!


##MATCH-LINE{154}##
(32) "Some string with $variable" ===> "" !;;!


##MATCH-LINE{154}##
(32) "Some other with ${encodedvariable? 'and inner quotes': 'other inner quotes'}" ===> "" !;;!
#----------#
##PATH-END##
```

All you have to do? Give each hard-coded string a key. Easy!

```txt
##PATH-START{file://D:\path\to\test.dart}##
#----------#
##MATCH-LINE{28}##
(17) 'Hard-coded string 1' ===> "str1_key" !;;!


##MATCH-LINE{126}##
(29) "some line with two strings, this is the first" ===> "str3_key" !;;!
(65) "And this is the second" ===> "str4_key" !;;!


##MATCH-LINE{152}##
(28) """ Triple-quotes
Multiline
hard-coded strings
""" ===> "long_text_key" !;;!


##MATCH-LINE{154}##
(32) "Some string with $variable" ===> "key_of_var" !;;!

...
#----------#
##PATH-END##
```

#### 3. Replace the cought hard-coded strings with the newly created keys, and generate a JSON file with them.

Run the replace command to update your files and create JSON files for supported languages:

```bash
flutter_loc replace -p path/to/flutter_loc.txt -l en,ar,es
```

And this would conveniently:

1. Replace the text in the original file with your set key (It will ignore the ones you left empty in the `flutter_loc` file).
2. Create JSON files for the supported languages you specified (using the -l argument, e.g. `-l en,ar,es`).
3. Populate these files with a JSON map of the keys you supplied, and the values (the original text if it's the main language, an empty string if not).
4. And that's it! Get your original language file and translate it to as many as you want!

```json
{
  "str1_key": "Hard-coded string 1",
  "long_text_key": "Triple-quotes\nMultiline\nhard-coded strings",
  "key_of_var": "Some string with variable"
}
```

## Developer Experience

flutter_loc is built with developers in mind, providing:

- **Simplified Localization**: Automates the tedious aspects of managing translations.
- **Scalability**: Easily add and manage new languages as your app grows.
- **Error-Free Workflow**: Ensures consistent localization files across your project.

## Features and Requests

- [x] Automatic key extraction from Dart code.
- [x] JSON-based localization file support.
- [ ] Support for variables extraction and substitution.
- [ ] ARB & YAML support for localization.
- [ ] Automatic translation of the hard-coded strings using one of the translation methods.
- [ ] You tell me!

**Feature Suggestions & Bug Reports**
Found a bug or have an idea for an enhancement? Feel free to open an issue on [GitHub](https://github.com/micazi/flutter_loc/issues).

## Powered by darted_cli

**flutter_loc** is built on top of the robust and flexible `darted_cli` framework.
`darted_cli` makes it easy to create structured, feature-rich command-line interfaces in Dart with minimal effort.

**Why darted_cli?**

- Provides a strong foundation for parsing commands, arguments, and flags.
- Simplifies CLI development with tools like interactive prompts, formatted console outputs, and custom error handling.
- Focused on developer experience, ensuring easy scalability and customization.

Explore [darted_cli](https://pub.dev/packages/darted_cli) to learn how you can build your own powerful CLI tools with Dart!

## License

Licensed under the MIT License. You are free to use, modify, and distribute this package.
