import 'dart:js_util';

const String appName = "MyApp";
const String description = 'A simple app';

// Hard-coded strings in the main code.
void main() {
  print('Hello, World!');
  print("Welcome to MyApp.");
  String varr = 'someData';
  final String someString = 'I am hard-coded.';
  String someString2 = 'I am hard-coded. with $varr';
  final String someString3 = 'I am hard-coded. ${'Some cons in here & $varr'} in here!';
  final String someString4 = 'I am hard-coded.' + 'Some other';
  final String someString5 = 'I am hard-coded.' "SomeOthers!";
  // Text aTextWidget = Text
  final String someString6 = """I am hard-coded.
  Some
  Things
  Change
  ...""";
}

// A comment with a 'string' should not be included.
// Another comment.

@SomeAnnotation('ignored string')
class Example {}

class SomeAnnotation {
  const SomeAnnotation(String s);
}
