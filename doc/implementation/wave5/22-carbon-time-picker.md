# Step 22 — CarbonTimePicker + CarbonTimePickerSelect

## Goal

Native time picker per the Carbon spec: a masked `hh:mm` text input plus
consumer-supplied compact selects (AM/PM, timezone) in a row — NOT a
clock dial.

## Spec digest (Carbon v11.96, rem→px@16)

- Input: width 78 (98.8 when invalid/warn), `code-02` type, heights
  sm 32 / md 40 / lg 48 (default md), bg `$field`, 1px bottom
  `$border-strong`, maxLength 5, placeholder `hh:mm`, status icon at
  inset-end 16; the label sits above the whole row.
- Default 12-hour validation pattern `(1[012]|[1-9]):[0-5][0-9]` —
  validation is consumer-driven (the component only exposes
  invalid/invalidText), matching React.
- TimePickerSelect: Select-styled, label-less (a11y label only), auto
  width, 2px gap from the input; the consumer supplies the options
  (AM/PM etc. are not built in).
- readOnly: transparent bg, `$border-subtle` bottom; selects refuse to
  open.

## API

```dart
enum CarbonTimePickerSize { sm(32), md(40), lg(48) }

class CarbonTimePicker {
  /// Convenience 12-hour matcher (spec default pattern).
  static final RegExp time12h = RegExp(r'^(1[012]|[1-9]):[0-5][0-9]$');

  CarbonTimePicker({
    required String labelText,
    bool hideLabel = false,
    String? value,                       // string model, React parity
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    String placeholder = 'hh:mm',
    String? helperText,
    bool invalid = false, String? invalidText,
    bool warn = false, String? warnText,
    bool disabled = false, bool readOnly = false,
    CarbonTimePickerSize size = md,
    int maxLength = 5,
    List<TextInputFormatter>? inputFormatters, // default: allow [\d:]
    CarbonTextSelectionLabels? selectionLabels,
    List<Widget> selects = const [],     // trailing CarbonTimePickerSelect(s)
    double? width,                       // default 78 / 98.8 invalid-warn
  })
}

class CarbonTimePickerSelect<T> {
  CarbonTimePickerSelect({
    required String labelText,           // a11y only — always hidden
    required List<CarbonSelectItem<T>> items,
    required T? value,
    ValueChanged<T?>? onChanged,
    bool disabled = false, bool readOnly = false,
    CarbonSelectSize size = md,
    double? width,
  })
}
```

## Implementation notes

- String value model: React's TimePicker is a plain masked field with
  consumer validation; a typed time model would force a parsing policy
  (`TimeOfDay` is Material and unusable). `time12h` ships as a
  convenience matcher only.
- Layout: label (label01, 8px gap) above; `Row(crossAxisAlignment: end)`
  of the input field then each select with a 2px gap; status text below
  the row. Field chrome is the private `_FieldChrome`-pattern copy.
- `CarbonTimePickerSelect` is a thin stateless wrapper over
  `CarbonSelect(hideLabel: true)` with no helper/status texts — verified
  that CarbonSelect renders as the bare field then. Verify intrinsic
  width inside a Row at implementation time (fallback: `IntrinsicWidth`).
- Precedence readOnly > disabled > invalid > warn; readOnly swallows
  value keys per convention.

## Tests

`test/widgets/carbon_time_picker_test.dart`:

- Formatter blocks letters (`enterText('ab1:2c3')` → `1:23`); maxLength 5.
- `onChanged` fires with the raw string; `time12h` accepts `12:30`,
  rejects `13:00` and `1:60`.
- invalid → width 98.8 + warningFilled + invalidText in textError;
  warn → warningAltFilled.
- readOnly swallows arrows/space (focus retained); disabled not
  focusable.
- Row with `selects: [AM/PM, timezone]` — select opens, picks PM,
  onChanged fires; the wrapper renders no label or status text.
- Sizes heights; pure-CarbonApp smoke.

## Example

Time picker section of the demo page: input + AM/PM select + timezone
select; an invalid state example.
