import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/localization.dart';

import '../../../domain/entities/dependency.dart';
import '../../core/ui/ui.dart';

class VadenDependenciesDialog extends StatefulWidget {
  final Function(Dependency) onSave;
  final VoidCallback onCancel;
  final List<Dependency> dependencies;

  const VadenDependenciesDialog({
    super.key,
    required this.onSave,
    required this.onCancel,
    required this.dependencies,
  });

  static Future<Dependency?> show(
    BuildContext context,
    List<Dependency> dependencies,
  ) async {
    return await showDialog<Dependency>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => VadenDependenciesDialog(
        dependencies: dependencies,
        onSave: (selectedDeps) {
          Navigator.of(context).pop(selectedDeps);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  State<VadenDependenciesDialog> createState() => _VadenDependenciesDialogState();
}

class _VadenDependenciesDialogState extends State<VadenDependenciesDialog> {
  var _currentCategory = 'Todos';
  String? _search;

  List<String> _getUniqueCategories(List<Dependency> dependencies) {
    final categories = dependencies.map((dep) => dep.tag).toSet().toList();
    return ['Todos', ...categories.isEmpty ? [] : categories];
  }

  List<Dependency> _getFilteredDependencies(List<Dependency> dependencies, [String? search]) {
    if (dependencies.isEmpty) return [];
    if (_currentCategory == 'Todos') {
      if (search == null) return dependencies;
      return dependencies
          .where((dep) => dep.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    if (search != null) {
      return dependencies
          .where((dep) => dep.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    return dependencies.where((dep) => dep.tag == _currentCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = 12.0;
    late final double lineHeight = 24.0 / fontSize;
    late final double letterSpacing = fontSize * 0.04;

    final categories = _getUniqueCategories(widget.dependencies);
    final filteredDependencies = _getFilteredDependencies(widget.dependencies, _search);

    if (widget.dependencies.isNotEmpty && !categories.contains(_currentCategory)) {
      _currentCategory = categories.first;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: 900,
        decoration: BoxDecoration(
          color: VadenColors.dialogBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Dependencies'.i18n(),
                        style: GoogleFonts.anekBangla(
                          color: VadenColors.txtSecondary,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              VadenColors.gradientStart,
                              VadenColors.gradientEnd,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  VadenTextInput(
                    suffixIcon: Icon(Icons.search),
                    label: 'Search'.i18n(),
                    hint: 'Search'.i18n(),
                    width: 360,
                    onChanged: (value) {
                      setState(() {
                        _search = value;
                      });
                    },
                  ),
                  Container(
                    height: 40,
                    constraints: BoxConstraints(
                      minWidth: 120,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: VadenDropdown(
                      options: categories,
                      height: 36,
                      fontSize: 12.0,
                      dynamicWidth: true,
                      optionsStyle: GoogleFonts.anekBangla(
                        fontSize: fontSize,
                        color: VadenColors.txtSecondary,
                        height: lineHeight * 0.5,
                        letterSpacing: letterSpacing,
                      ),
                      selectedOption: _currentCategory,
                      onOptionSelected: (newCategory) {
                        setState(() {
                          _currentCategory = newCategory;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                minHeight: 50,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemCount: filteredDependencies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final dependency = filteredDependencies[index];

                  return VadenCard(
                    title: dependency.name,
                    subtitle: dependency.description,
                    tag: dependency.tag,
                    isSelected: false,
                    onTap: () => widget.onSave(dependency),
                    maxLines: 3,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
