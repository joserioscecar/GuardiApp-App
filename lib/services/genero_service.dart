import 'api_service_base.dart';
import 'catalogo_item.dart';

class GeneroService extends ApiServiceBase {
  Future<List<CatalogoItem>> listar() async {
    return fetchLista(
      endpoint: '/api/generos',
      idKey: 'letra',
      nombreKey: 'name',
    );
  }
}
