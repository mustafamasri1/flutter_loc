// Test file for string extraction patterns
// Contains various cases and edge cases for Dart string literals

// SECTION - Simple String Cases
String simple1 = 'Basic single quoted string';
String simple2 = "Basic double quoted string";
String simple3 = 'String with "embedded" double quotes';
String simple4 = "String with 'embedded' single quotes";

// SECTION - Escape Sequences
String escape1 = 'String with escaped \'single\' quotes';
String escape2 = "String with escaped \"double\" quotes";
String escape3 = 'String with escaped \n newline';
String escape4 = "String with escaped \t tab";
String escape5 = r'Raw string with \n not escaped';
String escape6 = r"Raw string with \t not escaped";

// SECTION - String Interpolation
var name = 'John';
var age = 30;
String interp1 = "Hello, $name!";
String interp2 = "You are $age years old";
String interp3 = "Complex ${name.toUpperCase()} interpolation";
String interp4 = "Nested ${age > 18 ? 'adult' : 'minor'} interpolation";
String interp5 = "Multiple $name ${age + 5} interpolations";

// SECTION - Multi-line Strings
String multi1 = '''Basic
multi-line
string''';

String multi2 = """Another
multi-line
string""";

String multi3 = '''Multi-line with
$name and ${age + 5}
interpolation''';

String multi4 = """Multi-line with
'single' and "double"
quotes""";

// SECTION - Adjacent Strings
String adjacent1 = """First multi-line
string"""
    """Second multi-line
string""";

String adjacent2 = '''First multi-line
string'''
    '''Second multi-line
string''';

String adjacent3 = "First" 'Second' """Third""" '''Fourth''';

// SECTION - Edge Cases
String edge1 = ''; // Empty string
String edge2 = ""; // Empty double-quoted string
String edge3 = """"""; // Empty triple-quoted string
String edge4 = ''''''; // Empty triple-single-quoted string

// String with multiple interpolations and quotes
String edge5 = """Complex ${name.contains('J') ? "Joe's" : 'Jane\'s'} string""";

// Nested quotes in interpolation (Only one that didn't pass.)
String edge6 =
    "Nested ${age > 20 ? 'value with "quotes"' : "value with 'quotes'"} here";

// Mixed adjacent strings with interpolation
String edge7 = """Multi-line with ${name}
interpolation"""
    '''Another with ${age}
interpolation''';

// SECTION - Potentially Problematic Cases
String? var1 = 'Some variable';
String prob1 =
    '''String that ends with triple quote''' """Immediate next string""";
String prob2 = "String with ${var1 ?? 'default'} null check";
String prob3 = """String with unicode \u{1F600} emoji""";
String prob4 = '''Raw string with \
backslash and line continuation''';

// SECTION - Real-world Examples
String real1 = """SELECT * 
FROM users 
WHERE name = '${name.replaceAll("'", "''")}'
AND age > $age""";

String real2 = '''Dear $name,
We noticed you've been with us for ${age} years.
Please visit "our website" for your special offer.
Best regards,
The Team''';

// SECTION - Strings in Collections
final List<String> stringList = [
  'Item 1',
  "Item 2",
  """Item
  3""",
  '''Item
  4'''
];

final Map<String, String> stringMap = {
  'key1': 'value1',
  "key2": """Multi-line
  value2""",
  '''key3''': '''Multi-line
  value3'''
};

// SECTION - String Concatenation
String concat1 = 'First '
    'Second '
    '''Third
'''
    """Fourth
""";

String concat2 = "Start-" +
    """Middle
    part""" +
    '''-End''';

// SECTION - Comments and Strings
// 'This is a comment, not a string'
String comment1 = 'This is /* not */ a comment';
/* String notAString = 'This is in a comment block'; */
String comment2 = "String after /* comment */";

// SECTION - Documentation Comments
/// 'This is a doc comment'
String doc1 = 'This is a string';
/** "This is also a doc comment" */
String doc2 = "This is another string";
