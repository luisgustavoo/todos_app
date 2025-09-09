// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:todos_app/config/dependencies.dart' as _i812;
import 'package:todos_app/data/repositories/todo/todo_repository.dart' as _i287;
import 'package:todos_app/data/repositories/todo/todo_repository_local.dart'
    as _i989;
import 'package:todos_app/data/services/local/local_data_service.dart' as _i371;
import 'package:todos_app/data/services/shared_preferences_service.dart'
    as _i107;
import 'package:todos_app/ui/todo/view_models/todo_view_model.dart' as _i945;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i107.SharedPreferencesService>(
      () => _i107.SharedPreferencesService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i371.LocalDataService>(
      () => _i371.LocalDataService(gh<_i107.SharedPreferencesService>()),
    );
    gh.factory<_i287.TodoRepository>(
      () => _i989.TodoRepositoryLocal(
        localDataService: gh<_i371.LocalDataService>(),
      ),
    );
    gh.lazySingleton<_i945.TodoViewModel>(
      () => _i945.TodoViewModel(todoRepository: gh<_i287.TodoRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i812.RegisterModule {}
