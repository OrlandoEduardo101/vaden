// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vaden/vaden.dart';

@Api(tag: 'item', description: 'Item operations')
@Controller('/item')
class ItemController extends ControllerBase {}

abstract class ControllerBase {
  final items = <ItemDTO>[
    ItemDTO(
      id: 1,
      name: 'Product 1',
    ),
    ItemDTO(
      id: 2,
      name: 'Product 2',
    ),
  ];

  //crud
  @Get('/')
  List<ItemDTO> getAll() {
    return items;
  }

  @Get('/<id>')
  ItemDTO getById(@Param() int id) {
    final index = items.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    return items[index];
  }

  @Post('/')
  ItemDTO create(@Body() ItemDTO product) {
    product.id = items.length + 1;
    items.add(product);
    return product;
  }

  @Put('/<id>')
  ItemDTO update(@Param() int id, @Body() ItemDTO product) {
    final index = items.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    items[index] = product;
    return product;
  }

  @Delete('/<id>')
  ItemDTO delete(@Param() int id) {
    final index = items.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    return items.removeAt(index);
  }
}

@DTO()
class ItemDTO {
  int id;
  String name;

  ItemDTO({
    required this.id,
    required this.name,
  });
}
