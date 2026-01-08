import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tamra/services/client_products_service.dart';
import 'package:tamra/services/vendors_service.dart';
import 'package:tamra/providers/cart_provider.dart';
import 'package:tamra/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamra/constants/app_colors.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';

class ProviderScreen extends StatefulWidget {
  final String vendorId;
  final Map<String, dynamic> vendorData;

  const ProviderScreen({
    Key? key,
    required this.vendorId,
    required this.vendorData,
  }) : super(key: key);

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  final ClientProductsService _productsService = ClientProductsService();
  final VendorsService _vendorsService = VendorsService();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  String? _selectedCategory;
  int _selected = 0; // 0 = الكل، 1 = فواكه، 2 = خضار، إلخ
  String _searchQuery = '';
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _updateQuantity(String productId, int delta, Map<String, dynamic> product) async {
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

  // Helper widget to display price with riyal symbol
  Widget _buildPriceWithSymbol(BuildContext context, double price, {double? fontSize, FontWeight? fontWeight, Color? color}) {
    final effectiveFontSize = fontSize ?? 14.0;
    final effectiveFontWeight = fontWeight ?? FontWeight.w500;
    final effectiveColor = color ?? AppColors.textMedium;
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
          color: isSelected ? AppColors.primary : Colors.white,
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    final vendorName = widget.vendorData['businessName'] ?? 
                      widget.vendorData['name'] ?? 
                      widget.vendorData['nameAr'] ?? 
                      widget.vendorData['phoneNumber'] ?? 
                      'بائع';
    final vendorImage = widget.vendorData['imageUrl'] ?? 
                       widget.vendorData['logoUrl'] ?? 
                       '';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //  shape:Border.n
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: kToolbarHeight,
          leadingWidth: 300,
          leading: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    color: AppColors.iconColor,
                    Icons.arrow_back,
                    size: 30.0,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text(
                vendorName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlex',
                ),
              ),
            ],
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    vendorImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              vendorImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/store1.png',
                                  width: 100,
                                );
                              },
                            ),
                          )
                        : Image.asset('assets/images/store1.png', width: 100),
                    SizedBox(width: 10),
                    FutureBuilder<int>(
                      future: _vendorsService.getVendorProductsCount(widget.vendorId),
                      builder: (context, snapshot) {
                        final productsCount = snapshot.data ?? 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendorName,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                            Text(
                              '$productsCount منتج',
                              style: TextStyle(
                                color: AppColors.textPlaceholder,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                      SizedBox(width: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.borderLight,
                              width: 1.0,
                              style: BorderStyle.solid),
                          color: Colors.white,
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
                              )),
                        ]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _productsService.getVendorProducts(
                      widget.vendorId,
                      category: _selectedCategory,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView(
                          children: List.generate(5, (index) {
                            return Container(
                              padding: EdgeInsets.only(top: 15, bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    style: BorderStyle.solid,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
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

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
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
                          return RefreshIndicator(
                            key: _refreshIndicatorKey,
                            onRefresh: () async {
                              // تحديث البيانات عن طريق إعادة بناء StreamBuilder
                              setState(() {});
                              await Future.delayed(Duration(milliseconds: 500));
                            },
                            color: AppColors.primary,
                            backgroundColor: AppColors.background,
                            child: ListView(
                              children: [
                          ...products.map((doc) {
                            final product = doc.data() as Map<String, dynamic>;
                            final productId = doc.id;
                            final nameAr = product['nameAr'] as String? ?? '';
                            final price = product['price'] as num? ?? 0.0;
                            final packagingWeight = product['packagingWeight'] as String? ?? '';
                            final imageUrl = product['imageUrl'] as String? ?? '';
                            final quantity = cartProvider.cart.getItem(productId)?.quantity ?? 0;

                        return Column(
                          children: [
                            CustomGradientDivider(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                              child: Row(
                                children: [
                                  // صورة المنتج
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
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
                                          nameAr,
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
                                        if (packagingWeight.isNotEmpty) ...[
                                          SizedBox(height: 4),
                                          Text(
                                            packagingWeight,
                                            style: TextStyle(
                                              color: AppColors.textPlaceholder,
                                              fontSize: 11,
                                              fontFamily: 'IBMPlex',
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 8),
                                        _buildPriceWithSymbol(
                                          context,
                                          price.toDouble(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // إذا كانت الكمية 0، عرض زر إضافة مباشر
                                  if (quantity == 0)
                                    Material(
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
                                                color: AppColors.primary.withOpacity(0.25),
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
                                    )
                                  else
                                    // إذا كانت الكمية أكبر من 0، عرض أزرار + و - و الكمية
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
                                                _updateQuantity(productId, 1, product);
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
                                              '${quantity}',
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
                                                _updateQuantity(productId, -1, product);
                                              },
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                              child: Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: quantity == 1
                                                      ? Colors.red.withOpacity(0.1)
                                                      : AppColors.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                  ),
                                                ),
                                                child: Icon(
                                                  quantity == 1
                                                      ? Icons.delete_outline_rounded
                                                      : Icons.remove_rounded,
                                                  color: quantity == 1
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
                            ],
                          ),
                        );
                      },
                    );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
