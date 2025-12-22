import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Carbon text input components.
class TextInputDemoPage extends StatefulWidget {
  const TextInputDemoPage({super.key});

  @override
  State<TextInputDemoPage> createState() => _TextInputDemoPageState();
}

class _TextInputDemoPageState extends State<TextInputDemoPage> {
  final _textController = TextEditingController();
  final _passwordController = TextEditingController();
  final _multilineController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorText;

  @override
  void dispose() {
    _textController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Text Input',
      description:
          'Text input fields for user data entry with Carbon Design System styling.',
      sections: [
        DemoSection(
          title: 'Basic Text Input',
          description: 'Standard text input field',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Label',
                  hintText: 'Placeholder text',
                  helperText: 'Helper text for additional guidance',
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Input Variants',
          description: 'Filled and outlined input styles',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Filled input',
                  hintText: 'Enter text',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: CarbonInputDecorationHelper.outlined(
                  context: context,
                  labelText: 'Outlined input',
                  hintText: 'Enter text',
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Input States',
          description:
              'Different states including error, warning, and disabled',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Normal state',
                  hintText: 'Enter text',
                  helperText: 'This is a normal input field',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Error state',
                  hintText: 'Enter text',
                  errorText: 'This field has an error',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Warning state',
                  hintText: 'Enter text',
                  helperText: 'Warning: This action cannot be undone',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                enabled: false,
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Disabled state',
                  hintText: 'Cannot edit this field',
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Password Input',
          description: 'Password field with show/hide toggle',
          builder: (context) => TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: CarbonInputDecorationHelper.filled(
              context: context,
              labelText: 'Password',
              hintText: 'Enter your password',
              helperText: 'Password must be at least 8 characters',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Multiline Text Area',
          description: 'Text area for longer content',
          builder: (context) => TextField(
            controller: _multilineController,
            maxLines: 4,
            decoration: CarbonInputDecorationHelper.filled(
              context: context,
              labelText: 'Description',
              hintText: 'Enter a detailed description...',
              helperText: 'Maximum 500 characters',
            ),
          ),
        ),
        DemoSection(
          title: 'Validation Example',
          description: 'Input with validation logic',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _errorText = 'This field is required';
                    } else if (value.length < 3) {
                      _errorText = 'Must be at least 3 characters';
                    } else {
                      _errorText = null;
                    }
                  });
                },
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Username',
                  hintText: 'Enter username',
                  helperText: _errorText == null
                      ? 'Choose a unique username'
                      : null,
                  errorText: _errorText,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _errorText == null && _textController.text.isNotEmpty
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Username "${_textController.text}" is valid!',
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Input with Icons',
          description: 'Text inputs with prefix and suffix icons',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: CarbonInputDecorationHelper.filled(
                  context: context,
                  labelText: 'Search',
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Read-only Input',
          description: 'Non-editable input field',
          builder: (context) => TextField(
            readOnly: true,
            decoration: CarbonInputDecorationHelper.filled(
              context: context,
              labelText: 'Read-only field',
              hintText: 'This value cannot be changed',
            ),
            controller: TextEditingController(text: 'Fixed value'),
          ),
        ),
      ],
    );
  }
}
