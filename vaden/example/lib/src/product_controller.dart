// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vaden/vaden.dart';

@Api(tag: 'product', description: 'Product operations')
@Controller('/product')
class ProductController {
  final products = <ProductDTO>[
    ProductDTO(
      id: 1,
      name: 'Product 1',
      description: 'Description 1',
      price: 100.0,
      stock: 10,
    ),
    ProductDTO(
      id: 2,
      name: 'Product 2',
      description: 'Description 2',
      price: 200.0,
      stock: 20,
    ),
  ];

  //crud
  @Get('/')
  List<ProductDTO> getAllProducts() {
    return products;
  }

  @Get('/<id>')
  ProductDTO getProductById(@Param() int id) {
    final index = products.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    return products[index];
  }

  @Post('/')
  ProductDTO createProduct(@Body() ProductDTO product) {
    product.id = products.length + 1;
    products.add(product);
    return product;
  }

  @Put('/<id>')
  ProductDTO updateProduct(@Param() int id, @Body() ProductDTO product) {
    final index = products.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    products[index] = product;
    return product;
  }

  @Delete('/<id>')
  ProductDTO deleteProduct(@Param() int id) {
    final index = products.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw ResponseException(404, 'Product not found');
    }
    return products.removeAt(index);
  }
}

@DTO()
class ProductDTO {
  int id;
  String name;
  String description;
  double price;
  int stock;

  ProductDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
  });
}
