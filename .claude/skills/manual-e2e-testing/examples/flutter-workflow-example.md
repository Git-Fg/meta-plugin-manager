# Manual E2E Testing - Flutter Workflow Example

## Example 1: Login Flow Testing

**Test Scenario:** Verify user can log in with valid credentials

```dart
// Test: Verify successful login
testWidgets('should log in with valid credentials', (WidgetTester tester) async {
  // Build login widget
  await tester.pumpWidget(MyApp());

  // Find email input field
  final emailField = find.byKey(Key('email_input'));
  expect(emailField, findsOneWidget);

  // Enter email
  await tester.enterText(emailField, 'user@example.com');
  await tester.pump();

  // Find password input field
  final passwordField = find.byKey(Key('password_input'));
  await tester.enterText(passwordField, 'password123');
  await tester.pump();

  // Find and tap login button
  final loginButton = find.byKey(Key('login_button'));
  await tester.tap(loginButton);
  await tester.pump();

  // Wait for navigation
  await tester.pumpAndSettle();

  // Verify home screen is displayed
  expect(find.byKey(Key('home_screen')), findsOneWidget);
  expect(find.text('Welcome, user!'), findsOneWidget);
});
```

## Example 2: Form Validation Testing

**Test Scenario:** Verify form shows validation errors for invalid input

```dart
testWidgets('should show validation error for invalid email', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Enter invalid email
  final emailField = find.byKey(Key('email_input'));
  await tester.enterText(emailField, 'invalid-email');
  await tester.pump();

  // Enter valid password
  final passwordField = find.byKey(Key('password_input'));
  await tester.enterText(passwordField, 'password123');
  await tester.pump();

  // Tap login button
  final loginButton = find.byKey(Key('login_button'));
  await tester.tap(loginButton);
  await tester.pump();

  // Verify error message appears
  expect(find.text('Please enter a valid email address'), findsOneWidget);

  // Verify login button is disabled
  final button = tester.widget<ElevatedButton>(loginButton);
  expect(button.enabled, false);
});
```

## Example 3: List Interaction Testing

**Test Scenario:** Verify user can scroll list and tap items

```dart
testWidgets('should scroll list and tap item', (WidgetTester tester) async {
  // Build widget with long list
  await tester.pumpWidget(MyApp());

  // Verify first item is visible
  expect(find.text('Item 0'), findsOneWidget);

  // Verify last item is NOT visible yet
  expect(find.text('Item 49'), findsNothing);

  // Scroll down
  await tester.fling(
    find.byType(ListView),
    const Offset(0, -500),
    10000,
  );
  await tester.pump();

  // Verify last item is now visible
  expect(find.text('Item 49'), findsOneWidget);

  // Tap an item
  await tester.tap(find.text('Item 25'));
  await tester.pumpAndSettle();

  // Verify detail screen opened
  expect(find.byKey(Key('detail_screen')), findsOneWidget);
  expect(find.text('Item 25 Details'), findsOneWidget);
});
```

## Example 4: Widget State Testing

**Test Scenario:** Verify checkbox toggles state correctly

```dart
testWidgets('should toggle checkbox state', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Find checkbox
  final checkbox = find.byType(Checkbox);
  expect(checkbox, findsOneWidget);

  // Verify initially unchecked
  Checkbox widget = tester.widget<Checkbox>(checkbox);
  expect(widget.value, false);

  // Tap checkbox
  await tester.tap(checkbox);
  await tester.pump();

  // Verify now checked
  widget = tester.widget<Checkbox>(checkbox);
  expect(widget.value, true);

  // Tap again to uncheck
  await tester.tap(checkbox);
  await tester.pump();

  // Verify unchecked again
  widget = tester.widget<Checkbox>(checkbox);
  expect(widget.value, false);
});
```

## Example 5: Navigation Testing

**Test Scenario:** Verify navigation between screens

```dart
testWidgets('should navigate to settings and back', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Verify home screen
  expect(find.byKey(Key('home_screen')), findsOneWidget);

  // Tap settings button in app bar
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  // Verify settings screen
  expect(find.byKey(Key('settings_screen')), findsOneWidget);
  expect(find.text('Settings'), findsOneWidget);

  // Tap back button
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Verify back on home screen
  expect(find.byKey(Key('home_screen')), findsOneWidget);
});
```
