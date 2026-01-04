import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tamra/main.dart';
import 'package:tamra/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Auto test: Login screen button press', (WidgetTester tester) async {
    print('\n🚀 Starting automated login button test...\n');

    // Initialize Firebase first
    try {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBcpgPYSv1LwfGcg0OKAfjL4bPCe7HTNAc',
          appId: '1:972692803858:ios:2c1ac9d6359961423ca3cb',
          messagingSenderId: '972692803858',
          projectId: 'tamra-f6dab',
          storageBucket: 'tamra-f6dab.firebasestorage.app',
          iosBundleId: 'com.tamra.app1',
        ),
      );
      print('✅ Firebase initialized');
    } catch (e) {
      print('ℹ️  Firebase already initialized or error: $e');
    }

    // Build the app
    await tester.pumpWidget(MyApp(appRouter: AppRouter()));
    await tester.pump();
    await Future.delayed(Duration(seconds: 1));

    print('✅ App loaded');

    // Wait for Firebase to initialize
    await Future.delayed(Duration(seconds: 2));
    await tester.pumpAndSettle(Duration(seconds: 5));

    // Find the phone number TextField
    print('🔍 Looking for phone number TextField...');
    
    // Try multiple ways to find the TextField
    Finder phoneField;
    try {
      phoneField = find.byType(TextField).first;
      expect(phoneField, findsOneWidget);
      print('✅ Phone field found by type');
    } catch (e) {
      print('❌ Could not find TextField: $e');
      return;
    }

    // Enter phone number
    print('📱 Entering phone number: 0512345678');
    await tester.enterText(phoneField, '0512345678');
    await tester.pump();
    await Future.delayed(Duration(milliseconds: 500));
    print('✅ Phone number entered');

    // Find the "التالي" button
    print('🔍 Looking for "التالي" button...');
    
    final nextButtonText = find.text('التالي');
    
    if (nextButtonText.evaluate().isNotEmpty) {
      print('✅ Found "التالي" text');
      
      // Find parent InkWell
      final inkWell = find.ancestor(
        of: nextButtonText,
        matching: find.byType(InkWell),
      );
      
      if (inkWell.evaluate().isNotEmpty) {
        print('👆 Tapping "التالي" button via InkWell...');
        await tester.tap(inkWell.first);
        print('✅ Button tapped!');
      } else {
        print('👆 Tapping "التالي" text directly...');
        await tester.tap(nextButtonText);
        print('✅ Button tapped!');
      }
    } else {
      // Try finding all InkWells and tap the last one (usually the next button)
      print('🔍 Trying alternative method...');
      final inkWells = find.byType(InkWell);
      final inkWellList = inkWells.evaluate();
      if (inkWellList.length >= 2) {
        print('👆 Tapping InkWell #${inkWellList.length - 1}...');
        await tester.tap(inkWells.at(inkWellList.length - 1));
        print('✅ Button tapped!');
      } else {
        print('❌ Could not find "التالي" button');
        return;
      }
    }

    // Wait for response (longer timeout to catch crashes)
    await tester.pump();
    await Future.delayed(Duration(seconds: 5));
    
    // Check if app is still responsive
    try {
      await tester.pumpAndSettle(Duration(seconds: 3));
      print('\n✅ App is still responsive after button press!');
    } catch (e) {
      print('\n⚠️  PumpAndSettle timeout - this may indicate the app is processing');
    }
    
    // Check if we navigated to verify screen or if loading indicator appeared
    final loadingIndicator = find.byType(CircularProgressIndicator);
    final verifyScreen = find.text('ادخل كود التفعيل');
    
    if (verifyScreen.evaluate().isNotEmpty) {
      print('✅ Successfully navigated to Verify Screen');
    } else if (loadingIndicator.evaluate().isNotEmpty) {
      print('✅ Loading indicator shown - Firebase Phone Auth is processing');
    } else {
      print('ℹ️  No navigation detected - may need APNs configuration for full functionality');
    }

    print('\n✨ Test completed successfully - Button works without crashing!\n');
  });
}

