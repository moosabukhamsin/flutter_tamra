import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tamra/presentation/screens/Provider_screen.dart';
import 'package:tamra/presentation/screens/add_address_screen.dart';
import 'package:tamra/services/client_products_service.dart';
import 'package:tamra/services/vendors_service.dart';
import 'package:tamra/services/addresses_service.dart';
import 'package:tamra/providers/cart_provider.dart';
import 'package:tamra/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';
import 'package:tamra/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClientProductsService _productsService = ClientProductsService();
  final VendorsService _vendorsService = VendorsService();
  final AddressesService _addressesService = AddressesService();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int _selected = 0; // 0 = الكل، 1 = فواكه، 2 = خضار، إلخ
  String? _selectedCategory;
  String? _selectedAddressId;
  String _searchQuery = '';
  int _productsLoadingKey = 0;
  Timer? _searchDebounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _updateQuantity(
      String productId, int delta, Map<String, dynamic> product) async {
    // إضافة/تحديث المنتج في السلة مباشرة
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = cartProvider.cart.getItem(productId);
    final currentQuantity = cartItem?.quantity ?? 0;
    final newQuantity = currentQuantity + delta;

    if (newQuantity > 0) {
      // إذا كان المنتج موجود بالفعل، استخدم updateQuantity
      if (cartItem != null) {
        HapticFeedback.selectionClick();
        cartProvider.updateQuantity(productId, newQuantity);
      } else {
        // إذا كان المنتج غير موجود، أضفه جديد
        HapticFeedback.mediumImpact();
        final newItem = CartItem(
          productId: productId,
          nameAr: product['nameAr'] ?? '',
          nameEn: product['nameEn'] ?? '',
          price: (product['price'] as num?)?.toDouble() ?? 0.0,
          packagingWeight: product['packagingWeight'] ?? '',
          imageUrl: product['imageUrl'] ?? '',
          vendorId: product['vendorId'] ?? '',
          quantity: newQuantity,
        );
        cartProvider.addItem(newItem);
        // رسالة نجاح عند الإضافة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تمت إضافة ${product['nameAr'] ?? 'المنتج'} إلى السلة',
                    style: TextStyle(fontFamily: 'IBMPlex'),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // طلب تأكيد قبل الحذف إذا كانت الكمية الحالية > 0
      if (currentQuantity > 0) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 24),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'حذف المنتج',
                      style: TextStyle(
                        fontFamily: 'IBMPlex',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'هل أنت متأكد من حذف ${product['nameAr'] ?? 'هذا المنتج'} من السلة؟',
                style: TextStyle(
                  fontFamily: 'IBMPlex',
                  fontSize: 16,
                ),
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
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'حذف',
                    style: TextStyle(fontFamily: 'IBMPlex'),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmed == true) {
          cartProvider.removeItem(productId);
        }
      } else {
        cartProvider.removeItem(productId);
      }
    }
  }

  void _selectCategory(int categoryIndex) {
    setState(() {
      // إذا كانت الفئة المحددة هي نفس الفئة النشطة حالياً، قم بإلغاء الفلتر
      if (_selected == categoryIndex) {
        _selected = 0;
        _selectedCategory = null; // الكل
      } else {
        _selected = categoryIndex;
        // تحديد الفئة حسب الاختيار
        switch (categoryIndex) {
          case 1:
            _selectedCategory = 'فواكه';
            break;
          case 2:
            _selectedCategory = 'خضار';
            break;
          case 3:
            _selectedCategory = 'ورقيات';
            break;
          default:
            _selectedCategory = null; // الكل
        }
      }
    });
  }

  Widget _buildCategoryFilter({
    required int categoryIndex,
    required String categoryName,
    required String iconPath,
    required String iconLightPath,
    double borderWidth = 1.0,
  }) {
    final isSelected = _selected == categoryIndex;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectCategory(categoryIndex),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: borderWidth,
              style: BorderStyle.solid,
            ),
            color: isSelected ? AppColors.primary : AppColors.background,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isSelected ? iconLightPath : iconPath,
                height: 30,
              ),
              SizedBox(width: 10),
              Text(
                categoryName,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPlaceholder,
                  fontSize: 18,
                  fontFamily: 'IBMPlex',
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = 0;
                      _selectedCategory = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    // أثناء التحميل، عرض placeholder
    if (!snapshot.hasData) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Row(
          key: ValueKey('address_loading'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.borderGray,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              color: AppColors.accentBlue,
              Icons.keyboard_arrow_down,
              size: 25.0,
            ),
          ],
        );
      }

      if (snapshot.hasError) {
        final error = snapshot.error;
        final isNetworkError = error.toString().contains('network') ||
            error.toString().contains('connection') ||
            error.toString().contains('timeout') ||
            error.toString().contains('SocketException') ||
            error.toString().contains('Failed host lookup');

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isNetworkError ? null : () async {
              HapticFeedback.lightImpact();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddressScreen(),
                ),
              );
              // إعادة تحميل العناوين بعد العودة
              if (result == true && mounted) {
                setState(() {});
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isNetworkError ? null : Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isNetworkError ? Icons.wifi_off : Icons.add_location_alt_outlined,
                    size: 16,
                    color: isNetworkError ? Colors.red : AppColors.primary,
                  ),
                  SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      key: ValueKey('address_error'),
                      isNetworkError ? 'لا يوجد اتصال' : 'أضف عنوان التوصيل',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isNetworkError ? Colors.red : AppColors.primary,
                        fontFamily: 'IBMPlex',
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            HapticFeedback.lightImpact();
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddAddressScreen(),
              ),
            );
            // إعادة تحميل العناوين بعد العودة
            if (result == true && mounted) {
              setState(() {});
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_location_alt_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    key: ValueKey('address_empty'),
                    'أضف عنوان التوصيل',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontFamily: 'IBMPlex',
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final addresses = snapshot.data!.docs;

    // تحديد العنوان الافتراضي إذا لم يكن هناك عنوان محدد
    String? currentAddressId = _selectedAddressId;
    if (currentAddressId == null ||
        !addresses.any((doc) => doc.id == currentAddressId)) {
      if (addresses.isNotEmpty) {
        // البحث عن العنوان الافتراضي
        try {
          final defaultAddress = addresses.firstWhere(
            (doc) => (doc.data() as Map<String, dynamic>)['isDefault'] == true,
          );
          currentAddressId = defaultAddress.id;
        } catch (e) {
          // إذا لم يوجد عنوان افتراضي، استخدم أول عنوان
          currentAddressId = addresses.first.id;
        }

        // تحديث الحالة بعد إتمام البناء
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _selectedAddressId != currentAddressId) {
            setState(() {
              _selectedAddressId = currentAddressId;
            });
          }
        });
      }
    }

    return Material(
      color: Colors.transparent,
      child: DropdownButton<String>(
        key: ValueKey('addresses_${currentAddressId ?? 'none'}'),
        value: currentAddressId,
        underline: SizedBox.shrink(),
        isExpanded: true,
        icon: Icon(
          color: AppColors.accentBlue,
          Icons.keyboard_arrow_down,
          size: 25.0,
        ),
        items: addresses.map((doc) {
          final addressData = doc.data() as Map<String, dynamic>;
          final addressId = doc.id;
          final addressName = addressData['addressName'] ?? 'عنوان غير محدد';

          return DropdownMenuItem<String>(
            value: addressId,
            child: Text(
              addressName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontFamily: 'IBMPlex',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedAddressId = newValue;
          });
        },
      ),
    );
  }

  Widget _buildVendorsContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    // عرض placeholder إذا لم تكن هناك بيانات بعد
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // عرض placeholder أثناء التحميل
        return SizedBox(
          key: ValueKey('vendors_loading'),
          height: 90,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(3, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.borderGray,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      }

      if (snapshot.hasError) {
        final error = snapshot.error;
        final isNetworkError = error.toString().contains('network') ||
            error.toString().contains('connection') ||
            error.toString().contains('timeout') ||
            error.toString().contains('SocketException') ||
            error.toString().contains('Failed host lookup');

        return SizedBox(
          key: ValueKey('vendors_error'),
          height: 90,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isNetworkError ? Icons.wifi_off : Icons.error_outline,
                  size: 24,
                  color: Colors.red,
                ),
                SizedBox(height: 4),
                Text(
                  isNetworkError ? 'لا يوجد اتصال' : 'حدث خطأ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // لا يوجد موردين
      return SizedBox(
        key: ValueKey('vendors_empty'),
        height: 90,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.store_outlined,
                size: 32,
                color: AppColors.borderLight,
              ),
              SizedBox(height: 8),
              Text(
                'لا يوجد موردين',
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 14,
                  fontFamily: 'IBMPlex',
                ),
              ),
            ],
          ),
        ),
      );
    }

    final vendors = snapshot.data!.docs;

    return SizedBox(
      key: ValueKey('vendors_${vendors.length}'),
      height: 90,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...vendors.map((vendorDoc) {
                final vendorData = vendorDoc.data() as Map<String, dynamic>;
                final vendorId = vendorDoc.id;
                final vendorImage =
                    vendorData['imageUrl'] ?? vendorData['logoUrl'] ?? '';

                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderScreen(
                              vendorId: vendorId,
                              vendorData: vendorData,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: vendorImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                vendorImage,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/store1.png',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            )
                          : Image.asset(
                              'assets/images/store1.png',
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/images/logo_1.png', width: 180),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _vendorsService.getAllVendors(),
                builder: (context, snapshot) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: _buildVendorsContent(snapshot),
                  );
                },
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.accentBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.accentBlue,
                            size: 20.0,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'التوصيل إلى',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlex',
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _addressesService.getClientAddresses(),
                        builder: (context, snapshot) {
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            child: _buildAddressContent(snapshot),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    // TODO: إعادة تفعيل وقت التوصيل عند الحاجة
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.primary.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(
                    //       color: AppColors.primary.withOpacity(0.2),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.access_time_rounded,
                    //         size: 16.0,
                    //         color: AppColors.primary,
                    //       ),
                    //       SizedBox(width: 6),
                    //       Text(
                    //         '4 ساعة',
                    //         style: TextStyle(
                    //           color: AppColors.primary,
                    //           fontSize: 13,
                    //           fontWeight: FontWeight.w600,
                    //           fontFamily: 'IBMPlex',
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: AppColors.borderLight,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: _searchQuery.isNotEmpty 
                                ? AppColors.primary 
                                : AppColors.textPlaceholder,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: AppColors.textPlaceholder,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                    HapticFeedback.lightImpact();
                                  },
                                )
                              : null,
                          hintText: 'البحث عن منتج...',
                          hintStyle: TextStyle(
                            color: AppColors.textPlaceholder,
                            fontFamily: 'IBMPlex',
                          ),
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'IBMPlex',
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                        onChanged: (value) {
                          // Debounce البحث لتقليل عدد الطلبات
                          _searchDebounceTimer?.cancel();
                          _searchDebounceTimer = Timer(Duration(milliseconds: 500), () {
                            if (mounted) {
                              setState(() {
                                _searchQuery = value.trim();
                              });
                            }
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCategoryFilter(
                      categoryIndex: 1,
                      categoryName: 'فواكه',
                      iconPath: 'assets/images/ic_cat_1.png',
                      iconLightPath: 'assets/images/ic_cat_1_light.png',
                      borderWidth: 2.0,
                    ),
                    SizedBox(width: 10),
                    _buildCategoryFilter(
                      categoryIndex: 2,
                      categoryName: 'خضار',
                      iconPath: 'assets/images/ic_cat_2.png',
                      iconLightPath: 'assets/images/ic_cat_2_light.png',
                      borderWidth: 1.0,
                    ),
                    SizedBox(width: 10),
                    _buildCategoryFilter(
                      categoryIndex: 3,
                      categoryName: 'ورقيات',
                      iconPath: 'assets/images/ic_cat_3.png',
                      iconLightPath: 'assets/images/ic_cat_3_light.png',
                      borderWidth: 1.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.borderLight,
                            width: 1.0,
                            style: BorderStyle.solid),
                        color: AppColors.background,
                      ),
                      child: Row(children: [
                        Image.asset('assets/images/ic_cat_4.png', height: 30),
                        SizedBox(
                          width: 10,
                        ),
                        Text('حمضيات',
                            style: TextStyle(
                              color: AppColors.textPlaceholder,
                              fontSize: 18,
                              fontFamily: 'IBMPlex',
                            )),
                      ]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(
                    //         color: AppColors.borderLight,
                    //         width: 1.0,
                    //         style: BorderStyle.solid),
                    //     color: Colors.white,
                    //   ),
                    //   child: Row(children: [
                    //     Image.asset('assets/images/ic_cat_5.png', height: 30),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text('استوائة',
                    //         style: TextStyle(
                    //           color: AppColors.textPlaceholder,
                    //           fontSize: 18,
                    //         )),
                    //   ]),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     border: Border.all(
                    //         color: AppColors.borderLight,
                    //         width: 1.0,
                    //         style: BorderStyle.solid),
                    //     color: Colors.white,
                    //   ),
                    //   child: Row(children: [
                    //     Image.asset('assets/images/ic_cat_6.png', height: 30),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text('محليه',
                    //         style: TextStyle(
                    //           color: AppColors.textPlaceholder,
                    //           fontSize: 18,
                    //         )),
                    //   ]),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    // تحديث البيانات عن طريق إعادة بناء StreamBuilder
                    setState(() {
                      _productsLoadingKey++;
                    });
                    // انتظار قصير لإظهار تأثير السحب
                    await Future.delayed(Duration(milliseconds: 500));
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.background,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsService.getAllActiveProducts(
                      category: _selectedCategory,
                    ),
                    builder: (context, snapshot) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _buildProductsContent(snapshot),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    // أثناء التحميل
    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      _productsLoadingKey++;
      return ListView(
        key: ValueKey(
            'products_loading_${_selectedCategory ?? 'all'}_$_productsLoadingKey'),
        children: List.generate(5, (index) {
          return Column(
            children: [
              CustomGradientDivider(),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.borderGray,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  height: 16,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 16,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.backgroundGray,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    border: Border.all(
                                      color: AppColors.borderLight,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                              ],
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
        }),
      );
    }

    if (snapshot.hasError) {
      final error = snapshot.error;
      final isNetworkError = error.toString().contains('network') ||
          error.toString().contains('connection') ||
          error.toString().contains('timeout') ||
          error.toString().contains('SocketException') ||
          error.toString().contains('Failed host lookup');

      return Center(
        key: ValueKey('products_error_${snapshot.error.hashCode}'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNetworkError ? Icons.wifi_off : Icons.error_outline,
              size: 64,
              color: AppColors.borderLight,
            ),
            SizedBox(height: 16),
            Text(
              isNetworkError
                  ? 'لا يوجد اتصال بالإنترنت'
                  : 'حدث خطأ في تحميل المنتجات',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textMedium,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlex',
              ),
            ),
            SizedBox(height: 8),
            Text(
              isNetworkError
                  ? 'يرجى التحقق من اتصالك بالإنترنت'
                  : 'يرجى المحاولة مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPlaceholder,
                fontFamily: 'IBMPlex',
              ),
            ),
          ],
        ),
      );
    }

    if (snapshot.data!.docs.isEmpty) {
      return Center(
        key: ValueKey('products_empty'),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: AppColors.borderLight,
              ),
              SizedBox(height: 20),
              Text(
                'لا توجد منتجات',
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 20,
                  fontFamily: 'IBMPlex',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _selectedCategory != null
                    ? 'لا توجد منتجات في هذه الفئة حالياً'
                    : 'لا توجد منتجات متاحة حالياً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPlaceholder,
                  fontSize: 14,
                  fontFamily: 'IBMPlex',
                ),
              ),
            ],
          ),
        ),
      );
    }

    var products = snapshot.data!.docs;

    // فلترة المنتجات حسب البحث
    if (_searchQuery.isNotEmpty) {
      products = products.where((doc) {
        final productData = doc.data() as Map<String, dynamic>;
        final nameAr = (productData['nameAr'] ?? '').toString().toLowerCase();
        final nameEn = (productData['nameEn'] ?? '').toString().toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        return nameAr.contains(searchLower) || nameEn.contains(searchLower);
      }).toList();
    }

    // إذا كانت نتائج البحث فارغة
    if (_searchQuery.isNotEmpty && products.isEmpty) {
      return Center(
        key: ValueKey('products_search_empty_$_searchQuery'),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: AppColors.borderLight,
              ),
              SizedBox(height: 20),
              Text(
                'لا توجد نتائج',
                style: TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 20,
                  fontFamily: 'IBMPlex',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'لم يتم العثور على منتجات تطابق "$_searchQuery"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPlaceholder,
                  fontSize: 14,
                  fontFamily: 'IBMPlex',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return ListView(
          key: ValueKey(
              'products_${products.length}_${_selectedCategory ?? 'all'}_$_searchQuery'),
          children: [
            ...products.map((doc) {
              final product = doc.data() as Map<String, dynamic>;
              final productId = doc.id;
              final quantity =
                  cartProvider.cart.getItem(productId)?.quantity ?? 0;

              final nameAr = product['nameAr'] as String? ?? '';
              final price = product['price'] as num? ?? 0.0;
              final packagingWeight =
                  product['packagingWeight'] as String? ?? '';
              final imageUrl = product['imageUrl'] as String? ?? '';

              return Column(
                children: [
                  CustomGradientDivider(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: AppColors.borderGray,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: AppColors.backgroundGray,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Image.asset(
                                              'assets/images/pr_1.png',
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundGray,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Image.asset(
                                          'assets/images/pr_1.png',
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameAr,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'IBMPlex',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '${price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'IBMPlex',
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Image.asset(
                                          'assets/images/riyal_symbol.png',
                                          width: 14,
                                          height: 14,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                    if (packagingWeight.isNotEmpty) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        packagingWeight,
                                        style: TextStyle(
                                          color: AppColors.textPlaceholder,
                                          fontSize: 13,
                                          fontFamily: 'IBMPlex',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // إذا كانت الكمية 0، عرض زر إضافة مباشر
                              if (quantity == 0)
                                Flexible(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        _updateQuantity(productId, 1, product);
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: AppColors.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.25),
                                              spreadRadius: 0,
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add_shopping_cart_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'إضافة',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'IBMPlex',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                // إذا كانت الكمية أكبر من 0، عرض أزرار + و - و الكمية
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
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
                                      // زر الإضافة (على اليمين في RTL)
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.selectionClick();
                                            _updateQuantity(productId, 1, product);
                                          },
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add_rounded,
                                              color: AppColors.primary,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // الكمية في المنتصف
                                      Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints(
                                          minWidth: 50,
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        height: 44,
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
                                          quantity.toString(),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'IBMPlex',
                                          ),
                                        ),
                                      ),
                                      // زر النقصان/الحذف (على اليسار في RTL)
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            HapticFeedback.selectionClick();
                                            _updateQuantity(productId, -1, product);
                                          },
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: quantity == 1 
                                                  ? Colors.red.withOpacity(0.1)
                                                  : AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                            ),
                                            child: Icon(
                                              quantity == 1 
                                                  ? Icons.delete_outline_rounded
                                                  : Icons.remove_rounded,
                                              color: quantity == 1 
                                                  ? Colors.red
                                                  : AppColors.primary,
                                              size: 24,
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
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
