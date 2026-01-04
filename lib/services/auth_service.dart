import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// إرسال OTP إلى رقم الجوال
  /// Firebase Auth سيتعامل تلقائياً مع:
  /// - إذا الرقم مسجل → تسجيل دخول
  /// - إذا الرقم غير مسجل → إنشاء حساب جديد
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      // تنسيق رقم الجوال (يجب أن يبدأ بـ +)
      String formattedPhone = phoneNumber;
      if (!formattedPhone.startsWith('+')) {
        // إذا لم يبدأ بـ +، أضف +966 (السعودية) أو +20 (مصر) حسب حاجتك
        formattedPhone = '+966$formattedPhone';
      }

      // إرسال OTP
      // زيادة timeout لإعطاء ReCAPTCHA وقت كافي للظهور والتفاعل
      print('📱 Starting phone verification for: $formattedPhone');
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) {
          print('✅ Phone verification completed automatically');
          // في حالة التحقق التلقائي (نادراً ما يحدث)
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Phone verification failed: ${e.code} - ${e.message}');
          onError(_getErrorMessage(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          print('✅ Verification code sent successfully');
          // تم إرسال الكود بنجاح
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏱️ Auto retrieval timeout - verificationId received');
          // انتهت مهلة الاسترجاع التلقائي
          // لكن verificationId متاح للاستخدام
        },
        timeout: const Duration(seconds: 120), // زيادة من 60 إلى 120 ثانية لإعطاء ReCAPTCHA وقت كافي
      );
    } catch (e) {
      onError('حدث خطأ: ${e.toString()}');
    }
  }

  /// التحقق من OTP وتسجيل الدخول أو إنشاء حساب جديد
  Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String smsCode,
    required String userType, // 'vendor' أو 'client'
  }) async {
    try {
      // إنشاء credential من verificationId و smsCode
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // تسجيل الدخول أو إنشاء حساب جديد
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user == null) {
        return {'success': false, 'message': 'فشل التحقق من الكود'};
      }

      // التحقق من وجود المستخدم في Firestore
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        // مستخدم جديد - إنشاء ملف في Firestore
        await _createUserProfile(user.uid, user.phoneNumber ?? '', userType);
        return {
          'success': true,
          'message': 'تم إنشاء الحساب بنجاح',
          'isNewUser': true,
          'userId': user.uid,
        };
      } else {
        // مستخدم موجود - تسجيل دخول
        return {
          'success': true,
          'message': 'تم تسجيل الدخول بنجاح',
          'isNewUser': false,
          'userId': user.uid,
        };
      }
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ: ${e.toString()}',
      };
    }
  }

  /// إنشاء ملف المستخدم في Firestore
  Future<void> _createUserProfile(String userId, String phoneNumber, String userType) async {
    try {
      // تحديد Collection حسب نوع المستخدم
      String collection = userType == 'vendor' ? 'vendors' : 'clients';

      // إنشاء ملف المستخدم
      await _firestore.collection(collection).doc(userId).set({
        'userType': userType,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // إنشاء ملف profile فرعي
      await _firestore
          .collection(collection)
          .doc(userId)
          .collection('profile')
          .doc('main')
          .set({
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('خطأ في إنشاء ملف المستخدم: $e');
      rethrow;
    }
  }

  /// تسجيل الدخول باستخدام credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('خطأ في تسجيل الخروج: $e');
    }
  }

  /// الحصول على معلومات المستخدم من Firestore
  Future<Map<String, dynamic>?> getUserData(String userId, String userType) async {
    try {
      String collection = userType == 'vendor' ? 'vendors' : 'clients';
      DocumentSnapshot doc = await _firestore.collection(collection).doc(userId).get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('خطأ في جلب بيانات المستخدم: $e');
      return null;
    }
  }

  /// الحصول على بيانات الملف الشخصي للمستخدم
  Future<Map<String, dynamic>?> getUserProfile(String userId, String userType) async {
    try {
      String collection = userType == 'vendor' ? 'vendors' : 'clients';
      DocumentSnapshot doc = await _firestore
          .collection(collection)
          .doc(userId)
          .collection('profile')
          .doc('main')
          .get();
      
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('خطأ في جلب بيانات الملف الشخصي: $e');
      return null;
    }
  }

  /// التحقق من اكتمال بيانات المستخدم
  /// يعيد true إذا كانت البيانات مكتملة (الاسم والايميل موجودين)
  Future<bool> isUserProfileComplete(String userId, String userType) async {
    try {
      Map<String, dynamic>? profileData = await getUserProfile(userId, userType);
      
      if (profileData == null) {
        return false;
      }

      // التحقق من وجود البيانات الأساسية
      String? fullName = profileData['fullName'] as String?;
      String? email = profileData['email'] as String?;
      
      // البيانات مكتملة إذا كان الاسم والايميل موجودين وغير فارغين
      return fullName != null && 
             fullName.trim().isNotEmpty && 
             email != null && 
             email.trim().isNotEmpty;
    } catch (e) {
      print('خطأ في التحقق من اكتمال البيانات: $e');
      return false;
    }
  }

  /// تحديث بيانات الملف الشخصي للمستخدم
  Future<void> updateUserProfile({
    required String userId,
    required String userType,
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      String collection = userType == 'vendor' ? 'vendors' : 'clients';

      // تحديث بيانات الملف الشخصي
      await _firestore
          .collection(collection)
          .doc(userId)
          .collection('profile')
          .doc('main')
          .set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // تحديث البيانات الأساسية في المستند الرئيسي
      await _firestore.collection(collection).doc(userId).update({
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('خطأ في تحديث بيانات المستخدم: $e');
      rethrow;
    }
  }

  /// تحويل كود الخطأ إلى رسالة بالعربية
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-phone-number':
        return 'رقم الجوال غير صحيح';
      case 'too-many-requests':
        return 'تم إرسال طلبات كثيرة. يرجى المحاولة لاحقاً';
      case 'session-expired':
        return 'انتهت صلاحية الجلسة. يرجى المحاولة مرة أخرى';
      case 'invalid-verification-code':
        return 'كود التحقق غير صحيح';
      case 'invalid-verification-id':
        return 'معرف التحقق غير صحيح';
      case 'quota-exceeded':
        return 'تم تجاوز الحد المسموح. يرجى المحاولة لاحقاً';
      case 'web-internal-error':
      case 'recaptcha-not-available':
      case 'missing-recaptcha-token':
        return 'حدث خطأ في عرض صفحة التحقق. يرجى التأكد من الاتصال بالإنترنت والمحاولة مرة أخرى. إذا استمرت المشكلة، أعد تشغيل التطبيق.';
      default:
        return 'حدث خطأ: $errorCode';
    }
  }
}










