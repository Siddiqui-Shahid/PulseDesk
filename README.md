Here is your complete **# PulseDesk - Flutter Router System

A comprehensive, easy-to-understand routing system for Flutter applications. This implementation demonstrates best practices from `go_router`, `auto_route`, and Navigator 2.0, with a clean, manual implementation that helps you understand how modern routing works.

## Features

✅ **Enum-Based Routes** - Type-safe route definitions with clear path mappings
✅ **Strong Type System** - Strongly-typed arguments and data passing between screens
✅ **Centralized Router** - Single `AppRouter` class manages all navigation
✅ **String Path Conversion** - Seamlessly convert string paths to enum routes
✅ **Navigation Methods** - `navigateTo()`, `pushRoute()`, `pop()` for intuitive control
✅ **Route History** - Built-in tracking of navigation stack
✅ **Error Handling** - Graceful handling of invalid routes and registration errors
✅ **Route Listeners** - Listen for navigation changes (analytics, logging, etc.)
✅ **Production-Ready** - Null-safe, immutable data structures, clean architecture
✅ **Fully Tested** - Comprehensive unit tests covering all functionality

## Project Structure

```
lib/
├── main.dart                          # App entry point with router setup
├── router/
│   ├── app_route.dart                # Route enum definitions
│   ├── app_router.dart               # Central router class
│   └── route_models.dart             # RouteArguments & RouteResult models
└── screens/
    ├── home_screen.dart              # Home/initial screen
    ├── details_screen.dart           # Details screen (receives data)
    ├── profile_screen.dart           # Profile screen (receives data)
    ├── settings_screen.dart          # Settings screen
    └── not_found_screen.dart         # 404 fallback screen

test/
└── router_test.dart                  # Comprehensive router tests
```

## Quick Start

### 1. Define Routes (AppRoute Enum)

```dart
enum AppRoute {
  home('/home'),
  details('/details'),
  profile('/profile'),
  settings('/settings'),
  notFound('/not-found');

  final String path;
  const AppRoute(this.path);

  // Convert string paths to enum values
  static AppRoute fromPath(String pathString) { /* ... */ }
  static bool isValidPath(String pathString) { /* ... */ }
}
```

### 2. Create a Router Instance

```dart
final appRouter = AppRouter();
```

**Note:** `AppRouter` is a singleton - all instances reference the same router state.

### 3. Register Routes

In `main.dart`:

```dart
void _setupRoutes() {
  appRouter.registerRoutes({
    AppRoute.home: (context) => const HomeScreen(),
    AppRoute.details: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return DetailsScreen(arguments: args is RouteArguments ? args : null);
    },
    // ... more routes
  });
}
```

### 4. Navigate

#### Simple Navigation (no data)

```dart
appRouter.pushRoute(AppRoute.home);
```

#### Navigate with Data

```dart
final arguments = RouteArguments(
  id: 'product-123',
  title: 'Amazing Product',
  data: {
    'price': 99.99,
    'inStock': true,
  },
);

appRouter.pushRoute(AppRoute.details, data: arguments);
```

#### Navigate by String Path

```dart
appRouter.navigateByPath('/profile');
```

### 5. Receive Data in Destination Screen

```dart
class DetailsScreen extends StatelessWidget {
  final RouteArguments? arguments;

  const DetailsScreen({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (arguments != null) {
      print('ID: ${arguments.id}');
      print('Title: ${arguments.title}');
      print('Data: ${arguments.data}');
    }
    // ... build UI
  }
}
```

## Core Classes

### AppRoute (Enum)

Defines all available routes in your application.

```dart
enum AppRoute {
  home('/home'),
  details('/details'),
  profile('/profile'),
  // ...

  final String path;
  const AppRoute(this.path);

  // Convert string to AppRoute
  static AppRoute fromPath(String pathString)

  // Check if path is valid
  static bool isValidPath(String pathString)
}
```

**Usage:**
```dart
final route = AppRoute.fromPath('/home');  // Returns AppRoute.home
final isValid = AppRoute.isValidPath('/details');  // Returns true
```

### RouteArguments

Represents data passed during navigation.

```dart
const RouteArguments(
  id: 'user-123',           // Unique identifier
  title: 'User Name',       // Display title
  data: {                   // Any additional data
    'email': 'user@example.com',
    'phone': '+1-234-567-8900',
  },
)
```

### RouteResult

Represents the outcome of a navigation operation.

```dart
const RouteResult(
  success: true,
  errorMessage: null,
  result: null,
)
```

### AppRouter

Central class managing all navigation operations.

#### Key Methods

**`registerRoute(AppRoute route, WidgetBuilder builder)`**

Register a single route:

```dart
appRouter.registerRoute(
  AppRoute.home,
  (context) => const HomeScreen(),
);
```

**`registerRoutes(Map<AppRoute, WidgetBuilder> routes)`**

Register multiple routes at once:

```dart
appRouter.registerRoutes({
  AppRoute.home: (context) => const HomeScreen(),
  AppRoute.details: (context) => const DetailsScreen(),
  AppRoute.profile: (context) => const ProfileScreen(),
});
```

**`pushRoute(AppRoute route, {dynamic data})`**

Push a new route onto the stack (previous screen remains for back navigation):

```dart
await appRouter.pushRoute(AppRoute.details, data: arguments);
```

**`navigateTo(AppRoute route, {dynamic data})`**

Replace current route (previous screen is removed):

```dart
await appRouter.navigateTo(AppRoute.home);
```

**`navigateByPath(String path, {dynamic data})`**

Navigate using a string path:

```dart
await appRouter.navigateByPath('/profile', data: arguments);
```

**`pop<T>([T? result])`**

Pop the current route and return to the previous screen:

```dart
appRouter.pop();
// With result:
appRouter.pop('returned_value');
```

**`addRouteListener(Function listener)`**

Listen for navigation changes:

```dart
appRouter.addRouteListener((route, args) {
  print('Navigated to: ${route.path}');
  print('With args: $args');
});
```

**`isRouteRegistered(AppRoute route)`**

Check if a route is registered:

```dart
if (appRouter.isRouteRegistered(AppRoute.home)) {
  // Route is available
}
```

**`get currentRoute`**

Get the currently active route:

```dart
final current = appRouter.currentRoute;  // AppRoute.home, etc.
```

**`get routeHistory`**

Get the complete navigation history:

```dart
final history = appRouter.routeHistory;  // List<AppRoute>
```

## Navigation Patterns

### Pattern 1: Navigate Without Data

```dart
appRouter.pushRoute(AppRoute.settings);
```

### Pattern 2: Navigate With Structured Data

```dart
final userProfile = RouteArguments(
  id: 'user-001',
  title: 'John Doe',
  data: {
    'email': 'john@example.com',
    'joinDate': '2023-01-15',
  },
);

appRouter.pushRoute(AppRoute.profile, data: userProfile);
```

### Pattern 3: Navigate With Simple Data

```dart
appRouter.pushRoute(
  AppRoute.details,
  data: RouteArguments(data: 'simple-value'),
);
```

### Pattern 4: Navigate Using String Paths

```dart
appRouter.navigateByPath('/details?id=123');
```

### Pattern 5: Replace Current Screen

```dart
// Go back to home, replacing current screen
appRouter.navigateTo(AppRoute.home);
```

### Pattern 6: Pop With Result

```dart
// In the destination screen:
appRouter.pop({
  'status': 'success',
  'message': 'Operation completed',
});
```

## Receiving Data in Screens

### Method 1: Constructor Parameter

```dart
class DetailsScreen extends StatelessWidget {
  final RouteArguments? arguments;

  const DetailsScreen({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: arguments != null
        ? Text('ID: ${arguments!.id}')
        : const Text('No data'),
    );
  }
}
```

### Method 2: Extract from ModalRoute

```dart
class DetailsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final routeArgs = args is RouteArguments ? args : null;
    
    return Scaffold(
      body: Text('Title: ${routeArgs?.title ?? "N/A"}'),
    );
  }
}
```

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/router_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Coverage

The `test/router_test.dart` file includes comprehensive tests for:

✅ Route enum path conversions
✅ Route validation and lookup
✅ RouteArguments creation and usage
✅ RouteResult handling
✅ AppRouter registration and management
✅ Data passing between screens
✅ Navigation history tracking
✅ Error handling for invalid routes

## Best Practices

### 1. **Centralized Route Definition**

Define all routes in one enum to ensure consistency:

```dart
enum AppRoute {
  home('/home'),
  details('/details'),
  profile('/profile'),
  // ...
}
```

### 2. **Type-Safe Arguments**

Use `RouteArguments` for strongly-typed data passing:

```dart
final args = RouteArguments(
  id: 'product-123',
  title: 'Product Name',
  data: productModel,
);
```

### 3. **Register Routes Early**

Set up all routes in `initState()` or `main()`:

```dart
void initState() {
  super.initState();
  _appRouter = AppRouter();
  _setupRoutes();
}
```

### 4. **Use Route Listeners for Analytics**

Track navigation for analytics or state management:

```dart
appRouter.addRouteListener((route, args) {
  // Log to analytics
  // Update app state
  // Trigger side effects
});
```

### 5. **Handle Invalid Routes Gracefully**

Always provide a fallback for unknown paths:

```dart
AppRoute.notFound: (context) => const NotFoundScreen(),
```

### 6. **Validate Routes Before Navigation**

Check if a route is registered:

```dart
if (appRouter.isRouteRegistered(AppRoute.details)) {
  appRouter.pushRoute(AppRoute.details);
}
```

### 7. **Use Immutable Data Models**

Ensure consistency with `const` constructors:

```dart
const RouteArguments(
  id: 'id-123',
  title: 'Title',
  data: {},
)
```

## Architecture Decisions

### Why an Enum?

- **Type-safe**: Compiler catches invalid route references
- **Self-documenting**: Clear list of all available routes
- **Zero runtime cost**: Enums are compile-time only
- **Easy to understand**: Familiar Dart pattern

### Why Manual Implementation?

- **Learn how routing works**: Understand the concepts used by go_router, auto_route
- **Minimal dependencies**: No external packages required
- **Full control**: Customize behavior without workarounds
- **Transparent**: See exactly what happens during navigation

### Why Singleton?

- **Global state**: Any part of app can navigate
- **Single source of truth**: One router manages all navigation
- **Navigation from anywhere**: No need to pass router through widget tree

## Extending the Router

### Add New Routes

1. Add to `AppRoute` enum:
```dart
newFeature('/new-feature'),
```

2. Register in `_setupRoutes()`:
```dart
AppRoute.newFeature: (context) => const NewFeatureScreen(),
```

3. Navigate:
```dart
appRouter.pushRoute(AppRoute.newFeature);
```

### Add Deep Linking

```dart
appRouter.navigateByPath('/details?id=123');
```

### Add Route Guards

```dart
Future<bool> canNavigateTo(AppRoute route) async {
  if (route == AppRoute.profile && !isLoggedIn) {
    return false;
  }
  return true;
}
```

## Troubleshooting

### Issue: "Route not registered"

**Solution**: Register the route before navigating:

```dart
appRouter.registerRoute(AppRoute.home, (context) => const HomeScreen());
```

### Issue: Arguments not received in destination

**Solution**: Ensure you're extracting arguments correctly:

```dart
final args = ModalRoute.of(context)?.settings.arguments as RouteArguments?;
```

### Issue: Back navigation not working

**Solution**: Use `pushRoute()` instead of `navigateTo()`:

```dart
appRouter.pushRoute(AppRoute.details);  // ✅ Keeps previous screen
appRouter.navigateTo(AppRoute.details); // ❌ Removes previous screen
```

## Example Flows

### Flow 1: Home → Details → Profile

```
1. Start at Home (AppRoute.home)
2. Press "Go to Details" 
   → appRouter.pushRoute(AppRoute.details, data: arguments)
3. In Details, press "Go to Profile"
   → appRouter.pushRoute(AppRoute.profile, data: userData)
4. Press Back in Profile
   → Returns to Details
5. Press Back in Details
   → Returns to Home
```

### Flow 2: Home → Settings → Home

```
1. Start at Home
2. Press "Go to Settings"
   → appRouter.pushRoute(AppRoute.settings)
3. Press "Back to Home"
   → appRouter.navigateTo(AppRoute.home)  // Replaces settings
4. You're back at Home (settings not in stack)
```

## Performance Considerations

- **Route registration**: O(1) lookup time
- **Navigation**: Minimal overhead - just path lookup and widget creation
- **History tracking**: O(n) space where n = number of screens in stack
- **No rebuilds**: Navigation doesn't rebuild entire app

## Future Enhancements

- Add route transitions and animations
- Implement route guards for auth/permissions
- Add dynamic route registration
- Support nested routing
- Add URL query parameter parsing
- Implement route middleware

## Contributing

This is an educational project demonstrating routing concepts. Feel free to:
- Study the code to understand routing patterns
- Extend it for your use case
- Use it as a template for larger projects

## License

This example project is open source and available for educational purposes.

## Resources

- [Flutter Navigator 2.0](https://docs.flutter.dev/development/ui/navigation)
- [go_router Package](https://pub.dev/packages/go_router)
- [auto_route Package](https://pub.dev/packages/auto_route)
- [Flutter Routing Guide](https://docs.flutter.dev/development/ui/navigation/named-routes)** file structured professionally for a GitHub project.

You can directly copy this into your repository.

---

# 🏥 Clinic Token & Prescription Management System

A simple, scalable clinic management system built using:

* **Frontend:** Flutter (Mobile + Web)
* **Backend:** Firebase (Auth, Firestore, Storage, Cloud Functions)
* **Database:** Firestore (NoSQL)
* **Real-time Updates:** Firebase Realtime / Firestore Streams

---

# 📌 Project Overview

This system allows clinics to:

* Manage patient token-based appointments
* Provide live queue tracking
* Generate digital & printable prescriptions
* Manage doctor availability
* Control clinic working hours
* Support both mobile and web platforms using Flutter

---

# 🎯 Core Features

## 1️⃣ Token & Appointment System

* Book appointments (instant & advance)
* Generate daily token numbers
* Real-time queue updates
* Estimated waiting time calculation
* Doctor availability check
* Clinic open/close validation

## 2️⃣ Digital Prescription System

* Doctor creates prescription
* PDF generation
* Printable copy
* Stored digital copy for patient
* Medicine details & notes
* Push notification on prescription completion

---

# 👥 User Roles

## 👤 Patient

* Login / Register
* Book appointment
* View token number
* Live queue tracking
* View estimated waiting time
* Download prescription PDF
* View doctor availability
* View clinic timings

## 👨‍⚕️ Doctor

* Login
* View today’s queue
* Start/Complete consultation
* Create prescription
* Print prescription
* Mark unavailable days
* Manage daily timings

## 🧑‍💼 Admin (Optional)

* Add walk-in patients
* Override queue
* Manage clinic hours
* Manage doctor schedule
* View analytics

---

# 🏗 System Architecture

```
Flutter App (Mobile + Web)
        ↓
Firebase Authentication
        ↓
Cloud Firestore Database
        ↓
Firebase Storage (PDFs)
        ↓
Cloud Functions (Business Logic)
```

---

# 🔥 Firebase Services Used

| Service            | Purpose                                 |
| ------------------ | --------------------------------------- |
| Firebase Auth      | User authentication                     |
| Firestore          | Database storage                        |
| Firebase Storage   | Prescription PDF storage                |
| Cloud Functions    | Token generation, wait time calculation |
| Firebase Messaging | Push notifications                      |
| Firestore Streams  | Real-time queue updates                 |

---

# 🗄 Database Structure (Firestore Collections)

## Users

```
users/
  userId
    name
    email
    phone
    role (patient / doctor / admin)
    createdAt
```

## Clinics

```
clinics/
  clinicId
    name
    address
    openTime
    closeTime
    consultationDuration
```

## Doctors

```
doctors/
  doctorId
    userId
    clinicId
    specialization
    isAvailableToday
```

## Appointments

```
appointments/
  appointmentId
    patientId
    doctorId
    clinicId
    tokenNumber
    appointmentTime
    status
    estimatedTime
    createdAt
```

## Prescriptions

```
prescriptions/
  prescriptionId
    appointmentId
    diagnosis
    notes
    pdfUrl
    createdAt
```

## Medicines (Subcollection)

```
prescriptions/{id}/medicines/
    name
    dosage
    frequency
    duration
```

---

# ⏳ Token & Waiting Time Logic

Estimated Wait Time:

```
(Current Token - Patient Token) × Consultation Duration
```

Example:

* Consultation Duration: 10 mins
* Current Token: 12
* Patient Token: 15

Wait Time = (15 - 12) × 10 = 30 minutes

Updated in real-time using Firestore Streams.

---

# 📱 Flutter App Structure

```
lib/
 ├── main.dart
 ├── core/
 │    ├── services/
 │    ├── utils/
 │
 ├── features/
 │    ├── auth/
 │    ├── appointments/
 │    ├── prescriptions/
 │    ├── doctor/
 │    ├── admin/
 │
 ├── models/
 ├── providers/
 ├── routes/
```

---

# 🔐 Security Rules

* Role-based access control
* Firestore security rules
* JWT via Firebase Auth
* Only doctor can create prescriptions
* Patients can only view their own data

---

# 🚀 Development Roadmap

## Phase 1 – MVP (Single Clinic)

* Authentication
* Basic appointment booking
* Token generation
* Doctor queue view
* Prescription creation (basic)
* PDF storage
* Real-time queue tracking

## Phase 2 – Enhanced Features

* Admin dashboard
* Doctor schedule management
* Advanced booking slots
* Analytics
* Push notifications

## Phase 3 – Scaling

* Multi-clinic support
* Payment integration
* Teleconsultation
* SMS/WhatsApp alerts

---

# 📊 Project Progress Tracker

| Module                   | Status         | Progress | Notes                            |
| ------------------------ | -------------- | -------- | -------------------------------- |
| Project Setup            | ✅ Completed    | 100%     | Flutter + Firebase connected     |
| Authentication           | ⏳ In Progress  | 60%      | Firebase Auth integration        |
| User Roles               | ⏳ In Progress  | 40%      | Role-based access logic          |
| Appointment Booking      | 🔲 Not Started | 0%       | Token generation pending         |
| Real-Time Queue          | 🔲 Not Started | 0%       | Firestore streams needed         |
| Doctor Dashboard         | 🔲 Not Started | 0%       | UI design pending                |
| Prescription Creation    | 🔲 Not Started | 0%       | Form & logic pending             |
| PDF Generation           | 🔲 Not Started | 0%       | Cloud Function required          |
| Push Notifications       | 🔲 Not Started | 0%       | FCM integration                  |
| Admin Panel              | 🔲 Not Started | 0%       | Web layout required              |
| Firestore Security Rules | 🔲 Not Started | 0%       | Must configure before production |
| Deployment               | 🔲 Not Started | 0%       | Play Store / Web hosting         |

Legend:

* ✅ Completed
* ⏳ In Progress
* 🔲 Not Started

---

# 📦 Future Enhancements

* AI-based prescription suggestions
* Voice-to-text for doctors
* Follow-up reminders
* Analytics dashboard
* Dark mode
* Multi-language support

---

# 🛠 How to Run the Project

1. Clone repository
2. Run:

```
flutter pub get
```

3. Configure Firebase
4. Run:

```
flutter run
```

---

# 📄 License

This project is intended for clinic management use and can be extended commercially.

---

If you want, I can now:

* Create a professional folder structure with clean architecture
* Write Firestore security rules
* Design your first MVP sprint plan
* Create UI wireframe layout
* Or generate Firebase Cloud Functions structure
