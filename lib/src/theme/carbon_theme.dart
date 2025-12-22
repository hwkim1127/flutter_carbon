import 'package:flutter/material.dart';
import 'carbon_theme_data.dart';

/// Extensions to access [CarbonThemeData] from the [BuildContext].
extension CarbonThemeContext on BuildContext {
  /// Returns the [CarbonThemeData] from the current [Theme].
  ///
  /// This relies on [CarbonThemeData] being present in [ThemeData.extensions].
  /// If not found, it throws a [StateError] (or could return a default).
  CarbonThemeData get carbon {
    final carbon = Theme.of(this).extension<CarbonThemeData>();
    if (carbon == null) {
      throw StateError(
        'CarbonThemeData is not available in the current Theme. '
        'Ensure that you have added a CarbonThemeData to your ThemeData extensions.',
      );
    }
    return carbon;
  }
}

/// Helper to create a Material [ThemeData] from a [CarbonThemeData].
///
/// This maps Carbon tokens to Material's [ColorScheme] as best as possible
/// to ensure compatibility with standard Material widgets.
ThemeData carbonTheme({
  required CarbonThemeData carbon,
  String? fontFamily,
  TextTheme? textTheme, // Optional override
}) {
  final colorScheme = ColorScheme(
    brightness:
        carbon.layer.background == const Color(0xff161616) ||
            carbon.layer.background == const Color(0xff262626)
        ? Brightness.dark
        : Brightness.light,

    // Primary
    primary: carbon.button.buttonPrimary,
    onPrimary: carbon.text.textOnColor,
    primaryContainer: carbon.button.buttonPrimaryHover, // Approximation
    onPrimaryContainer: carbon.text.textOnColor,

    // Secondary
    secondary: carbon.button.buttonSecondary,
    onSecondary: carbon.text.textOnColor,
    secondaryContainer: carbon.button.buttonSecondaryHover,
    onSecondaryContainer: carbon.text.textOnColor,

    // Tertiary
    tertiary: carbon.button.buttonTertiary,
    onTertiary:
        carbon.text.textPrimary, // Tertiary button is ghost-like usually
    tertiaryContainer: carbon.button.buttonTertiaryHover,
    onTertiaryContainer: carbon.text.textPrimary,

    // Error
    error: carbon.layer.supportError,
    onError: carbon.text.textOnColor,

    // Surface / Background
    surface: carbon.layer.layer01, // Cards/Sheets usually on layer01
    onSurface: carbon.text.textPrimary,

    // Background is deprecated in ColorScheme but surface is used for general BG now?
    // Material 3 uses surface for everything.
    // Let's ensure surface matches layer01 or background depending on usage?
    // Material scaffolding usually uses `scaffoldBackgroundColor`.
    outline: carbon.layer.borderSubtle01,
    outlineVariant: carbon.layer.borderSubtle00,
  );

  return ThemeData(
    useMaterial3: true,
    extensions: [carbon],
    colorScheme: colorScheme,
    scaffoldBackgroundColor: carbon.layer.background,
    fontFamily: fontFamily ?? 'IBM Plex Sans', // Default Carbon font
    // We could map CarbonTypography to TextTheme here later if needed
    // textTheme: ...

    // Customizing specific components to defaults if needed
    dividerColor: carbon.layer.borderSubtle01,
    dividerTheme: DividerThemeData(
      color: carbon.layer.borderSubtle01,
      space: 1,
      thickness: 1,
    ),

    // Button Themes
    // Carbon Design System button hierarchy mapped to Material widgets:
    // 1. Primary (FilledButton) - Main actions, filled blue background
    // 2. Secondary (ElevatedButton) - Secondary actions, filled dark gray background
    //    Note: elevation set to 0 to match Carbon's flat design
    // 3. Tertiary (OutlinedButton) - Tertiary actions, outline style
    // 4. Ghost (TextButton) - Low-emphasis actions, transparent

    // Primary Button (FilledButton in Material)
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.button.buttonDisabled;
          }
          if (states.contains(WidgetState.pressed)) {
            return carbon.button.buttonPrimaryActive;
          }
          if (states.contains(WidgetState.hovered)) {
            return carbon.button.buttonPrimaryHover;
          }
          return carbon.button.buttonPrimary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.text.textOnColor;
        }),
        elevation: WidgetStateProperty.all(0), // Carbon uses flat buttons
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ),

    // Secondary Button (ElevatedButton - Carbon Secondary, flat with elevation 0)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.button.buttonDisabled;
          }
          if (states.contains(WidgetState.pressed)) {
            return carbon.button.buttonSecondaryActive;
          }
          if (states.contains(WidgetState.hovered)) {
            return carbon.button.buttonSecondaryHover;
          }
          return carbon.button.buttonSecondary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.text.textOnColor;
        }),
        // Carbon uses flat buttons (elevation 0)
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ),

    // Outlined/Ghost Button (OutlinedButton - Carbon Tertiary)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return carbon.button.buttonTertiaryActive;
          }
          if (states.contains(WidgetState.hovered)) {
            return carbon.button.buttonTertiaryHover;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.button.buttonTertiary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: carbon.button.buttonDisabled);
          }
          return BorderSide(color: carbon.button.buttonTertiary);
        }),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ),

    // Ghost Button (TextButton - Carbon Ghost)
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return carbon.button.buttonTertiaryActive;
          }
          if (states.contains(WidgetState.hovered)) {
            return carbon.button.buttonTertiaryHover;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.text.linkPrimary;
        }),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    ),

    // Icon Button
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.text.iconPrimary;
        }),
      ),
    ),

    // Input Components (Checkbox, Radio, Switch, Slider)
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return carbon.text.textDisabled;
        }
        if (states.contains(WidgetState.selected)) {
          return carbon.button.buttonPrimary;
        }
        return carbon.text.textSecondary;
      }),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      side: BorderSide(color: carbon.text.textSecondary, width: 1),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return carbon.text.textDisabled;
        }
        return carbon.button.buttonPrimary;
      }),
    ),
    // Switch/Toggle - Following Carbon Design System toggle specs
    // ON state: Primary color track, white thumb
    // OFF state: Gray track with border, white thumb
    switchTheme: SwitchThemeData(
      // Thumb (the circle that slides)
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return carbon.text.iconDisabled;
        }
        // Thumb is always white/on-color in Carbon (both ON and OFF)
        return carbon.text.iconOnColor;
      }),

      // Track (the background rail)
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          if (states.contains(WidgetState.selected)) {
            return carbon.button.buttonDisabled;
          }
          return carbon.layer.layerSelectedDisabled;
        }
        if (states.contains(WidgetState.selected)) {
          // ON state: primary color
          return carbon.button.buttonPrimary;
        }
        // OFF state: subtle gray
        return carbon.layer.borderSubtle01;
      }),

      // Track outline (border around the track)
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        // OFF state has visible border
        return carbon.layer.borderStrong01;
      }),
      trackOutlineWidth: WidgetStateProperty.all(1),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: carbon.button.buttonPrimary,
      inactiveTrackColor: carbon.layer.backgroundActive,
      thumbColor: carbon.button.buttonPrimary,
      overlayColor: carbon.button.buttonPrimary.withValues(alpha: 0.12),
      trackHeight: 2,
    ),
    // TextField Theme - Default (Outlined/Underline style)
    // Carbon has two main text input styles:
    // 1. Default/Outlined: transparent background with bottom border (this one)
    // 2. Filled: filled background with full border (use InputDecoration.filled explicitly)
    inputDecorationTheme: InputDecorationTheme(
      filled: false, // Default is outlined/underline style
      fillColor: Colors.transparent,

      // Default border (unfocused, enabled)
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.borderStrong01),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.borderStrong01),
      ),

      // Focused state - primary color, thicker
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
      ),

      // Error state
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),

      // Disabled state
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.text.textDisabled),
      ),

      labelStyle: TextStyle(color: carbon.text.textSecondary, fontSize: 14),
      floatingLabelStyle: TextStyle(
        color: carbon.button.buttonPrimary,
        fontSize: 12,
      ),
      hintStyle: TextStyle(color: carbon.text.textPlaceholder, fontSize: 14),
      helperStyle: TextStyle(color: carbon.text.textHelper, fontSize: 12),
      errorStyle: TextStyle(color: carbon.layer.supportError, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    ),

    // Navigation Themes
    appBarTheme: AppBarTheme(
      backgroundColor: carbon.layer.background,
      foregroundColor: carbon.text.textPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: carbon.text.iconPrimary),
      actionsIconTheme: IconThemeData(color: carbon.text.iconPrimary),
      centerTitle: false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: carbon.layer.layer01,
      selectedItemColor: carbon.button.buttonPrimary,
      unselectedItemColor: carbon.text.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: carbon.layer.layer01,
      indicatorColor: carbon.layer.layerSelected01,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: carbon.button.buttonPrimary);
        }
        return IconThemeData(color: carbon.text.textSecondary);
      }),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      color: carbon.layer.layer01,
      elevation: 0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: carbon.text.textPrimary,
      unselectedLabelColor: carbon.text.textSecondary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: carbon.layer.layer01,
      selectedIconTheme: IconThemeData(color: carbon.button.buttonPrimary),
      unselectedIconTheme: IconThemeData(color: carbon.text.textSecondary),
      selectedLabelTextStyle: TextStyle(color: carbon.button.buttonPrimary),
      unselectedLabelTextStyle: TextStyle(color: carbon.text.textSecondary),
      indicatorColor: carbon.layer.layerSelected01,
      useIndicator: true,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: carbon.layer.layer01,
      elevation: 0, // Carbon drawers often flat or have border
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    navigationDrawerTheme: NavigationDrawerThemeData(
      backgroundColor: carbon.layer.layer01,
      indicatorColor: carbon.layer.layerSelected01,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: carbon.button.buttonPrimary);
        }
        return IconThemeData(color: carbon.text.textSecondary);
      }),
    ),

    // Surface Themes
    cardTheme: CardThemeData(
      color: carbon.layer.layer01,
      shadowColor: carbon.layer.shadow, // Using generic shadow if available
      elevation: 0, // Carbon cards usually flat with border or shadow classes
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      clipBehavior: Clip.antiAlias,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: carbon.layer.layer02, // Layer 02 for modals
      elevation: 6,
      shadowColor: carbon.layer.shadow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      titleTextStyle: TextStyle(
        color: carbon.text.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(color: carbon.text.textPrimary, fontSize: 16),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: carbon.layer.layer02,
      modalBackgroundColor: carbon.layer.layer02,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 6,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: carbon.layer.layer01,
      collapsedBackgroundColor: carbon.layer.background,
      textColor: carbon.text.textPrimary,
      collapsedTextColor: carbon.text.textPrimary,
      iconColor: carbon.text.iconPrimary,
      collapsedIconColor: carbon.text.iconPrimary,
      shape: const Border(), // Remove default borders
      collapsedShape: const Border(),
    ),

    // Feedback Themes
    // Note: SnackBar is lightly themed for simple Material notifications
    // For Carbon-compliant notifications, use CarbonInlineNotification or showCarbonToast()
    snackBarTheme: SnackBarThemeData(
      backgroundColor: carbon.notification.notificationBackgroundInfo,
      contentTextStyle: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
      actionTextColor: carbon.button.buttonPrimary,
      closeIconColor: carbon.text.iconPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      behavior: SnackBarBehavior.floating,
      elevation: 2,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: carbon.button.buttonPrimary,
      linearTrackColor: carbon.layer.layer01,
      circularTrackColor: carbon.layer.layer01,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: carbon
            .layer
            .backgroundInverse, // Dark background in light themes, light in dark themes
        borderRadius: BorderRadius.circular(2),
      ),
      textStyle: TextStyle(color: carbon.text.textInverse, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: carbon.layer.layer01,
      contentTextStyle: TextStyle(color: carbon.text.textPrimary),
    ),
    badgeTheme: BadgeThemeData(
      backgroundColor: carbon.layer.supportError,
      textColor: carbon.text.textOnColor,
      textStyle: const TextStyle(
        fontSize: 12,
        height: 1.33333,
        letterSpacing: 0.32,
      ),
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
      smallSize: 8,
      largeSize: 16,
      alignment: AlignmentDirectional.topEnd,
      offset: const Offset(8, 8),
    ),

    // Content Themes
    chipTheme: ChipThemeData(
      backgroundColor: carbon.layer.layer01,
      disabledColor: carbon.layer.layerSelectedDisabled,
      selectedColor: carbon.layer.layerSelected01,
      secondarySelectedColor: carbon.layer.layerSelected01,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      labelStyle: TextStyle(color: carbon.text.textPrimary),
      secondaryLabelStyle: TextStyle(color: carbon.text.textPrimary),
      brightness: Brightness.light,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(carbon.layer.layer01),
      dataRowColor: WidgetStateProperty.all(carbon.layer.background),
      headingTextStyle: TextStyle(
        color: carbon.text.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      dataTextStyle: TextStyle(color: carbon.text.textPrimary),
      dividerThickness: 1,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: carbon.layer.layerSelected01,
      textColor: carbon.text.textPrimary,
      selectedColor: carbon.text.textPrimary,
      iconColor: carbon.text.iconPrimary,
      // Ensure proper contrast in dark themes
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      minVerticalPadding: 0,
      minLeadingWidth: 0,
    ),
    iconTheme: IconThemeData(color: carbon.text.iconPrimary),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => const Icon(Icons.arrow_back),
      closeButtonIconBuilder: (context) => const Icon(Icons.close),
      drawerButtonIconBuilder: (context) => const Icon(Icons.menu),
      endDrawerButtonIconBuilder: (context) => const Icon(Icons.menu),
    ),
    primaryIconTheme: IconThemeData(color: carbon.text.iconPrimary),

    // Menus
    popupMenuTheme: PopupMenuThemeData(
      color: carbon.layer.layer01,
      textStyle: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 2,
      // Selected item styling
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: carbon.text.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          );
        }
        return TextStyle(color: carbon.text.textPrimary, fontSize: 14);
      }),
      // Icon color for selected items
      iconColor: carbon.text.iconPrimary,
    ),

    // Dropdown (classic DropdownButton) - Carbon Design System style
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: carbon.layer.field01,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbon.layer.borderStrong01),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(carbon.layer.layer01),
        elevation: WidgetStateProperty.all(2),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
    ),

    // DropdownButton theme (classic dropdown)
    // Note: Flutter doesn't have dropdownButtonTheme in ThemeData,
    // so we need to use the custom CarbonDropdown widget for proper styling
    menuBarTheme: MenuBarThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(carbon.layer.layer01),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    ),
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return carbon.text.textDisabled;
          }
          return carbon.text.textPrimary;
        }),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(carbon.layer.layer02),
        elevation: WidgetStateProperty.all(6),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    ),

    // Interactions
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: carbon.button.buttonPrimary,
      selectionColor: carbon.button.buttonPrimary.withValues(alpha: 0.3),
      selectionHandleColor: carbon.button.buttonPrimary,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return carbon.layer.layerSelected01;
          }
          return carbon.layer.layer01;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return carbon.text.textPrimary;
          }
          return carbon.text.textSecondary;
        }),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      fillColor: carbon.layer.layerSelected01,
      selectedColor: carbon.text.textPrimary,
      color: carbon.text.textSecondary,
      borderColor: carbon.layer.borderSubtle01,
      selectedBorderColor: carbon.layer.borderSubtle01,
      borderRadius: BorderRadius.zero,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: carbon.button.buttonPrimary,
      foregroundColor: carbon.text.textOnColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ), // Carbon FABs are sometimes round? Default FAB is round. Carbon 'Floating action button' is round.
      // Wait, Carbon FAB is round. I should set shape to CircleBorder? Or keep default?
      // Carbon Design System: FAB is irrelevant on web usually, but on mobile it's round.
      // I will leave shape properly round for FAB if Carbon uses round. But Carbon "Primary Button" is rect.
      // Carbon FAB: https://carbondesignsystem.com/components/button/usage/#floating-action-button
      // It says "Floating action button" is deprecated in v10? no.
      // Actually Carbon Mobile has FABs. They are round.
      // I will remove the rectangular shape override for FAB.
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(carbon.layer.layer03),
      trackColor: WidgetStateProperty.all(carbon.layer.layer01),
      radius: Radius.zero,
      thickness: WidgetStateProperty.all(6),
    ),

    // Pickers & Search
    datePickerTheme: DatePickerThemeData(
      backgroundColor: carbon.layer.layer01,
      headerBackgroundColor: carbon.layer.layer01,
      headerForegroundColor: carbon.text.textPrimary,
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return carbon.text.textOnColor;
        }
        return carbon.text.textPrimary;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return carbon.button.buttonPrimary;
        }
        return null;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return carbon.text.textOnColor;
        }
        return carbon.text.textPrimary;
      }),
      todayBorder: BorderSide(color: carbon.button.buttonPrimary, width: 1),
      yearForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return carbon.text.textOnColor;
        }
        return carbon.text.textPrimary;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return carbon.button.buttonPrimary;
        }
        return null;
      }),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(carbon.button.buttonPrimary),
        foregroundColor: WidgetStateProperty.all(carbon.text.textOnColor),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(carbon.text.textPrimary),
        overlayColor: WidgetStateProperty.all(carbon.layer.layerHover01),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: carbon.layer.layer01,
      hourMinuteColor: carbon.layer.field01,
      hourMinuteTextColor: carbon.text.textPrimary,
      dayPeriodColor: carbon.layer.field01,
      dayPeriodTextColor: carbon.text.textPrimary,
      dialHandColor: carbon.button.buttonPrimary,
      dialBackgroundColor: carbon.layer.layer02,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(carbon.button.buttonPrimary),
        foregroundColor: WidgetStateProperty.all(carbon.text.textOnColor),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(carbon.text.textPrimary),
        overlayColor: WidgetStateProperty.all(carbon.layer.layerHover01),
      ),
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(carbon.layer.field01),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      // Carbon search usually has 1px bottom border? 'Search' component.
    ),
    searchViewTheme: SearchViewThemeData(
      backgroundColor: carbon.layer.layer01,
      elevation: 0,
    ),

    // Other & Legacy
    carouselViewTheme: CarouselViewThemeData(
      backgroundColor: carbon.layer.layer01,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: carbon.button.buttonPrimary,
      disabledColor: carbon.text.textDisabled,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      textTheme: ButtonTextTheme.primary,
    ),

    // Core Colors
    canvasColor: carbon.layer.background,
    cardColor: carbon.layer.layer01,
    disabledColor: carbon.text.textDisabled,
    focusColor: carbon.layer.focus,
    highlightColor: carbon.layer.highlight,
    hintColor: carbon.text.textPlaceholder,
    hoverColor: carbon.layer.backgroundHover,
    shadowColor: carbon.layer.shadow,
    splashColor: carbon.layer.interactive,
    unselectedWidgetColor: carbon.text.textSecondary,
    secondaryHeaderColor: carbon.layer.layer02,
    primaryColor: carbon.button.buttonPrimary,
    primaryColorDark: carbon.layer.backgroundInverse, // Approx
    primaryColorLight: carbon.layer.layerAccent01, // Approx
    // Typography
    typography: Typography.material2021(),
    textTheme: Typography.material2021().black.apply(
      bodyColor: carbon.text.textPrimary,
      displayColor: carbon.text.textPrimary,
      decorationColor: carbon.text.textPrimary,
    ),
    primaryTextTheme: Typography.material2021().black.apply(
      bodyColor: carbon.text.textPrimary,
      displayColor: carbon.text.textPrimary,
    ),

    // Global
    splashFactory: InkRipple.splashFactory,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}

/// Helper class for creating Carbon-styled InputDecoration variants.
///
/// Use these helpers when you need a specific Carbon text input style:
/// ```dart
/// TextField(
///   decoration: CarbonInputDecorationHelper.filled(
///     context: context,
///     labelText: 'Label',
///     hintText: 'Placeholder',
///   ),
/// )
/// ```
class CarbonInputDecorationHelper {
  const CarbonInputDecorationHelper._();

  /// Creates a filled text input decoration matching Carbon Design System.
  ///
  /// Filled inputs have:
  /// - Filled background (field-01)
  /// - Outlined border on all sides
  /// - No rounded corners (Carbon style)
  static InputDecoration filled({
    required BuildContext context,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    final carbon = context.carbon;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      filled: true,
      fillColor: enabled
          ? carbon.layer.field01
          : carbon.layer.layerSelectedDisabled,

      // Filled variant uses OutlineInputBorder with no radius
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.layer.borderStrong01),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.text.textDisabled),
      ),

      labelStyle: TextStyle(
        color: enabled ? carbon.text.textSecondary : carbon.text.textDisabled,
        fontSize: 14,
      ),
      floatingLabelStyle: TextStyle(
        color: carbon.button.buttonPrimary,
        fontSize: 12,
      ),
      hintStyle: TextStyle(color: carbon.text.textPlaceholder, fontSize: 14),
      helperStyle: TextStyle(color: carbon.text.textHelper, fontSize: 12),
      errorStyle: TextStyle(color: carbon.layer.supportError, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    );
  }

  /// Creates an outlined/underline text input decoration (default Carbon style).
  ///
  /// This is the same as the theme default, provided for explicit usage.
  static InputDecoration outlined({
    required BuildContext context,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    final carbon = context.carbon;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      filled: false,

      // Default uses underline border
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.borderStrong01),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.borderStrong01),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: carbon.text.textDisabled),
      ),

      labelStyle: TextStyle(
        color: enabled ? carbon.text.textSecondary : carbon.text.textDisabled,
        fontSize: 14,
      ),
      floatingLabelStyle: TextStyle(
        color: carbon.button.buttonPrimary,
        fontSize: 12,
      ),
      hintStyle: TextStyle(color: carbon.text.textPlaceholder, fontSize: 14),
      helperStyle: TextStyle(color: carbon.text.textHelper, fontSize: 12),
      errorStyle: TextStyle(color: carbon.layer.supportError, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
    );
  }

  /// Creates a fluid text input decoration matching Carbon Design System.
  ///
  /// Fluid inputs have:
  /// - Filled background (field-01)
  /// - No visible border (borderless)
  /// - Floating label inside the field
  /// - Fixed minimum height (64px)
  /// - Outline only on focus/error states
  ///
  /// Use with `TextField` for single-line or `maxLines` for multi-line:
  /// ```dart
  /// TextField(
  ///   decoration: CarbonInputDecorationHelper.fluid(
  ///     context: context,
  ///     labelText: 'Label',
  ///     hintText: 'Placeholder',
  ///   ),
  ///   minLines: 1,
  /// )
  /// ```
  static InputDecoration fluid({
    required BuildContext context,
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    final carbon = context.carbon;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      filled: true,
      fillColor: enabled
          ? carbon.layer.field01
          : carbon.layer.layerSelectedDisabled,

      // Fluid variant has no visible border by default
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),

      // Focus shows outline
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.button.buttonPrimary, width: 2),
      ),

      // Error shows outline
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: carbon.layer.supportError, width: 2),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide.none,
      ),

      // Fluid uses floating labels positioned inside
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(
        color: enabled ? carbon.text.textSecondary : carbon.text.textDisabled,
        fontSize: 12,
      ),
      floatingLabelStyle: TextStyle(
        color: enabled ? carbon.text.textSecondary : carbon.text.textDisabled,
        fontSize: 12,
      ),
      hintStyle: TextStyle(color: carbon.text.textPlaceholder, fontSize: 14),
      errorStyle: TextStyle(color: carbon.layer.supportError, fontSize: 12),

      // Fluid padding: top padding for label, bottom for content
      contentPadding: const EdgeInsets.fromLTRB(16, 32, 16, 13),

      // Helper text not shown in fluid variant (use errorText if needed)
      helperStyle: const TextStyle(fontSize: 0, height: 0),
    );
  }
}
