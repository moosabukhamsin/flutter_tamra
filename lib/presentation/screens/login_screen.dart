import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamra/presentation/screens/verify_screen.dart';
import 'package:tamra/services/auth_service.dart';
import 'package:tamra/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك أدخل رقم الجوال';
    }
    
    // إزالة المسافات والفواصل
    String cleanPhone = value.trim().replaceAll(RegExp(r'[\s\-]'), '');
    
    // التحقق من أن الرقم يبدأ بـ 05
    if (!cleanPhone.startsWith('05')) {
      return 'يجب أن يبدأ الرقم بـ 05';
    }
    
    // التحقق من طول الرقم (10 أرقام بعد 05)
    if (cleanPhone.length != 10) {
      return 'رقم الجوال يجب أن يكون 10 أرقام (05XXXXXXXX)';
    }
    
    // التحقق من أن كل الأحرف أرقام
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
      return 'يجب أن يحتوي الرقم على أرقام فقط';
    }
    
    return null;
  }

  String _formatPhoneNumber(String value) {
    // إزالة كل شيء ما عدا الأرقام
    String digits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // التأكد من أن الرقم يبدأ بـ 05
    if (digits.length > 0 && !digits.startsWith('05')) {
      if (digits.startsWith('5')) {
        digits = '0' + digits;
      } else if (!digits.startsWith('0')) {
        digits = '05' + digits;
      }
    }
    
    // تحديد الطول الأقصى (10 أرقام)
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }
    
    return digits;
  }

  Future<void> _sendOTP() async {
    // التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phone = _phoneController.text.trim();
    final error = _validatePhone(phone);
    if (error != null) {
      setState(() {
        _phoneError = error;
      });
      _showError(error);
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendOTP(
        phoneNumber: _phoneController.text.trim(),
        onCodeSent: (String verificationId) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          // الانتقال إلى شاشة التحقق مع إرسال verificationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyScreen(
                verificationId: verificationId,
                phoneNumber: _phoneController.text.trim(),
              ),
            ),
          );
        },
        onError: (String error) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          _showError(error);
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showError('حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى');
      print('Error in _sendOTP: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontFamily: 'IBMPlex'),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back_1.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 30,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_1.png', width: 170),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('من فضلك ادخل رقم جوالك',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 20,
                          fontFamily: 'IBMPlex',
                        ))
                  ],
                ),                
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          // تنسيق تلقائي
                          final formatted = _formatPhoneNumber(value);
                          if (formatted != value) {
                            _phoneController.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                          // إزالة الخطأ عند البدء بالكتابة
                          if (_phoneError != null && value.isNotEmpty) {
                            setState(() {
                              _phoneError = null;
                            });
                          }
                        },
                        validator: _validatePhone,
                        autofocus: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _phoneError != null ? Colors.red : AppColors.borderLight,
                              width: _phoneError != null ? 2 : 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: _phoneError != null ? Colors.red : AppColors.borderLight,
                              width: _phoneError != null ? 2 : 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          hintText: '05XXXXXXXX',
                          hintStyle: TextStyle(
                            color: AppColors.textPlaceholder,
                            fontFamily: 'IBMPlex',
                          ),
                          prefixText: '+966 ',
                          prefixStyle: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'IBMPlex',
                            fontWeight: FontWeight.w500,
                          ),
                          errorText: _phoneError,
                          errorStyle: TextStyle(
                            fontFamily: 'IBMPlex',
                            fontSize: 12,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: TextStyle(
                          fontFamily: 'IBMPlex',
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('هل لديك حساب',
                //         style: TextStyle(
                //             color: Color(0XFF575757),
                //             fontSize: 20,
                //             ))
                //   ],
                // ),
                SizedBox(
                  height: 180,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.iconColor),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'جاري الإرسال...',
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontSize: 14,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _sendOTP();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.arrow_back_ios, size: 18, color: AppColors.iconColor),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _sendOTP();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              child: Text(
                                'التالي',
                                style: TextStyle(
                                  color: AppColors.iconColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlex',
                                ),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

}
