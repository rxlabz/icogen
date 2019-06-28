import 'dart:io';

import 'package:args/args.dart';
import 'package:icogen/constants.dart';
import 'package:icogen/icon_generator.dart';
import 'package:icogen/utils.dart';

main(List<String> arguments) async {
  final parser = ArgParser();

  parser.addFlag('ios-only', abbr: 'i');
  parser.addFlag('android-only', abbr: 'a');
  parser.addOption('project-path', abbr: 'p', defaultsTo: null);
  parser.addOption('color', abbr: 'c');

  final args = parser.parse(arguments);

  if (args['project-path'] == null) {
    stderr.writeln(
        "ERROR !!!\n=> You must define the project path argument : -p /path/to/project");
    exit(1);
  }

  if (args['color'] != null) {
    stdout.writeln('Start generate [ ${args['color']} ] icons ...');
    IconGenerator(hexToABGR(args['color']) ?? white, args['project-path'])
        .generate();
  } else {
    exit(1);
  }
}
