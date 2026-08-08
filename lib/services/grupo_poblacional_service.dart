import 'api_service_base.dart';
import 'catalogo_item.dart';

class GrupoPoblacionalService extends ApiServiceBase {
  Future<List<CatalogoItem>> listar() async {
    return fetchLista(endpoint: '/api/grupos-poblacionales');
  }
}
