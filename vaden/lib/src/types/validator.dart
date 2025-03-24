import 'package:lucid_validation/lucid_validation.dart';

/// Mixin for creating validators in the Vaden framework.
///
/// The Validator mixin provides a standardized way to define validation rules
/// for data transfer objects (DTOs) in the Vaden framework. It leverages the
/// LucidValidator library to create fluent, type-safe validation rules.
///
/// To create a validator for a DTO, create a class that implements this mixin
/// and override the [validate] method to define the validation rules.
///
/// Example:
/// ```dart
/// @DTO()
/// class CreateUserDTO {
///   final String name;
///   final String email;
///   final String password;
///
///   CreateUserDTO({required this.name, required this.email, required this.password});
///
///   factory CreateUserDTO.fromJson(Map<String, dynamic> json) => CreateUserDTO(
///     name: json['name'],
///     email: json['email'],
///     password: json['password'],
///   );
///
///   Map<String, dynamic> toJson() => {
///     'name': name,
///     'email': email,
///     'password': password,
///   };
/// }
///
/// @Component()
/// class CreateUserValidator implements Validator<CreateUserDTO> {
///   @override
///   LucidValidator<CreateUserDTO> validate(ValidatorBuilder<CreateUserDTO> builder) {
///     return builder
///       .ruleFor((dto) => dto.name)
///         .notEmpty()
///         .withMessage('Name is required')
///         .maxLength(50)
///         .withMessage('Name must be at most 50 characters')
///       .ruleFor((dto) => dto.email)
///         .notEmpty()
///         .withMessage('Email is required')
///         .emailAddress()
///         .withMessage('Invalid email format')
///       .ruleFor((dto) => dto.password)
///         .notEmpty()
///         .withMessage('Password is required')
///         .minLength(8)
///         .withMessage('Password must be at least 8 characters');
///   }
/// }
/// ```
///
/// Usage in a controller:
/// ```dart
/// @Controller('/api/users')
/// class UserController {
///   final CreateUserValidator _validator;
///
///   UserController(this._validator);
///
///   @Post('/')
///   Future<Response> createUser(Request request, @Body() CreateUserDTO dto) {
///     final validationResult = _validator.validate(ValidatorBuilder<CreateUserDTO>()).validate(dto);
///     
///     if (!validationResult.isValid) {
///       throw ResponseException(422, {'errors': validationResult.errors});
///     }
///     
///     // Process the validated DTO
///   }
/// }
/// ```
mixin Validator<T> {
  /// Defines validation rules for a data transfer object.
  ///
  /// This method should be implemented to define the validation rules for the
  /// data transfer object of type T. It receives a [ValidatorBuilder] instance
  /// that can be used to define the rules in a fluent, chainable manner.
  ///
  /// Parameters:
  /// - [builder]: The validator builder to define rules with.
  ///
  /// Returns:
  /// - A configured [LucidValidator] instance with all the validation rules defined.
  LucidValidator<T> validate(ValidatorBuilder<T> builder);
}

/// Builder class for creating validators in the Vaden framework.
///
/// This class extends [LucidValidator] to provide a fluent API for defining
/// validation rules. It is used in conjunction with the [Validator] mixin to
/// create validators for data transfer objects.
///
/// The ValidatorBuilder is typically instantiated and passed to the [validate]
/// method of a [Validator] implementation, where it is configured with validation
/// rules and then returned.
///
/// Example:
/// ```dart
/// final validator = userValidator.validate(ValidatorBuilder<UserDTO>());
/// final result = validator.validate(userDto);
/// ```
class ValidatorBuilder<T> extends LucidValidator<T> {}
