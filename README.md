# Huma Volve Ecommerce App

## Architecture

The API-backed Auth and Home features separate presentation, domain contracts,
and data/infrastructure:

```text
Auth screen -> AuthController -> AuthRepository
                              -> AuthRepositoryImpl
                                 -> AuthRemoteDataSource
                                 -> TokenStorage

Home screen -> HomeCubit -> HomeRepository
                          -> HomeRepositoryImpl
                             -> HomeRemoteDataSource
                                -> API DTOs -> domain entities
```

`main.dart` is the composition root. It creates the shared API client and
concrete data/repository implementations, then provides the repository
abstractions to the app. Screens and state controllers receive those
abstractions rather than constructing HTTP clients.

The app opens the splash screen first, then shows Login on every launch.
Sign Up is available from the Login screen.

The Home API models live in `features/home/data/models`; the Home domain
entities and repository contract do not depend on Dio or Flutter. The Cart and
Profile screens still use the project's existing demo data because those
features do not yet have API-backed repositories.

Home products are fetched in pages using the API's `limit`/`offset` parameters.
The HomeCubit loads further pages as the product grid approaches the bottom and
supports pull-to-refresh.

## Verification

Run the app and checks from the project root:

```powershell
flutter run
flutter analyze
flutter test
```
