import 'api_service_base.dart';
import '../models/catalogo_item.dart';

class GeneroService extends ApiServiceBase {
  Future<List<CatalogoItem>> listar() async {
    return fetchLista(
      endpoint: '/generos',
      idKey: 'letra',
      nombreKey: 'name',
    );
  }
}
