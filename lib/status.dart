import 'package:dart_git/dart_git.dart';
import 'package:dart_git/plumbing/index.dart';
import 'package:dart_git/plumbing/objects/tree.dart';
import 'package:file/file.dart';

class GitStatusResult {
  var added = <String>[];
  var removed = <String>[];
  var modified = <String>[];
  var unTracked = <String>[];

  void add(GitStatusResult r) {
    added.addAll(r.added);
    removed.addAll(r.removed);
    modified.addAll(r.modified);
    unTracked.addAll(r.unTracked);
  }
}

extension Status on GitRepository {
  Future<GitStatusResult> status() async {
    var rootTree = await headTree();

    GitStatusResult result;
    return _status(rootTree, workTree, result);
  }

  Future<GitStatusResult> _status(
      GitTree tree, String treePath, GitStatusResult result) async {
    var dirContents = await fs.directory(treePath).list().toList();
    var newFilesAdded = dirContents.map((e) => e.path).toSet();

    for (var entry in tree.entries) {
      var fsEntity = dirContents.firstWhere(
        (e) => e.basename == entry.name,
        orElse: () => null,
      );
      if (fsEntity == null) {
        result.removed.add(fsEntity.path);
        continue;
      }

      newFilesAdded.remove(fsEntity.path);

      if (_ignoreEntity(fsEntity)) {
        continue;
      }

      if (entry.mode != GitFileMode.Dir) {
        if (_fileModified(fsEntity, entry)) {
          result.modified.add(fsEntity.path);
        }
        continue;
      }

      var subTree = await objStorage.readObjectFromHash(entry.hash);
      result.add(await _status(subTree, fsEntity.path, result));
    }

    result.added.addAll(newFilesAdded);
    return result;
  }

  bool _fileModified(FileSystemEntity fsEntity, GitTreeEntry treeEntry) {
    // Most expensive way is to compute the hash
    return false;
  }

  bool _ignoreEntity(FileSystemEntity fsEntity) {
    return fsEntity.basename == '.git';
  }
}

// * Add a simple test for this
// * Look at the interface of go-git

// libGit2 takes a lot of status parameters
// and returns a diff of (Head to Index) and (Index to WorkTree)

// go-git has
/*

// StatusCode status code of a file in the Worktree
type StatusCode byte

const (
	Unmodified         StatusCode = ' '
	Untracked          StatusCode = '?'
	Modified           StatusCode = 'M'
	Added              StatusCode = 'A'
	Deleted            StatusCode = 'D'
	Renamed            StatusCode = 'R'
	Copied             StatusCode = 'C'
	UpdatedButUnmerged StatusCode = 'U'
)


go-git returns the staging area and workTree status code of each file
It uses a merkletrie to do the diff. What is this?

*/