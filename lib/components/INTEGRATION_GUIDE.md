# Integration Guide: Updating to Default Theme System

This guide shows how to integrate the new default theme system into your existing login implementation.

## Step 1: Initialize Default Themes

Add this to your app initialization (e.g., in `main.dart`):

```dart
import 'package:pulsedesk/components/common/app_theme_manager.dart';

void main() {
  // Set up default theme on app start
  AppThemeManager.initializeComponentThemes(ThemeMode.system);
  
  runApp(MyApp());
}
```

## Step 2: Update Your Login View Model (Optional)

If you want to customize styling or data from your view model:

```dart
// In your LoginViewModel
class LoginViewModel extends ChangeNotifier {
  // ... existing code ...

  void setupCustomStyling() {
    final di = LoginComponentDI();
    
    // Example: Customize error banner for your backend
    di.setOverrides(
      errorBannerStyle: const ErrorBannerStyleModel(
        backgroundColor: Color(0xFFFFF8E1), // Light amber
        borderColor: Color(0xFFFFB300),     // Amber
        iconColor: Color(0xFFE65100),       // Dark orange
        textColor: Color(0xFFE65100),
      ),
    );
  }

  @override
  void dispose() {
    // Clear overrides when view model is disposed
    LoginComponentDI().clearOverrides();
    super.dispose();
  }
}
```

## Step 3: Your Current Login View Works As-Is!

Your existing [login_view.dart](../Auth/login_view.dart) already uses `LoginScreenContainer`, so it will automatically get:

✅ **Default themes** - Standard, dark, compact themes available  
✅ **Override support** - Your view model can customize any aspect  
✅ **Component separation** - Each UI element is a reusable component  
✅ **Theme switching** - Runtime theme changes supported  

## Step 4: Optional - Add Theme Switching

Add theme switching controls to your login screen:

```dart
// In your LoginView widget
AppBar(
  title: const Text('Login'),
  actions: [
    PopupMenuButton<String>(
      onSelected: (theme) {
        final di = LoginComponentDI();
        switch (theme) {
          case 'light':
            di.setTheme(LoginThemeType.standard);
            break;
          case 'dark':
            di.setTheme(LoginThemeType.dark);
            break;
          case 'compact':
            di.setTheme(LoginThemeType.compact);
            break;
        }
        setState(() {}); // Trigger rebuild
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'light', child: Text('Light Theme')),
        const PopupMenuItem(value: 'dark', child: Text('Dark Theme')), 
        const PopupMenuItem(value: 'compact', child: Text('Compact Theme')),
      ],
    ),
  ],
),
```

## Step 5: Customize for Your Brand (Optional)

Override default colors to match your brand:

```dart
// In main.dart or app initialization
AppThemeManager.setupBrandedTheme(
  primaryColor: const Color(0xFF6200EA), // Your brand color
  errorColor: const Color(0xFFD32F2F),   // Your error color
  borderRadius: 8,                        // Your preferred radius
);
```

## What You Get Out of the Box

### 🎨 3 Default Themes
- **Standard**: Default light theme with standard sizing
- **Dark**: Dark backgrounds with light text  
- **Compact**: Smaller components for dense layouts

### 📱 Responsive Behavior
- **Adaptive theming**: Components adjust based on device size
- **Accessibility**: High contrast and minimal themes available

### ⚙️ Override System
- **Data overrides**: Custom text, states, callbacks from view model
- **Style overrides**: Custom colors, sizes, spacing from view model  
- **Priority system**: View model > props > theme defaults

### 🔧 Zero Breaking Changes
Your existing login implementation continues to work exactly the same, but now has access to the full theming and customization system!

## Testing the Integration

Run your app and verify:

1. ✅ Login screen appears with default styling
2. ✅ Error messages use themed error banner
3. ✅ Form fields use themed styling  
4. ✅ Button shows loading state with themed spinner
5. ✅ Signup link uses themed colors

## Next Steps

- Check out [login_theme_example.dart](examples/login_theme_example.dart) for advanced usage
- Explore the theme files in `themes/` folder for customization options 
- Follow the same pattern for other screens (signup, profile, etc.)