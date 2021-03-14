import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sam/domain/bloc/configuration.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/ui/common.dart';

class Configuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfigurationBloc bloc = BlocProvider.of(context);
    final messages = context.messages.config;
    return BlocBuilder<ConfigurationBloc, GameConfiguration>(
      builder: (context, config) => ListView(
        children: [
          _OptionCard(
            name: messages.min.name,
            description: messages.min.description,
            control: _NumberBox(
              value: config.minimumSips,
              onChange: (value) => bloc.add(ChangeMinimum(minimum: value)),
            ),
          ),
          _OptionCard(
            name: messages.max.name,
            description: messages.max.description,
            control: _NumberBox(
              value: config.maximumSips,
              onChange: (value) => bloc.add(ChangeMaximum(maximum: value)),
            ),
          ),
          _OptionCard(
            name: messages.remote.name,
            description: messages.remote.description,
            control: _CheckBox(
              isChecked: config.isRemoteOnly,
              onChange: (value) => bloc.add(ChangeRemote(isRemoteOnly: value)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String name;
  final String description;
  final Widget control;

  const _OptionCard({
    required this.name,
    required this.description,
    required this.control,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text(name),
        subtitle: Text(description),
        trailing: control,
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  final bool isChecked;
  final void Function(bool) onChange;

  const _CheckBox({required this.isChecked, required this.onChange}) : super();

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) => onChange(value!),
    );
  }
}

class _NumberBox extends StatefulWidget {
  final int value;
  final void Function(int?) onChange;

  const _NumberBox({required this.value, required this.onChange}) : super();

  @override
  _NumberBoxState createState() => _NumberBoxState();
}

class _NumberBoxState extends State<_NumberBox> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.toString());
    controller.addListener(() {
      final value = controller.text;
      if (value.isEmpty) {
        widget.onChange(null);
      } else {
        widget.onChange(int.parse(value));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.deny(RegExp('^0')),
        ],
        decoration: InputDecoration(
          hintText: widget.value.toString(),
        ),
        controller: controller,
      ),
    );
  }
}
