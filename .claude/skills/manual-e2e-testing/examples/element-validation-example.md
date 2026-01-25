# Manual E2E Testing - Element Validation Example

## Example 1: Verifying Element States

**Test Scenario:** Verify button is disabled until form is valid

```dart
testWidgets('should enable button only when form is valid', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Find submit button
  final submitButton = find.byKey(Key('submit_button'));
  expect(submitButton, findsOneWidget);

  // Verify button is initially disabled
  ElevatedButton button = tester.widget<ElevatedButton>(submitButton);
  expect(button.enabled, false);

  // Fill required fields
  await tester.enterText(find.byKey(Key('name_input')), 'John Doe');
  await tester.pump();
  button = tester.widget<ElevatedButton>(submitButton);
  expect(button.enabled, false); // Still disabled - need email too

  await tester.enterText(find.byKey(Key('email_input')), 'john@example.com');
  await tester.pump();
  button = tester.widget<ElevatedButton>(submitButton);
  expect(button.enabled, true); // Now enabled!
});
```

## Example 2: Text Content Verification

**Test Scenario:** Verify success message displays after submission

```dart
testWidgets('should show success message after form submission', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Fill and submit form
  await tester.enterText(find.byKey(Key('name_input')), 'John Doe');
  await tester.enterText(find.byKey(Key('email_input')), 'john@example.com');
  await tester.tap(find.byKey(Key('submit_button')));
  await tester.pumpAndSettle();

  // Verify success message
  expect(find.text('Form submitted successfully!'), findsOneWidget);
  expect(find.byKey(Key('success_icon')), findsOneWidget);

  // Verify form fields are cleared
  final nameField = tester.widget<TextField>(find.byKey(Key('name_input')));
  expect(nameField.controller?.text, '');
});
```

## Example 3: Widget Tree Analysis

**Test Scenario:** Using Dart MCP to analyze widget hierarchy

```dart
// Use Dart MCP's get_widget_tree to understand structure
final widgetTree = await getWidgetTree();

// Verify expected widget hierarchy
expect(widgetTree, contains('MyApp'));
expect(widgetTree, contains('Scaffold'));
expect(widgetTree, contains('Form'));
expect(widgetTree, contains('TextFormField'));

// Verify specific widget exists with expected properties
final emailField = find.byType(TextFormField).first;
expect(tester.widget<TextFormField>(emailField).key, Key('email_input'));
expect(tester.widget<TextFormField>(emailField).validator, isNotNull);
```

## Example 4: Accessibility Label Verification

**Test Scenario:** Verify accessibility labels are present

```dart
testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Verify Semantics widgets exist
  expect(
    find.bySemanticsLabel('Email input field'),
    findsOneWidget,
    reason: 'Email field should have accessibility label',
  );

  expect(
    find.bySemanticsLabel('Submit form button'),
    findsOneWidget,
    reason: 'Submit button should have accessibility label',
  );

  // Verify all interactive elements have labels
  final semantics = tester.getSemantics(find.byType(MyApp));
  for (final node in semantics) {
    if (node.actions.interactive) {
      expect(node.label, isNotEmpty, reason: 'Interactive element must have label');
    }
  }
});
```

## Example 5: List Item Enumeration

**Test Scenario:** Verify list contains expected items

```dart
testWidgets('should display all expected items in list', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());

  // Verify list exists
  expect(find.byType(ListView), findsOneWidget);

  // Verify expected items are present
  final expectedItems = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];
  for (final item in expectedItems) {
    expect(find.text(item), findsOneWidget, reason: '$item should be in list');
  }

  // Verify item count
  final listItems = find.byType(ListTile);
  expect(listItems, findsNWidgets(expectedItems.length));

  // Verify each item has expected structure
  for (final item in expectedItems) {
    final tile = find.ancestor(of: find.text(item), matching: find.byType(ListTile));
    expect(tile, findsOneWidget);

    // Verify tile has leading icon
    final icon = find.descendant(
      of: tile,
      matching: find.byType(Icon),
    );
    expect(icon, findsOneWidget);
  }
});
```

## Example 6: Error State Verification

**Test Scenario:** Verify error handling with runtime error diagnosis

```dart
testWidgets('should handle API error gracefully', (WidgetTester tester) async {
  // Setup mock to return error
  when(mockApi.getData()).thenThrow(Exception('Network error'));

  await tester.pumpWidget(MyApp());

  // Trigger API call
  await tester.tap(find.byKey(Key('fetch_button')));
  await tester.pumpAndSettle();

  // Verify error message
  expect(find.text('Failed to load data'), findsOneWidget);

  // Use Dart MCP to check runtime errors
  final errors = await getRuntimeErrors();
  expect(errors, isNotEmpty);

  // Verify error was handled (not uncaught)
  expect(errors.first.type, isNot('UnhandledException'));
});
```

## Example 7: Hot Reload Testing

**Test Scenario:** Using Dart MCP for rapid iteration

```dart
// During test development, use hot reload to speed up iteration
void main() {
  testWidgets('debugging widget behavior', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Initial state
    expect(find.text('Counter: 0'), findsOneWidget);

    // Tap increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify state changed
    expect(find.text('Counter: 1'), findsOneWidget);

    // Hot reload to apply code changes without restarting
    await hotReload();

    // Continue testing with updated code
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('Counter: 2'), findsOneWidget);
  });
}
```
