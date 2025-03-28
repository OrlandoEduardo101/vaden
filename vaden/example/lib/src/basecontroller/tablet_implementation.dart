import 'package:example/src/basecontroller/interfaces.dart';
import 'package:vaden/vaden.dart';

@DTO()
class Tablet implements BaseDTO {
  int id;
  String name;

  Tablet({
    required this.id,
    required this.name,
  });
}

@Service(false)
class TabletService extends BaseService<Tablet> {
  final List<Tablet> tablets = [
    Tablet(
      id: 1,
      name: 'Tablet 1',
    ),
    Tablet(
      id: 2,
      name: 'Tablet 2',
    ),
  ];

  @override
  List<Tablet> getAll() {
    return tablets;
  }

  @override
  Tablet getById(int id) {
    final index = tablets.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Tablet not found');
    }
    return tablets[index];
  }

  @override
  Tablet create(Tablet tablet) {
    tablet.id = tablets.length + 1;
    tablets.add(tablet);
    return tablet;
  }

  @override
  Tablet update(int id, Tablet tablet) {
    final index = tablets.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Tablet not found');
    }
    tablets[index] = tablet;
    return tablet;
  }

  @override
  Tablet delete(int id) {
    final index = tablets.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Tablet not found');
    }
    return tablets.removeAt(index);
  }
}

@Api(tag: 'Tablet API')
@Controller('/tablet')
class TabletController extends BaseController<TabletService, Tablet> {
  TabletController(super.tabletService);
}
