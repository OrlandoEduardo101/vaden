import 'package:vaden/vaden.dart';

abstract class BaseDTO {}

abstract class BaseService<T extends BaseDTO> {
  List<T> getAll();
  T getById(int id);
  T create(T item);
  T update(int id, T item);
  T delete(int id);
}

abstract class BaseController<S extends BaseService<T>, T extends BaseDTO> {
  final S service;
  BaseController(this.service);

  @Get('/')
  List<T> getAll() => service.getAll();

  @Get('/<id>')
  T getById(@Param() int id) => service.getById(id);

  @Post('/')
  T create(@Body() T item) => service.create(item);

  @Put('/<id>')
  T update(@Param() int id, @Body() T item) => service.update(id, item);

  @Delete('/<id>')
  T delete(@Param() int id) => service.delete(id);
}
