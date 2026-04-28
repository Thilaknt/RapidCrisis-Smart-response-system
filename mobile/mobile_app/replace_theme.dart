import 'dart:io';

void main() {
  final directory = Directory('lib/features');
  if (!directory.existsSync()) {
    print('lib/features not found');
    return;
  }

  int count = 0;
  for (final file in directory.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      final content = file.readAsStringSync();
      final updated = content
          .replaceAll('Colors.white54', 'Colors.black54')
          .replaceAll('Colors.white38', 'Colors.black38')
          .replaceAll('Colors.white24', 'Colors.black26')
          .replaceAll('Colors.white', 'Colors.black87');

      if (content != updated) {
        file.writeAsStringSync(updated);
        print('Fixed theme colors in: ${file.path}');
        count++;
      }
    }
  }
  print('Fixed colors in $count files.');
}
