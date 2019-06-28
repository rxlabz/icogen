import 'dart:io';

import 'package:image/image.dart';
import 'package:rxdart/rxdart.dart';

import 'constants.dart';

class _IconData {
  final String path;
  final int size;

  const _IconData(this.path, this.size);
}

class IconGenerator {
  final int color;
  final String projectPath;

  IconGenerator(this.color, this.projectPath);

  void generate() async {
    final iosIconRepo =
        '$projectPath/ios/Runner/Assets.xcassets/AppIcon.appiconset';
    final androidIconRepo = '$projectPath/android/app/src/main/res';

    List<Map<String, dynamic>> iconPaths = [];

    final destinationPath$ = Observable.fromIterable(iosDestinationPaths)
        .map((filename) => "$iosIconRepo/$filename")
        .concatWith([
      Observable.fromIterable(androidDestinationPaths)
          .map((filename) => "$androidIconRepo/$filename")
    ]);
    final size$ = Observable.fromIterable(iosSizes)
        .concatWith([Observable.fromIterable(androidSizes)]);

    Observable.zip2<String, int, _IconData>(
      destinationPath$,
      size$,
      (String destinationPath, int size) => _IconData(destinationPath, size),
    ).interval(Duration(milliseconds: 100)).listen(
      (data) async {
        final image = Image(data.size, data.size);
        fill(image, color);
        stdout.writeln('Generating ${data.path}...');

        try {
          await File(data.path).writeAsBytes(encodePng(image));
        } catch (error) {
          stderr.writeln('Error generating ${data.path} !!! $error');
          exit(1);
        }
      },
      onDone: () {
        stdout.writeln('COMPLETE !');
        exit(0);
      },
    );
  }
}
