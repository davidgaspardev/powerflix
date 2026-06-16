import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:powerflix/core/data/datasources/user_local_datasource.dart';
import 'package:powerflix/core/data/repositories/user_repository_impl.dart';
import 'package:powerflix/core/domain/models/body_sex.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_widget.dart';
import 'package:powerflix/features/profile/presentation/register_viewmodel.dart';

class RegisterWidget extends StatefulWidget {
  static const routeName = '/register';

  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  late final RegisterViewModel _viewModel;

  BodySex _sex = BodySex.male;
  DateTime? _birthday;

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel(
      UserRepositoryImpl(UserLocalDatasource()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione sua data de nascimento')),
      );
      return;
    }

    await _viewModel.save(UserModel(
      name: _nameController.text.trim(),
      sex: _sex,
      birthday: _birthday!,
      weight: double.parse(_weightController.text.trim()),
      height: double.parse(_heightController.text.trim()),
    ));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(MuscleMapWidget.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFD8161),
              const Color(0xFFFF5A5F),
            ]
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: SvgPicture.asset(
                      'assets/image/svg/logo.svg',
                      width: MediaQuery.of(context).size.width * 0.4,
                      colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Bem-vindo!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preencha seus dados para começar.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.surface.withAlpha(200),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 16, bottom: 8),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              label: Text('What your name?'),
                              hintText: "Ex: David Gaspar",
                              errorStyle: TextStyle(
                                fontSize: 12,
                                height: -0.1,
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.withAlpha(100),
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 16),
                          child: _BirthdayField(
                            value: _birthday,
                            onTap: _pickBirthday,
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.withAlpha(100),
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 16, bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _weightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Peso (kg)',
                                    hintText: 'Ex: 70.5',
                                    errorStyle: TextStyle(
                                      fontSize: 12,
                                      height: -0.1,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                                  validator: (v) {
                                    final n = double.tryParse(v?.trim() ?? '');
                                    if (n == null || n <= 0) return 'Informe um peso válido';
                                    return null;
                                  },
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: Colors.grey.withAlpha(100),
                                thickness: 1,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _heightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Altura (cm)',
                                    hintText: 'Ex: 175',
                                    errorStyle: TextStyle(
                                      fontSize: 12,
                                      height: -0.1,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    final n = double.tryParse(v?.trim() ?? '');
                                    if (n == null || n <= 0) return 'Informe uma altura válida';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey.withAlpha(100),
                          thickness: 1,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
                          child: _SexSelector(
                            value: _sex,
                            onChanged: (sex) => setState(() => _sex = sex),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListenableBuilder(
                    listenable: _viewModel,
                    builder: (_, __) => FilledButton(
                      onPressed: _viewModel.isSaving ? null : _submit,
                      child: _viewModel.isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Começar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SexSelector extends StatelessWidget {
  final BodySex value;
  final ValueChanged<BodySex> onChanged;

  const _SexSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sexo', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        SegmentedButton<BodySex>(
          style: ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          expandedInsets: EdgeInsets.zero,
          segments: const [
            ButtonSegment(value: BodySex.male, label: Text('Masculino'), icon: Icon(Icons.male)),
            ButtonSegment(value: BodySex.female, label: Text('Feminino'), icon: Icon(Icons.female)),
          ],
          selected: {value},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}

class _BirthdayField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;

  const _BirthdayField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = value == null
        ? 'Data de nascimento'
        : '${value!.day.toString().padLeft(2, '0')}/'
            '${value!.month.toString().padLeft(2, '0')}/'
            '${value!.year}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data de nascimento',
          suffixIcon: Icon(Icons.calendar_today, size: 18),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        child: Text(
          value == null ? '' : label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
