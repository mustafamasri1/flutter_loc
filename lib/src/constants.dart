/// The delimeter constant in the begining of the file.
String fileStartDelimeter(String path) => "##PATH-START{file://$path}##";

/// The delimeter constant in the end of the file.
String fileEndDelimeter = "##PATH-END##";

/// The delimeter constant between the path delimeter and the matches block.
String pathToMatchesDelimeter = "#----------#";

/// The delimeter constant between the each of the maatches in the matches block.
String matchesToMatchesDelimeter(String line) => "##MATCH-LINE{$line}##";

/// The delimeter constant between the matched string and the to-be-provided key string.
String contentDelimeter = "===>";

/// The delimeter constant at the end of each line.
String lineEndDelimeter = "!;;!";
