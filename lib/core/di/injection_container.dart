import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportify/core/localization/cubit/locale_cubit.dart';
import 'package:sportify/core/network/api_client.dart';
import 'package:sportify/core/theme/cubit/theme_cubit.dart';
import 'package:sportify/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:sportify/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:sportify/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportify/features/auth/domain/use_cases/login_with_email.dart';
import 'package:sportify/features/auth/domain/use_cases/login_with_social.dart';
import 'package:sportify/features/auth/domain/use_cases/logout.dart';
import 'package:sportify/features/auth/domain/use_cases/register_user.dart';
import 'package:sportify/features/auth/domain/use_cases/restore_session.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sportify/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:sportify/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:sportify/features/feed/domain/repositories/feed_repository.dart';
import 'package:sportify/features/feed/domain/use_cases/get_feed_posts.dart';
import 'package:sportify/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:sportify/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:sportify/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sportify/features/profile/domain/repositories/profile_repository.dart';
import 'package:sportify/features/profile/domain/use_cases/get_profile.dart';
import 'package:sportify/features/profile/domain/use_cases/update_profile.dart';
import 'package:sportify/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sportify/features/fitpass/data/datasources/fitpass_remote_datasource.dart';
import 'package:sportify/features/fitpass/data/repositories/fitpass_repository_impl.dart';
import 'package:sportify/features/fitpass/domain/repositories/fitpass_repository.dart';
import 'package:sportify/features/fitpass/domain/usecases/fitpass_usecases.dart';
import 'package:sportify/features/fitpass/presentation/bloc/fitpass_bloc.dart';
import 'package:sportify/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:sportify/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:sportify/features/chat/domain/repositories/chat_repository.dart';
import 'package:sportify/features/chat/domain/usecases/chat_usecases.dart';
import 'package:sportify/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:sportify/features/news/data/datasources/news_remote_datasource.dart';
import 'package:sportify/features/news/data/repositories/news_repository_impl.dart';
import 'package:sportify/features/news/domain/repositories/news_repository.dart';
import 'package:sportify/features/news/domain/usecases/news_usecases.dart';
import 'package:sportify/features/news/presentation/bloc/news_bloc.dart';


/// Global service locator instance.
final sl = GetIt.instance;

/// Initializes all dependencies in the correct order.
///
/// Called once in `main.dart` before `runApp`.
///
/// Registration order:
/// 1. External / 3rd party
/// 2. Core services (networking, storage)
/// 3. Data sources
/// 4. Repositories
/// 5. Use cases
/// 6. Blocs (as Factory — new instance per screen)
Future<void> initDependencies() async {
  // ── 0. External ──
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<FlutterSecureStorage>(secureStorage)
    // ── 1. Core ──
    ..registerLazySingleton<ApiClient>(ApiClient.new)
    ..registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()))
    ..registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  // ── 2. Data Sources ──
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<FeedRemoteDataSource>(
      () => const FeedRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<NewsRemoteDataSource>(
      () => const NewsRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<FitPassRemoteDataSource>(
      () => const FitPassRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => const ChatRemoteDataSourceImpl(),
    );

  // ── 3. Repositories ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<FitPassRepository>(
    () => FitPassRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // ── 4. Use Cases ──
  sl
    ..registerLazySingleton(() => LoginWithEmail(sl()))
    ..registerLazySingleton(() => RegisterUser(sl()))
    ..registerLazySingleton(() => LoginWithSocial(sl()))
    ..registerLazySingleton(() => Logout(sl()))
    ..registerLazySingleton(() => RestoreSession(sl()))
    ..registerLazySingleton(() => GetFeedPosts(sl()))
    ..registerLazySingleton(() => GetProfile(sl()))
    ..registerLazySingleton(() => UpdateProfile(sl()))
    ..registerLazySingleton(() => GetNews(sl()))
    ..registerLazySingleton(() => GetTransfers(sl()))
    ..registerLazySingleton(() => GetFitPassPlans(sl()))
    ..registerLazySingleton(() => GetFitPassPartners(sl()))
    ..registerLazySingleton(() => GetConversations(sl()))
    ..registerLazySingleton(() => GetMessages(sl()))
    ..registerLazySingleton(() => SendMessage(sl()));

  // ── 5. Blocs ──
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginWithEmail: sl(),
      registerUser: sl(),
      loginWithSocial: sl(),
      logout: sl(),
      restoreSession: sl(),
    ),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfile: sl(),
      updateProfile: sl(),
    ),
  );
  sl.registerFactory<FeedCubit>(
    () => FeedCubit(
      getFeedPosts: sl(),
    ),
  );
  sl.registerFactory<NewsBloc>(
    () => NewsBloc(
      getNews: sl(),
      getTransfers: sl(),
    ),
  );
  sl.registerFactory<FitPassBloc>(
    () => FitPassBloc(
      getFitPassPlans: sl(),
      getFitPassPartners: sl(),
    ),
  );
  sl.registerFactory<ChatBloc>(
    () => ChatBloc(
      getConversations: sl(),
    ),
  );
}
