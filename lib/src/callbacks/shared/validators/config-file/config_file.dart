import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';

import '../../../../helpers/error_helper.dart';

/// Validate the config file supplied.
Future<void> validateConfigFile(String yamlFilePath) async {
  // Check the path...
  if (!await IOHelper.file.exists(yamlFilePath)) {
    ErrorHelper.print('The provided path to the config file is invalid.');
    ConsoleHelper.exit(1);
  }

  // Get the content of the Yaml file
  final YamlMap yamlContent = await YamlModule.load(yamlFilePath);

  try {
    // Validate the content of the Yaml file against the schema.
    await YamlModule.validate(yamlContent, schema);
  } catch (e) {
    ErrorHelper.print('Error in validating the Yaml configuration file supplied.$e');
    ConsoleHelper.exit(1);
  }
}

final schema = YamlValidationSchema(
  fields: {
    // Section 1: Extraction
    'extraction': FieldRule(
      type: 'map',
      required: true,
      nestedFields: {
        'working_directory': FieldRule(type: 'string', required: true),
        'generation_directory': FieldRule(type: 'string', required: false),
        'include_extensions': FieldRule(type: 'list', required: false),
        'exclude_paths': FieldRule(type: 'list', required: false),
        'overwrite': FieldRule(type: 'bool', required: false),
        'generate_visit_log': FieldRule(type: 'bool', required: false),
        'custom_refinement_logic_file': FieldRule(type: 'string', required: false),
        'key_format': FieldRule(
          type: 'map',
          required: true,
          nestedFields: {
            'enabled': FieldRule(type: 'bool', required: true),
            'max_value_length': FieldRule(type: 'int', required: false),
            'prefix': FieldRule(type: 'string', required: false),
            'suffix': FieldRule(type: 'string', required: false),
            'separator': FieldRule(type: 'string', required: false),
          },
        ),
      },
    ),

    // Section 2: Replacement
    'replacement': FieldRule(
      type: 'map',
      required: true,
      nestedFields: {
        'output_directory': FieldRule(type: 'string', required: true),
        'output_format': FieldRule(type: 'string', required: true),
        'default_language': FieldRule(type: 'string', required: true),
        'supported_languages': FieldRule(type: 'list', required: true),
      },
    ),
  },
);
