import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_git/git.dart';

class DumpIndexCommand extends Command {
  @override
  final name = 'dump-index';

  @override
  final description = 'Prints the contents of the .git/index';

  @override
  Future run() async {
    var gitRootDir = GitRepository.findRootDir(Directory.current.path);
    var repo = await GitRepository.load(gitRootDir);

    var index = await repo.index();
    print('Index Version: ${index.versionNo}');
    for (var entry in index.entries) {
      var str = entry.toString();
      str = str.replaceAll(',', ',\n\t');
      str = str.replaceAll('{', '{\n\t');
      str = str.replaceAll('}', '\n}');
      print(str);
    }
  }
}
