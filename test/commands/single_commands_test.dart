import 'package:test/test.dart';

import 'common.dart';

void main() {
  late GitCommandSetupResult s;

  setUpAll(() async {
    s = await gitCommandTestSetupAll();
  });

  setUp(() async => gitCommandTestSetup(s));

  var singleCommandTests = [
    'branch',
    'branch test',
    'branch master',
    'branch -a',
    'write-tree',
    'rm LICENSE',
    'rm does-not-exist',
    'branch -d not-existing',
  ];

  for (var command in singleCommandTests) {
    test(command, () async => testGitCommand(s, command));
  }

  test('rm /outside-rep', () async {
    await testGitCommand(s, 'rm /outside-repo', containsMatch: true);
  });

  test(
    'checkout 1 file',
    () async => testCommands(s, [
      'echo dddd > LICENSE',
      'git checkout LICENSE',
    ]),
  );

  test(
    'git rm deleted file',
    () async => testCommands(s, [
      'rm LICENSE',
      'git rm LICENSE',
    ]),
  );

  test(
    'git delete branch',
    () async => testCommands(s, [
      'git branch foo',
      'git branch -d foo',
    ]),
  );

  test(
    'git upstream branch',
    () async => testCommands(s, [
      'git branch foo/fde',
      'git branch --set-upstream-to=origin/master',
    ]),
  );

  test(
    'git remote',
    () async => testCommands(s, [
      'git remote add origin2í foo',
      'git remote',
      'git remote -v',
      'git remote rm origin2í'
    ]),
  );

  test(
    'git checkout remote branch',
    () async => testCommands(
        s,
        [
          'git init -q .',
          'git remote add origin https://github.com/GitJournal/icloud_documents_path.git',
          'git fetch origin',
          'git checkout -b master origin/master',
          'git remote rm origin',
        ],
        emptyDirs: true),
  );

  test(
    'git checkout branch',
    () async => testCommands(
        s,
        [
          'git branch branch-for-ítesting origin/branch-for-testing',
          'git checkout branch-for-ítesting',
        ],
        ignoreOutput: true),
  );

  test('rm /outside-rep', () async {
    await testGitCommand(s, 'rm /outside-repo', containsMatch: true);
  });

  test(
    'checkout 1 file',
    () async => testCommands(s, [
      'echo dddd > LICENSE',
      'git checkout LICENSE',
    ]),
  );

  test(
    'git rm deleted file',
    () async => testCommands(s, [
      'rm LICENSE',
      'git rm LICENSE',
    ]),
  );

  test(
    'git delete branch',
    () async => testCommands(s, [
      'git branch foo',
      'git branch -d foo',
    ]),
  );

  test(
    'git upstream branch',
    () async => testCommands(s, [
      'git branch foo/fde',
      'git branch --set-upstream-to=origin/master',
    ]),
  );

  test(
    'git remote',
    () async => testCommands(s, [
      'git remote add origin2í foo',
      'git remote',
      'git remote -v',
      'git remote rm origin2í'
    ]),
  );

  test(
    'git checkout remote branch',
    () async => testCommands(
      s,
      [
        'git init -q .',
        'git remote add origin https://github.com/GitJournal/icloud_documents_path.git',
        'git fetch origin',
        'git checkout -b master origin/master',
        'git remote rm origin',
      ],
      emptyDirs: true,
    ),
  );

  test(
    'git checkout branch',
    () async => testCommands(
      s,
      [
        'git branch branch-for-ítesting origin/branch-for-testing',
        'git checkout branch-for-ítesting',
      ],
      ignoreOutput: true,
    ),
  );
}
