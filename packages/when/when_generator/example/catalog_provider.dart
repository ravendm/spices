import 'package:when/when.dart';

part 'catalog_provider.g.dart';

@When()
abstract class CatalogState {
  const CatalogState();
}

class CatalogStateInitial extends CatalogState {
  const CatalogStateInitial();
}

class CatalogStateLoading extends CatalogState {
  const CatalogStateLoading();
}

class CatalogStateSuccess extends CatalogState {
  const CatalogStateSuccess({required this.catalog});

  final CatalogEntity catalog;
}

class CatalogStateFailure extends CatalogState {
  const CatalogStateFailure();
}

class CatalogProvider extends ValueNotifier<CatalogState> {
  CatalogProvider({required this.catalogApi}) : super(const CatalogStateInitial());

  final CatalogApi catalogApi;

  Future<void> init() async {
    value = CatalogStateSuccess(catalog: await catalogApi.catalog());
  }
}
