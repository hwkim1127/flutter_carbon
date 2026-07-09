import 'package:flutter/widgets.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native Carbon text input components.
///
/// Material `TextField` styling through the bridge
/// (`CarbonInputDecorationHelper`) is demonstrated on the Material widgets
/// page instead.
class TextInputDemoPage extends StatefulWidget {
  const TextInputDemoPage({super.key});

  @override
  State<TextInputDemoPage> createState() => _TextInputDemoPageState();
}

class _TextInputDemoPageState extends State<TextInputDemoPage> {
  final _usernameController = TextEditingController();
  final _readOnlyController = TextEditingController(
    text: 'You can select me, not edit me',
  );
  final _areaController = TextEditingController();
  bool _usernameInvalid = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _readOnlyController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Text Input',
      description:
          'Native Carbon text inputs — no Material dependency. Selection, '
          'context menu (long-press or right-click), and keyboard shortcuts '
          'are Carbon-styled.',
      sections: [
        DemoSection(
          title: 'Default',
          description: 'Label, placeholder, and helper text',
          builder: (context) => const CarbonTextInput(
            labelText: 'Label',
            placeholder: 'Placeholder text',
            helperText: 'Helper text for additional guidance',
          ),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'xs (24px), sm (32px), md (40px, default), lg (48px)',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in CarbonTextInputSize.values) ...[
                CarbonTextInput(
                  labelText: 'Size ${size.name}',
                  placeholder: '${size.height.toInt()}px',
                  size: size,
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'States',
          description: 'Invalid, warning, disabled, and read-only',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonTextInput(
                labelText: 'Invalid',
                placeholder: 'Placeholder',
                invalid: true,
                invalidText: 'A valid value is required',
              ),
              const SizedBox(height: 16),
              const CarbonTextInput(
                labelText: 'Warning',
                placeholder: 'Placeholder',
                warn: true,
                warnText: 'This will overwrite existing data',
              ),
              const SizedBox(height: 16),
              const CarbonTextInput(
                labelText: 'Disabled',
                placeholder: 'Cannot type here',
                disabled: true,
                helperText: 'Disabled helper text',
              ),
              const SizedBox(height: 16),
              CarbonTextInput(
                labelText: 'Read-only',
                readOnly: true,
                controller: _readOnlyController,
                helperText: 'Focusable and selectable, but not editable',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Live validation',
          description: 'invalid driven by onChanged',
          builder: (context) => CarbonTextInput(
            labelText: 'User name',
            placeholder: 'lowercase letters only',
            controller: _usernameController,
            invalid: _usernameInvalid,
            invalidText: 'Only lowercase letters are allowed',
            helperText: 'Try typing an uppercase letter',
            onChanged: (value) => setState(() {
              _usernameInvalid =
                  value.isNotEmpty && !RegExp(r'^[a-z]+$').hasMatch(value);
            }),
          ),
        ),
        DemoSection(
          title: 'Hidden label',
          description: 'Visually hidden, still announced by screen readers',
          builder: (context) => const CarbonTextInput(
            labelText: 'Search terms',
            hideLabel: true,
            placeholder: 'Label is in semantics only',
          ),
        ),
        DemoSection(
          title: 'Password',
          description:
              'obscureText (the visibility toggle is a planned feature)',
          builder: (context) => const CarbonTextInput(
            labelText: 'Password',
            placeholder: 'Enter password',
            obscureText: true,
            helperText: 'Input is obscured; copy is disabled',
          ),
        ),
        DemoSection(
          title: 'Max length',
          description: 'maxLength enforces a character limit',
          builder: (context) => const CarbonTextInput(
            labelText: 'Code',
            placeholder: 'Max 6 characters',
            maxLength: 6,
          ),
        ),
        DemoSection(
          title: 'Text Area',
          description: 'Multi-line input, grows with content',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonTextArea(
                labelText: 'Notes',
                placeholder: 'Type multiple lines…',
                helperText: 'Grows from 4 lines with content',
                controller: _areaController,
              ),
              const SizedBox(height: 16),
              const CarbonTextArea(
                labelText: 'Invalid text area',
                minLines: 3,
                invalid: true,
                invalidText: 'This field is required',
              ),
              const SizedBox(height: 16),
              const CarbonTextArea(
                labelText: 'Disabled text area',
                minLines: 3,
                disabled: true,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Localized selection menu',
          description: 'CarbonTextSelectionLabels overrides the context menu',
          builder: (context) => const CarbonTextInput(
            labelText: '한국어 메뉴',
            placeholder: '텍스트를 선택해 보세요',
            selectionLabels: CarbonTextSelectionLabels(
              cut: '잘라내기',
              copy: '복사',
              paste: '붙여넣기',
              selectAll: '전체 선택',
            ),
          ),
        ),
      ],
    );
  }
}
