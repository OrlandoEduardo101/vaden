import 'package:example/src/basecontroller/interfaces.dart';
import 'package:vaden/vaden.dart';

@DTO()
class CarDTO implements BaseDTO {
  int id;
  String name;

  CarDTO({
    required this.id,
    required this.name,
  });
}

@Service(false)
class CarService extends BaseService<CarDTO> {
  final List<CarDTO> cars = [
    CarDTO(
      id: 1,
      name: 'Car 1',
    ),
    CarDTO(
      id: 2,
      name: 'Car 2',
    ),
  ];

  @override
  List<CarDTO> getAll() {
    return cars;
  }

  @override
  CarDTO getById(int id) {
    final index = cars.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException.notFound('Car not found');
    }
    return cars[index];
  }

  @override
  CarDTO create(CarDTO car) {
    car.id = cars.length + 1;
    cars.add(car);
    return car;
  }

  @override
  CarDTO update(int id, CarDTO car) {
    final index = cars.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException.notFound('Car not found');
    }
    cars[index] = car;
    return car;
  }

  @override
  CarDTO delete(int id) {
    final index = cars.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException.notFound('Car not found');
    }
    return cars.removeAt(index);
  }
}

@Api(tag: 'Car API')
@Controller('/car')
class CarController extends BaseController<CarService, CarDTO> {
  CarController(super.service);
}
