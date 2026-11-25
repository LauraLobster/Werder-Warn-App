import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werderwarn/app/app.dart';
import 'package:werderwarn/data/home_match_repository/home_match_repository.dart';
import 'package:werderwarn/data/openligadb_api/openligadb_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final homeMatchRepository = HomeMatchRepository(
    client: OpenLigaDbClient(httpClient: http.Client()),
    cache: SharedPreferencesHomeMatchCache(preferences),
  );
  runApp(App(homeMatchRepository: homeMatchRepository));
}
