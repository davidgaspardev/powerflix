import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/features/profile/presentation/register_viewmodel.dart';
import 'package:moveflix/features/workout/workout_routes.dart';
import 'package:moveflix/features/profile/presentation/widget/fieldtext.dart';

class RegisterWidget extends StatefulWidget {
  static const routeName = '/register';

  final RegisterViewModel viewModel;

  const RegisterWidget({super.key, required this.viewModel});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _birthdayKey = GlobalKey<FormFieldState<DateTime>>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  late final RegisterViewModel _viewModel;

  BodySex _sex = BodySex.male;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _viewModel.save(UserModel(
      name: _nameController.text.trim(),
      sex: _sex,
      birthday: _birthdayKey.currentState!.value!,
      weight: double.parse(_weightController.text.trim()),
      height: double.parse(_heightController.text.trim()),
    ));

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(WorkoutRoutes.list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 12),
                          child: FieldText(
                            controller: _nameController,
                            label: 'What your name?',
                            hintText: 'Ex: David Gaspar',
                            textCapitalization: TextCapitalization.words,
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.withAlpha(100), thickness: 1),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 12),
                          child: _BirthdayField(
                            key: _birthdayKey,
                            validator: (v) => v == null
                                ? 'Selecione sua data de nascimento'
                                : null,
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.withAlpha(100), thickness: 1),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: FieldText(
                                  controller: _weightController,
                                  label: 'Peso (kg)',
                                  hintText: 'Ex: 70.5',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  validator: (v) {
                                    final n = double.tryParse(v?.trim() ?? '');
                                    return (n == null || n <= 0) ? 'Informe um peso válido' : null;
                                  },
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: Colors.grey.withAlpha(100),
                                thickness: 1,
                              ),
                              Expanded(
                                child: FieldText(
                                  controller: _heightController,
                                  label: 'Altura (cm)',
                                  hintText: 'Ex: 175',
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    final n = double.tryParse(v?.trim() ?? '');
                                    return (n == null || n <= 0) ? 'Informe uma altura válida' : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.withAlpha(100), thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
        const SizedBox(height: 16),
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

class _BirthdayField extends FormField<DateTime> {
  _BirthdayField({
    super.key,
    super.validator,
  }) : super(
          builder: (FormFieldState<DateTime> state) {
            final formatted = state.value == null
                ? null
                : '${state.value!.day.toString().padLeft(2, '0')}/'
                    '${state.value!.month.toString().padLeft(2, '0')}/'
                    '${state.value!.year}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: state.context,
                      initialDate: state.value ?? DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) state.didChange(picked);
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    isEmpty: state.value == null,
                    decoration: const InputDecoration(
                      labelText: 'Data de nascimento',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 0),
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    child: Text(
                      formatted ?? 'Ex: 16/02/1999',
                      style: Theme.of(state.context).textTheme.bodyLarge?.copyWith(
                        color: state.value == null
                            ? Colors.black.withAlpha(80)
                            : null,
                      ),
                    ),
                  ),
                ),
                if (state.hasError)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(state.context).colorScheme.error,
                        fontSize: 12,
                        height: -0.1,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
