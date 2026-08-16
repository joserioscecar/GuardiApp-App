import 'api_service_base.dart';
import '../models/catalogo_item.dart';

class EntornoService extends ApiServiceBase {
  Future<List<CatalogoItem>> listar() async {
    return fetchLista(endpoint: '/entornos');
  }
}
