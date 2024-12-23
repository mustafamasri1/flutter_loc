# Example Usage of `flutter_loc`

This guide will walk you through using `flutter_loc` to streamline localization in your Flutter project. Follow these steps to extract, replace, and manage hard-coded strings in your app.

---

## 1. Install the Package

To use `flutter_loc`, you need to install it globally using Dart's pub tool:

```bash
dart pub global activate flutter_loc
```

This command makes `flutter_loc` available in your terminal.

---

## 2. Extract Hard-Coded Strings

Run the following command to extract all hard-coded strings from your Flutter project:

```bash
flutter_loc extract -d /path/to/your/project
```

### Example:

If your project is located in `/Users/username/projects/my_flutter_app`, use:

```bash
flutter_loc extract -d /Users/username/projects/my_flutter_app
```

This will generate a file named `flutter_loc.txt` in the working directory containing all the hard-coded strings found in your project files.

---

## 3. Review and Edit the `flutter_loc.txt` File

Open the generated `flutter_loc.txt` file. It contains all the extracted strings with placeholders for keys. Assign a unique key to each string.

### Example `flutter_loc.txt` File:

```txt
##PATH-START{file://Users/username/projects/my_flutter_app/lib/main.dart}##
#----------#
##MATCH-LINE{12}##
(5) 'Welcome to MyApp!' ===> "welcome_message" !;;!

##MATCH-LINE{20}##
(10) "Click here to continue" ===> "click_continue" !;;!
#----------#
##PATH-END##
```

Replace `""` with meaningful keys like `"welcome_message"` or `"click_continue"`.

---

## 4. Replace Hard-Coded Strings and Generate JSON Files

After assigning keys, use the following command to replace the hard-coded strings in your project files and generate JSON localization files:

```bash
flutter_loc replace -p /path/to/flutter_loc.txt -l en,ar,fr
```

### What This Does:

1. Replaces the strings in the source files with their corresponding keys (e.g., `welcome_message`).
2. Generates JSON files (`en.json`, `ar.json`, `fr.json`) for the specified languages.
3. Populates the JSON files with the keys and default values (original text for the main language, empty strings for others).

---

## 5. Update Your Flutter App for Localization

Integrate the generated JSON files into your Flutter app. Update your `MaterialApp` configuration to support localization.

### Example Integration:

1. Add the `flutter_localizations` package:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_localizations:
       sdk: flutter
   ```

2. Import the necessary libraries:

   ```dart
   import 'package:flutter_localizations/flutter_localizations.dart';
   import 'package:flutter_gen/gen_l10n/app_localizations.dart';
   ```

3. Update your `MaterialApp` widget:

   ```dart
   MaterialApp(
     localizationsDelegates: [
       AppLocalizations.delegate,
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: [
       Locale('en', ''),
       Locale('ar', ''),
       Locale('fr', ''),
     ],
     // Other properties...
   );
   ```

---

## 6. Translate Your JSON Files

Open the generated JSON files and add translations for the keys.

### Example `en.json`:

```json
{
  "welcome_message": "Welcome to MyApp!",
  "click_continue": "Click here to continue"
}
```

### Example `ar.json`:

```json
{
  "welcome_message": "أهلا بك في MyApp!",
  "click_continue": "اضغط هنا للمتابعة"
}
```

### Example `fr.json`:

```json
{
  "welcome_message": "Bienvenue à MyApp!",
  "click_continue": "Cliquez ici pour continuer"
}
```

---

You're all set! `flutter_loc` has automated the tedious parts of localization, making your workflow faster and more efficient. If you have questions or need further assistance, feel free to open an issue on GitHub.
