import 'api_service_base.dart';
import '../models/catalogo_item.dart';

class GrupoPoblacionalService extends ApiServiceBase {
  Future<List<CatalogoItem>> listar() async {
    return fetchLista(endpoint: '/grupos-poblacionales');
  }
}
