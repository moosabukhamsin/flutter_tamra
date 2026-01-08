import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamra/presentation/screens/order_success_screen.dart';
import 'package:tamra/presentation/screens/addresses_screen.dart';
import 'package:tamra/presentation/screens/layout_screen.dart';
import 'package:tamra/services/orders_service.dart';
import 'package:tamra/services/auth_service.dart';
import 'package:tamra/providers/cart_provider.dart';
import 'package:tamra/models/cart_item.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';
import 'package:tamra/constants/app_colors.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);
  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final OrdersService _ordersService = OrdersService();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String? _selectedAddressId;
  String? _clientAddress;
  String? _clientAddressName;
  bool _hasAddresses = false;
  bool _isLoadingAddresses = true;

  @override
  void initState() {
    super.initState();
    _loadDefaultAddress();
  }

  // Helper widget to display price with riyal symbol
  Widget _buildPriceWithSymbol(BuildContext context, double price,
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    final effectiveFontSize = fontSize ?? 16.0;
    final effectiveFontWeight = fontWeight ?? FontWeight.w600;
    final effectiveColor = color ?? AppColors.primary;
    final symbolSize = effectiveFontSize * 0.9;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            price.toStringAsFixed(2),
            style: TextStyle(
              color: effectiveColor,
              fontSize: effectiveFontSize,
              fontWeight: effectiveFontWeight,
              fontFamily: 'IBMPlex',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 3),
        Image.asset(
          'assets/images/riyal_symbol.png',
          width: symbolSize,
          height: symbolSize,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Future<void> _loadDefaultAddress() async {
    final user = _authService.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _isLoadingAddresses = false;
          _hasAddresses = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingAddresses = true;
      });
    }

    try {
      // جلب العنوان الافتراضي
      final addressesSnapshot = await _firestore
          .collection('clients')
          .doc(user.uid)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (addressesSnapshot.docs.isNotEmpty && mounted) {
        final addressData = addressesSnapshot.docs.first.data();
        setState(() {
          _selectedAddressId = addressesSnapshot.docs.first.id;
          _clientAddress = addressData['addressDescription'] ?? '';
          _clientAddressName = addressData['addressName'] ?? '';
          _hasAddresses = true;
          _isLoadingAddresses = false;
        });
      } else {
        // إذا لم يوجد عنوان افتراضي، جلب أول عنوان
        final allAddressesSnapshot = await _firestore
            .collection('clients')
            .doc(user.uid)
            .collection('addresses')
            .limit(1)
            .get();

        if (allAddressesSnapshot.docs.isNotEmpty && mounted) {
          final addressData = allAddressesSnapshot.docs.first.data();
          setState(() {
            _selectedAddressId = allAddressesSnapshot.docs.first.id;
            _clientAddress = addressData['addressDescription'] ?? '';
            _clientAddressName = addressData['addressName'] ?? '';
            _hasAddresses = true;
            _isLoadingAddresses = false;
          });
        } else if (mounted) {
          // لا يوجد عناوين على الإطلاق
          setState(() {
            _hasAddresses = false;
            _selectedAddressId = null;
            _clientAddress = null;
            _clientAddressName = null;
            _isLoadingAddresses = false;
          });
        }
      }
    } catch (e) {
      // Error loading address
      if (mounted) {
        setState(() {
          _isLoadingAddresses = false;
          _hasAddresses = false;
        });
      }
    }
  }

  Future<void> _selectAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressesScreen(
          selectedAddressId: _selectedAddressId,
          onAddressSelected: (addressId, addressName, addressDescription) {
            setState(() {
              _selectedAddressId = addressId;
              _clientAddress = addressDescription;
              _clientAddressName = addressName;
              _hasAddresses = true;
            });
          },
        ),
      ),
    );

    // إعادة تحميل العنوان بعد العودة
    if (result == true) {
      _loadDefaultAddress();
    }
  }

  Future<void> _createOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cart = cartProvider.cart;

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'السلة فارغة',
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
      return;
    }

    if (cart.vendorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'خطأ في تحديد البائع',
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
      return;
    }

    if (_selectedAddressId == null ||
        _clientAddress == null ||
        _clientAddress!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.location_off, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'يرجى اختيار عنوان التوصيل',
                  style: TextStyle(fontFamily: 'IBMPlex'),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    // طلب تأكيد قبل إنشاء الطلب
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.shopping_cart_checkout, color: AppColors.primary, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تأكيد الطلب',
                  style: TextStyle(
                    fontFamily: 'IBMPlex',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'هل أنت متأكد من تأكيد الطلب؟',
                style: TextStyle(
                  fontFamily: 'IBMPlex',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإجمالي:',
                      style: TextStyle(
                        fontFamily: 'IBMPlex',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cart.total.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'IBMPlex',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 3),
                        Image.asset(
                          'assets/images/riyal_symbol.png',
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: 'IBMPlex',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تأكيد الطلب',
                style: TextStyle(fontFamily: 'IBMPlex'),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _ordersService.createOrder(
      vendorId: cart.vendorId!,
      items: cart.toOrderItemsList(),
      deliveryAddress: _clientAddress!,
      deliveryAddressName: _clientAddressName ?? '',
      deliveryFee: cart.deliveryFee,
      deliveryAddressId: _selectedAddressId,
    );

    setState(() {
      _isLoading = false;
    });

    if (result['success'] == true && mounted) {
      // حفظ البيانات قبل مسح السلة
      final savedItems = List<CartItem>.from(cart.items);
      final savedDeliveryAddress = _clientAddress ?? '';
      final savedDeliveryAddressName = _clientAddressName ?? '';
      final savedDeliveryFee = cart.deliveryFee;
      final savedTotal = cart.total;

      cartProvider.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(
            deliveryAddress: savedDeliveryAddress,
            deliveryAddressName: savedDeliveryAddressName,
            items: savedItems,
            deliveryFee: savedDeliveryFee,
            total: savedTotal,
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  result['message'] ?? 'فشل إنشاء الطلب',
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
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text('السلة',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'IBMPlex',
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // البائع - بطاقة منفصلة
                          if (cart.vendorId != null)
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: FutureBuilder<DocumentSnapshot?>(
                                future: _firestore
                                    .collection('vendors')
                                    .doc(cart.vendorId)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.borderGray,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Container(
                                          height: 18,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: AppColors.borderGray,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  String vendorName = 'البائع';
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.exists) {
                                    final data = snapshot.data!.data()
                                        as Map<String, dynamic>?;
                                    vendorName = data?['businessName'] ??
                                        data?['nameAr'] ??
                                        data?['name'] ??
                                        data?['phoneNumber'] ??
                                        'البائع';
                                  }
                                  return Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary
                                              .withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.store,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'المتجر',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textPlaceholder,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'IBMPlex',
                                            ),
                                          ),
                                            SizedBox(height: 4),
                                            Text(
                                              vendorName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                                fontSize: 16,
                                                fontFamily: 'IBMPlex',
                                              ),
                                            ),
                                        ],
                                      ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          // العنوان - بطاقة منفصلة
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderGray,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            AppColors.accentBlue.withOpacity(0.1),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: AppColors.accentBlue,
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'عنوان التوصيل',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                              fontSize: 16,
                                              fontFamily: 'IBMPlex',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          // اسم العنوان
                                          if (_isLoadingAddresses)
                                            // Placeholder أثناء التحميل
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 16,
                                                  width: 120,
                                                  margin: EdgeInsets.only(
                                                      bottom: 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: AppColors.borderGray,
                                                  ),
                                                ),
                                                Container(
                                                  height: 14,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: AppColors.borderGray,
                                                  ),
                                                ),
                                              ],
                                            )
                                          else if (!_hasAddresses)
                                            // لا يوجد عناوين - عرض رسالة
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_off_outlined,
                                                      size: 16,
                                                      color: AppColors.textPlaceholder,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'لم يتم تحديد عنوان',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: AppColors.textPlaceholder,
                                                        fontSize: 14,
                                                        fontFamily: 'IBMPlex',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'أضف عنوان لتوصيل طلبك',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.textLight,
                                                    fontSize: 12,
                                                    fontFamily: 'IBMPlex',
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (_clientAddressName !=
                                                        null &&
                                                    _clientAddressName!
                                                        .isNotEmpty)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    child: Text(
                                                      _clientAddressName!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                if (_clientAddressName !=
                                                        null &&
                                                    _clientAddressName!
                                                        .isNotEmpty)
                                                  SizedBox(height: 8),
                                                Text(
                                                  _clientAddress ??
                                                      'لم يتم تحديد العنوان',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textPrimary,
                                                    fontSize: 14,
                                                    fontFamily: 'IBMPlex',
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                // زر إضافة/تغيير العنوان
                                SizedBox(
                                  width: double.infinity,
                                  child: _isLoadingAddresses
                                      ? OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.primary,
                                            side: BorderSide(
                                              color: AppColors.primary,
                                              width: 1.5,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: null,
                                          icon: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          label: Text(
                                            'جاري التحميل...',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      : _hasAddresses
                                          ? OutlinedButton.icon(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppColors.primary,
                                                side: BorderSide(
                                                  color: AppColors.primary,
                                                  width: 1.5,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: _selectAddress,
                                              icon: Icon(Icons.edit_location_alt, size: 18),
                                              label: Text(
                                                'تغيير العنوان',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: AppColors.primary,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 10,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: _selectAddress,
                                              icon: Icon(Icons.add_location_alt, size: 18),
                                              label: Text(
                                                'إضافة عنوان',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // عنوان الأصناف
                    if (!cart.isEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'الأصناف',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'IBMPlex',
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${cart.items.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16),
                    if (!cart.isEmpty) CustomGradientDivider(),
                    if (cart.isEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 100,
                              color: AppColors.borderLight,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'السلة فارغة',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'ابدأ بإضافة المنتجات إلى السلة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textPlaceholder,
                                fontSize: 16,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                            SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                // الانتقال للصفحة الرئيسية عبر LayoutScreen
                                final layoutState = LayoutScreen.of(context);
                                if (layoutState != null) {
                                  layoutState.navigateToHome();
                                }
                              },
                              icon: Icon(Icons.shopping_bag_outlined, size: 20),
                              label: Text(
                                'تصفح المنتجات',
                                style: TextStyle(
                                  fontFamily: 'IBMPlex',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...cart.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final isLast = index == cart.items.length - 1;

                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.borderLight.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // صورة المنتج
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: item.imageUrl.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl,
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                width: 75,
                                                height: 75,
                                                color: AppColors.backgroundGray,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(
                                                        AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 75,
                                                height: 75,
                                                color: AppColors.backgroundGray,
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  color: AppColors.textPlaceholder,
                                                  size: 28,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 75,
                                            height: 75,
                                            color: AppColors.backgroundGray,
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              color: AppColors.textPlaceholder,
                                              size: 28,
                                            ),
                                          ),
                                  ),
                                  SizedBox(width: 12),
                                  // معلومات المنتج
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.nameAr,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'IBMPlex',
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (item.packagingWeight.isNotEmpty) ...[
                                          SizedBox(height: 4),
                                          Text(
                                            item.packagingWeight,
                                            style: TextStyle(
                                              color: AppColors.textPlaceholder,
                                              fontSize: 11,
                                              fontFamily: 'IBMPlex',
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        // السعر الوحدة
                                        Row(
                                          children: [
                                            Text(
                                              '${item.quantity} × ',
                                              style: TextStyle(
                                                color: AppColors.textPlaceholder,
                                                fontSize: 12,
                                                fontFamily: 'IBMPlex',
                                              ),
                                            ),
                                            _buildPriceWithSymbol(
                                              context,
                                              item.price,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        // الإجمالي
                                        Row(
                                          children: [
                                            Text(
                                              'الإجمالي:',
                                              style: TextStyle(
                                                color: AppColors.textPlaceholder,
                                                fontSize: 13,
                                                fontFamily: 'IBMPlex',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            _buildPriceWithSymbol(
                                              context,
                                              item.totalPrice,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // أزرار الكمية
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.backgroundLight,
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        // زر الإضافة
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              HapticFeedback.selectionClick();
                                              cartProvider.updateQuantity(
                                                item.productId,
                                                item.quantity + 1,
                                              );
                                            },
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight: Radius.circular(10),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: AppColors.primary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // الكمية
                                        Container(
                                          alignment: Alignment.center,
                                          width: 40,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.symmetric(
                                              vertical: BorderSide(
                                                color: AppColors.primary.withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '${item.quantity}',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'IBMPlex',
                                            ),
                                          ),
                                        ),
                                        // زر النقصان/الحذف
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              HapticFeedback.selectionClick();
                                              cartProvider.updateQuantity(
                                                item.productId,
                                                item.quantity - 1,
                                              );
                                            },
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: item.quantity == 1
                                                    ? Colors.red.withOpacity(0.1)
                                                    : AppColors.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                ),
                                              ),
                                              child: Icon(
                                                item.quantity == 1
                                                    ? Icons.delete_outline_rounded
                                                    : Icons.remove_rounded,
                                                color: item.quantity == 1
                                                    ? Colors.red
                                                    : AppColors.primary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    if (!cart.isEmpty) ...[
                      SizedBox(height: 10),
                      CustomGradientDivider(),
                    ],
                    if (!cart.isEmpty) ...[
                      SizedBox(height: 15),
                      // التوصيل
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  color: AppColors.textMedium,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'التوصيل',
                                  style: TextStyle(
                                    color: AppColors.textMedium,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlex',
                                  ),
                                ),
                              ],
                            ),
                            _buildPriceWithSymbol(
                              context,
                              cart.deliveryFee,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      // الإجمالي
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.15),
                              AppColors.primary.withOpacity(0.08),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'الإجمالي',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'IBMPlex',
                                  ),
                                ),
                              ],
                            ),
                            _buildPriceWithSymbol(
                              context,
                              cart.total,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // إخفاء زر الدفع إذا كانت السلة فارغة
                    if (!cart.isEmpty) ...[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: AppColors.primary.withOpacity(0.3),
                            ),
                            onPressed: _isLoading || _isLoadingAddresses || !_hasAddresses || _selectedAddressId == null 
                                ? null 
                                : () {
                                    HapticFeedback.mediumImpact();
                                    _createOrder();
                                  },
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Icon(
                                        Icons.payment_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text('تأكيد الطلب',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'IBMPlex',
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 10,
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
