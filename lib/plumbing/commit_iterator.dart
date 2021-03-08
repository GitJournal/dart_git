import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:dart_git/git_hash.dart';
import 'package:dart_git/plumbing/objects/commit.dart';
import 'package:dart_git/storage/object_storage.dart';

Stream<GitCommit> commitIteratorBFS({
  @required ObjectStorage objStorage,
  @required GitCommit from,
}) async* {
  var queue = Queue<GitHash>.from([from.hash]);
  var seen = <GitHash>{};

  while (queue.isNotEmpty) {
    var hash = queue.removeFirst();
    if (seen.contains(hash)) {
      continue;
    }

    var obj = await objStorage.readObjectFromHash(hash);
    assert(obj is GitCommit);

    var commit = obj as GitCommit;
    yield commit;

    seen.add(hash);
    queue.addAll(commit.parents);
  }
}