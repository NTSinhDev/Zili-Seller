
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/services/local_storage_service.dart';

abstract class BaseRepository {
  LocalStoreService get storage => di<LocalStoreService>();
  void clean();
}
