String fileStartDelimeter(String path) => "##PATH-START{file://$path}##";
String fileEndDelimeter = "##PATH-END##";
//
String pathToMatchesDelimeter = "#----------#";
String matchesToMatchesDelimeter(String line) => "##MATCH-LINE{$line}##";
String contentDelimeter = "===>";
String lineEndDelimeter = "!;;!";
