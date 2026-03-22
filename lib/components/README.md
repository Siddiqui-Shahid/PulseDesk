# Component-Based Architecture for Login Screen

This folder contains a component-based architecture implementation of the login screen with dependency injection and a comprehensive theme system.

## Structure

```
components/
├── login/
│   ├── models/                    # Data & Style models
│   │   ├── error_banner_data_model.dart
│   │   ├── error_banner_style_model.dart
│   │   ├── login_form_data_model.dart
│   │   ├── login_form_style_model.dart
│   │   ├── login_button_data_model.dart
│   │   ├── login_button_style_model.dart
│   │   ├── signup_link_data_model.dart
│   │   └── signup_link_style_model.dart
│   ├── themes/                    # Theme system
│   │   ├── login_default_themes.dart     # Default theme definitions
│   │   └── login_theme_manager.dart      # Theme manager with overrides
│   ├── widgets/                   # Reusable components
│   │   ├── error_banner_component.dart
│   │   ├── login_form_component.dart
│   │   ├── login_button_component.dart
│   │   └── signup_link_component.dart
│   ├── login_component_di.dart    # Dependency injection container
│   ├── login_screen_container.dart # Main screen container
│   └── login_components.dart      # Barrel export
├── common/
│   ├── login_theme_config.dart    # Easy theme setup methods
│   └── app_theme_manager.dart     # App-wide theme integration
└── examples/
    └── login_theme_example.dart   # Usage examples
```

## Features

### 🎨 Default Theme System
- **3 Built-in Themes**: Standard, Dark, and Compact
- **Per-Component Defaults**: Each component has its own default styling
- **Override Capability**: View models can override any theme property
- **Theme Inheritance**: Overrides take priority over theme defaults

### 💉 Dependency Injection
- **Data Models**: Contain component state and business data
- **Style Models**: Define visual appearance and styling
- **DI Container**: Manages creation and injection of models with theme support
- **Override System**: View models can inject custom data/styles

### 🔧 Component Benefits
- **Reusable**: Components work across different screens
- **Testable**: Each component can be tested in isolation
- **Themeable**: Global and per-component theming
- **Overridable**: View models can customize any aspect
- **Maintainable**: Clear separation of concerns

## Usage Examples

### 🚀 Quick Start

```dart
// 1. Set up theme in your app initialization
void main() {
  // Initialize with system theme
  AppThemeManager.initializeComponentThemes(ThemeMode.system);
  
  // Or use a specific theme
  LoginThemeConfig.setupDarkTheme();
  
  runApp(MyApp());
}
```

### 🎨 Theme Options

```dart
import 'package:pulse_desk/components/login/login_components.dart';

// Built-in themes
LoginThemeConfig.setupLightTheme();    // Standard default theme
LoginThemeConfig.setupDarkTheme();     // Dark variant
LoginThemeConfig.setupCompactTheme();  // Smaller components

// Accessibility themes
LoginThemeConfig.setupHighContrastTheme();
LoginThemeConfig.setupMinimalTheme();

// Custom branded theme
LoginThemeConfig.setupCustomTheme(
  primaryColor: Colors.green,
  errorColor: Colors.orange,
  borderRadius: 12,
  componentHeight: 56,
);
```

### 🔄 Runtime Theme Switching

```dart
class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  void _switchTheme(LoginThemeType theme) {
    final di = LoginComponentDI();
    di.setTheme(theme);
    setState(() {}); // Trigger rebuild
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          PopupMenuButton<LoginThemeType>(
            onSelected: _switchTheme,
            itemBuilder: (context) => [
              PopupMenuItem(value: LoginThemeType.standard, child: Text('Light')),
              PopupMenuItem(value: LoginThemeType.dark, child: Text('Dark')),
              PopupMenuItem(value: LoginThemeType.compact, child: Text('Compact')),
            ],
          ),
        ],
      ),
      body: LoginScreenContainer(
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        // ... other properties
      ),
    );
  }
}
```

### ⚙️ View Model Overrides

```dart
class CustomLoginViewModel extends ChangeNotifier {
  void setupCustomStyling() {
    final di = LoginComponentDI();
    
    // Override specific components while keeping theme defaults for others
    di.setOverrides(
      // Custom error styling (maybe from server config)
      errorBannerStyle: ErrorBannerStyleModel(
        backgroundColor: Color(0xFFFFF3CD), // Warning yellow
        borderColor: Color(0xFFFFD60A),
        iconColor: Color(0xFF664D03),
        textColor: Color(0xFF664D03),
      ),
      
      // Custom text from backend
      signupLinkData: SignupLinkDataModel(
        isEnabled: true,
        prefixText: "New here? ",
        linkText: _getSignupTextFromServer(),
      ),
      
      // Custom button text based on login type
      loginButtonData: LoginButtonDataModel(
        isLoading: isLoading,
        isEnabled: !isLoading,
        buttonText: _isGoogleLogin ? 'Sign in with Google' : 'Login',
      ),
    );
  }
  
  void clearCustomizations() {
    final di = LoginComponentDI();
    di.clearOverrides(); // Return to pure theme defaults
  }
}
```

### 🧩 Individual Components

```dart
// Use individual components with custom data/style
ErrorBannerComponent(
  dataModel: ErrorBannerDataModel(
    errorMessage: "Custom error message",
    isVisible: true,
  ),
  styleModel: ErrorBannerStyleModel(
    backgroundColor: Colors.yellow.shade100,
    borderColor: Colors.orange,
  ),
)

LoginFormComponent(
  dataModel: LoginFormDataModel(
    emailValue: "",
    passwordValue: "",
    isEnabled: true,
    emailLabel: "Work Email", // Custom label
  ),
  emailController: _emailController,
  passwordController: _passwordController,
)
```

### 📱 Adaptive Theming

```dart
// Automatically adapt theme based on device
MaterialApp(
  builder: (context, child) {
    AppThemeManager.applyAdaptiveTheme(context);
    return child!;
  },
  // ... other properties
)
```

## How the Priority System Works

1. **View Model Overrides** (Highest Priority)
   - Data/style set via `di.setOverrides()`
   - Takes precedence over everything

2. **Component Props** (Medium Priority)  
   - Direct props passed to components
   - Falls back to overrides if not provided

3. **Theme Defaults** (Lowest Priority)
   - Built-in theme values (standard/dark/compact)
   - Used when no overrides or props provided

## Benefits of This Architecture

✅ **Separation of Concerns**: UI, data, styling, and theming are separate  
✅ **Dependency Injection**: Easy to test and customize components  
✅ **Default Themes**: Works out of the box with sensible defaults  
✅ **Override System**: View models can customize any aspect  
✅ **Theme Switching**: Runtime theme changes supported  
✅ **Reusability**: Components work across different screens  
✅ **Maintainability**: Clear structure makes code easier to maintain  
✅ **Scalability**: Easy to add new components following the same pattern  
✅ **Accessibility**: Built-in high contrast and minimal themes