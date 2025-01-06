import 'package:darted_cli/console_helper.dart';
import 'package:darted_cli/io_helper.dart';
import 'package:darted_cli/yaml_module.dart';

import '../../../helpers/error_helper.dart';

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
    await YamlModule.validate(yamlContent, schema, yamlFilePath: yamlFilePath);
  } catch (e) {
    ErrorHelper.print(
        'Error in validating the Yaml configuration file supplied. $e');
    ConsoleHelper.exit(1);
  }
}

final schema = YamlValidationSchema(
  fields: {
    // Section 1: Extraction
    'extraction': FieldRule(
      type: YamlValueType.map,
      required: true,
      nestedFields: {
        'working_directory':
            FieldRule(type: YamlValueType.directoryPath, required: true),
        'generation_directory':
            FieldRule(type: YamlValueType.directoryPath, required: false),
        'include_extensions':
            FieldRule(type: YamlValueType.list, required: false),
        'exclude_paths': FieldRule(type: YamlValueType.list, required: false),
        'overwrite': FieldRule(type: YamlValueType.bool, required: false),
        'generate_visit_log':
            FieldRule(type: YamlValueType.bool, required: false),
        'custom_refinement_logic_file':
            FieldRule(type: YamlValueType.string, required: false),
        'key_format': FieldRule(
          type: YamlValueType.map,
          required: true,
          nestedFields: {
            'enabled': FieldRule(type: YamlValueType.bool, required: true),
            'max_value_length':
                FieldRule(type: YamlValueType.int, required: false),
            'prefix': FieldRule(type: YamlValueType.string, required: false),
            'suffix': FieldRule(type: YamlValueType.string, required: false),
            'separator': FieldRule(type: YamlValueType.string, required: false),
          },
        ),
      },
    ),

    // Section 2: Replacement
    'replacement': FieldRule(
      type: YamlValueType.map,
      required: true,
      nestedFields: {
        'output_directory':
            FieldRule(type: YamlValueType.directoryPath, required: true),
        'output_format': FieldRule(type: YamlValueType.string, required: true),
        'default_language':
            FieldRule(type: YamlValueType.string, required: true),
        'supported_languages':
            FieldRule(type: YamlValueType.list, required: true),
      },
    ),
  },
);
