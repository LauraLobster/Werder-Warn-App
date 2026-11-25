import 'dart:io';

/// A trimmed real response of `getmatchdata/bl1/2026`:
/// a Werder home match, a Werder away match and an unrelated match.
String openLigaDbSampleResponse() =>
    File('test/fixtures/openligadb_bl1_sample.json').readAsStringSync();
