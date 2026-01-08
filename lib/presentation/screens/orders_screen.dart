import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamra/presentation/screens/order_screen.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';
import 'package:tamra/services/orders_service.dart';
import 'package:tamra/constants/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrdersService _ordersService = OrdersService();

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper method to get responsive font size
  double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return baseSize * 0.85; // Small phones
    } else if (width < 400) {
      return baseSize * 0.9; // Medium phones
    }
    return baseSize; // Large phones and tablets
  }

  // Helper widget to display price with riyal symbol
  Widget _buildPriceWithSymbol(BuildContext context, double price,
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    final effectiveFontSize = fontSize ?? _getResponsiveFontSize(context, 18);
    final effectiveFontWeight = fontWeight ?? FontWeight.w700;
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

  Widget _buildOrdersList(String? status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ordersService.getClientOrders(status: status),
      builder: (context, snapshot) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 400;
        final isVerySmallScreen = screenWidth < 360;
        if (snapshot.connectionState == ConnectionState.waiting) {
          final isSmallScreen = MediaQuery.of(context).size.width < 400;
          final isVerySmallScreen = MediaQuery.of(context).size.width < 360;

          return ListView(
            children: [
              SizedBox(height: 15),
              ...List.generate(3, (index) {
                if (isVerySmallScreen) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 16,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 14,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors.borderGray,
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color(0XFFE0E0E0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomGradientDivider(),
                      SizedBox(height: 10),
                    ],
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 5 : 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: isSmallScreen ? 3 : 2,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 4 : 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: isSmallScreen ? 3 : 2,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 4 : 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: isSmallScreen ? 4 : 3,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 4 : 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: isSmallScreen ? 4 : 3,
                            child: Container(
                              height: 20,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 4 : 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomGradientDivider(),
                    SizedBox(height: 10),
                  ],
                );
              }),
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
                      : 'حدث خطأ في تحميل الطلبات',
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
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppColors.borderLight,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'لا توجد طلبات',
                    style: TextStyle(
                      color: AppColors.textMedium,
                      fontSize: 20,
                      fontFamily: 'IBMPlex',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    status == 'cancelled'
                        ? 'لا توجد طلبات ملغاة'
                        : status == 'delivered'
                            ? 'لا توجد طلبات تم تسليمها'
                            : 'لا توجد طلبات حالية',
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

        // للتبويب الأول (حالية)، نعرض الطلبات التي ليست delivered أو cancelled
        var orders = snapshot.data!.docs;
        if (status == null) {
          orders = orders.where((doc) {
            final orderStatus =
                (doc.data() as Map<String, dynamic>)['status'] as String?;
            return orderStatus != 'delivered' && orderStatus != 'cancelled';
          }).toList();
        }

        // ترتيب الطلبات حسب createdAt (الأحدث أولاً)
        orders.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aCreatedAt = aData['createdAt'] as Timestamp?;
          final bCreatedAt = bData['createdAt'] as Timestamp?;

          if (aCreatedAt == null && bCreatedAt == null) return 0;
          if (aCreatedAt == null) return 1;
          if (bCreatedAt == null) return -1;

          return bCreatedAt.compareTo(aCreatedAt); // descending
        });

        return ListView(
          children: [
            SizedBox(height: 15),
            ...orders.map((doc) {
              final order = doc.data() as Map<String, dynamic>;
              final orderId = doc.id;
              final orderNumber = order['orderNumber'] as String? ??
                  '#${orderId.substring(0, 6)}';
              final total = (order['total'] as num?)?.toDouble() ?? 0.0;
              final createdAt = order['createdAt'] as Timestamp?;

              // Use different layout for very small screens
              if (isVerySmallScreen)
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orderNumber,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: _getResponsiveFontSize(context, 16),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'IBMPlex',
                                ),
                              ),
                              _buildPriceWithSymbol(
                                context,
                                total,
                                fontSize: _getResponsiveFontSize(context, 18),
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(createdAt),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: _getResponsiveFontSize(context, 14),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlex',
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.buttonAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isVerySmallScreen ? 12 : 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size(0, 36),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderScreen(orderId: orderId),
                                    ),
                                  );
                                },
                                child: Text(
                                  'تفاصيل',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        _getResponsiveFontSize(context, 13),
                                    fontFamily: 'IBMPlex',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomGradientDivider(),
                    ),
                  ],
                );

              // Standard layout for larger screens
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 5 : 10),
                    child: Row(
                      children: [
                        // رقم الطلب والسعر في بطاقة واحدة
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.borderLight.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // رقم الطلب
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'رقم الطلب',
                                        style: TextStyle(
                                          color: AppColors.textPlaceholder,
                                          fontSize: _getResponsiveFontSize(context, 11),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'IBMPlex',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        orderNumber,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: _getResponsiveFontSize(context, 16),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'IBMPlex',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                // السعر
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'الإجمالي',
                                        style: TextStyle(
                                          color: AppColors.textPlaceholder,
                                          fontSize: _getResponsiveFontSize(context, 11),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'IBMPlex',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      _buildPriceWithSymbol(
                                        context,
                                        total,
                                        fontSize: _getResponsiveFontSize(context, 18),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // التاريخ والزر
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDate(createdAt),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: _getResponsiveFontSize(context, 12),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'IBMPlex',
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: isSmallScreen ? 80 : 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.buttonAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  minimumSize: Size(0, 40),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderScreen(orderId: orderId),
                                    ),
                                  );
                                },
                                child: Text(
                                  'تفاصيل',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: _getResponsiveFontSize(context, 14),
                                    fontFamily: 'IBMPlex',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomGradientDivider(),
                  ),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.white,
              toolbarHeight: kToolbarHeight,
              leadingWidth: MediaQuery.of(context).size.width < 360 ? 250 : 300,
              leading: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width < 360 ? 10 : 20),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(
                        color: AppColors.iconColor,
                        Icons.arrow_back_rounded,
                        size: MediaQuery.of(context).size.width < 360
                            ? 26.0
                            : 28.0,
                      ),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width < 360 ? 10 : 20),
                  Text(
                    'طلباتي',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: _getResponsiveFontSize(context, 20),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlex',
                    ),
                  ),
                ],
              ),
              bottom: TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: [
                  Tab(
                    child: Text(
                      'حالية',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlex',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'ملغية',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlex',
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'تم التسليم',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlex',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Tab 1: حالية (pending, confirmed, preparing, ready)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildOrdersList(
                      null), // null = all orders, ثم نفلتر في الواجهة
                ),
                // Tab 2: ملغية (cancelled)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildOrdersList('cancelled'),
                ),
                // Tab 3: تم التسليم (delivered)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildOrdersList('delivered'),
                ),
              ],
            )),
      ),
    );
  }

  startTime() async {
    // TODO: Implement if needed
  }

  route() {
    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => LoginScreen()
    //   )
    // );
  }
}
