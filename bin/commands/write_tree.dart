import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:dart_git/git.dart';

class WriteTreeCommand extends Command {
  @override
  final name = 'write-tree';

  @override
  final description = 'Create a tree object from the current index';

  @override
  Future run() async {
    var gitRootDir = GitRepository.findRootDir(Directory.current.path)!;
    var repo = await GitRepository.load(gitRootDir).getOrThrow();

    var index = await repo.indexStorage.readIndex().getOrThrow();
    var hash = await repo.writeTree(index).getOrThrow();
    print(hash);
  }
}
