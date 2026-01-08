import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';
import 'package:tamra/services/orders_service.dart';
import 'package:tamra/constants/app_colors.dart';

class OrderScreen extends StatefulWidget {
  final String orderId;
  const OrderScreen({Key? key, required this.orderId}) : super(key: key);
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrdersService _ordersService = OrdersService();

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

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'تم التأكيد';
      case 'preparing':
        return 'قيد التحضير';
      case 'ready':
        return 'جاهز';
      case 'delivered':
        return 'تم التسليم';
      case 'cancelled':
        return 'ملغى';
      default:
        return status ?? 'غير معروف';
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper widget to display price with riyal symbol
  Widget _buildPriceWithSymbol(BuildContext context, double price,
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    final effectiveFontSize = fontSize ?? 17.0;
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
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Icon(
                    color: AppColors.iconColor,
                    Icons.arrow_back_rounded,
                    size: 28.0,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Text(
                'حالة الطلب',
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
        body: FutureBuilder<DocumentSnapshot?>(
          future: _ordersService.getOrder(widget.orderId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 60),
                        decoration: BoxDecoration(
                          color: Color(0XFFF4F6F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 24,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 20,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0XFFF4F6F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 16,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0XFFE0E0E0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ...List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Color(0XFFF4F6F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0XFFE0E0E0),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0XFFE0E0E0),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 16,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0XFFE0E0E0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0XFFE0E0E0),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: AppColors.borderLight,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'حدث خطأ',
                          style: TextStyle(
                            color: AppColors.textMedium,
                            fontSize: 20,
                            fontFamily: 'IBMPlex',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'حدث خطأ في جلب بيانات الطلب',
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
                ),
              );
            }

            final orderData = snapshot.data!.data() as Map<String, dynamic>;
            final status = orderData['status'] as String? ?? 'pending';
            final createdAt = orderData['createdAt'] as Timestamp?;
            final items = (orderData['items'] as List<dynamic>?) ?? [];
            final deliveryFee =
                (orderData['deliveryFee'] as num?)?.toDouble() ?? 0.0;
            final total = (orderData['total'] as num?)?.toDouble() ?? 0.0;
            final vendorId = orderData['vendorId'] as String?;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      decoration: BoxDecoration(
                        color: status == 'delivered'
                            ? Colors.green.withOpacity(0.1)
                            : status == 'cancelled'
                                ? Colors.red.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: status == 'delivered'
                              ? Colors.green.withOpacity(0.2)
                              : status == 'cancelled'
                                  ? Colors.red.withOpacity(0.2)
                                  : AppColors.primary.withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: status == 'delivered'
                                  ? Colors.green
                                  : status == 'cancelled'
                                      ? Colors.red
                                      : AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (status == 'delivered'
                                          ? Colors.green
                                          : status == 'cancelled'
                                              ? Colors.red
                                              : AppColors.primary)
                                      .withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              status == 'delivered'
                                  ? Icons.check_circle_rounded
                                  : status == 'cancelled'
                                      ? Icons.cancel_rounded
                                      : Icons.pending_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _getStatusLabel(status),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'IBMPlex',
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _formatDate(createdAt),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'IBMPlex',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (vendorId != null)
                      FutureBuilder<DocumentSnapshot?>(
                        future: FirebaseFirestore.instance
                            .collection('vendors')
                            .doc(vendorId)
                            .get(),
                        builder: (context, vendorSnapshot) {
                          String vendorName = 'البائع';
                          if (vendorSnapshot.hasData &&
                              vendorSnapshot.data != null &&
                              vendorSnapshot.data!.exists) {
                            final data = vendorSnapshot.data!.data()
                                as Map<String, dynamic>?;
                            vendorName = data?['businessName'] ?? 'البائع';
                          }
                          return Container(
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderLight.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.store_rounded,
                                    color: AppColors.primary,
                                    size: 26,
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'البائع',
                                        style: TextStyle(
                                          color: AppColors.textPlaceholder,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'IBMPlex',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        vendorName,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IBMPlex',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          'الأصناف',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'IBMPlex',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    CustomGradientDivider(),
                    ...items.map<Widget>((item) {
                      final itemMap = item as Map<String, dynamic>;
                      final nameAr = itemMap['nameAr'] ?? '';
                      final quantity = itemMap['quantity'] ?? 0;
                      final price =
                          (itemMap['price'] as num?)?.toDouble() ?? 0.0;
                      final packagingWeight = itemMap['packagingWeight'] ?? '';
                      final itemTotal = quantity * price;

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nameAr,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IBMPlex',
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
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlex',
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'الكمية: $quantity',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'IBMPlex',
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'سعر الوحدة: ',
                                          style: TextStyle(
                                            color: AppColors.textPlaceholder,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'IBMPlex',
                                          ),
                                        ),
                                        _buildPriceWithSymbol(
                                          context,
                                          price,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'الإجمالي: ',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'IBMPlex',
                                          ),
                                        ),
                                        _buildPriceWithSymbol(
                                          context,
                                          itemTotal,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          CustomGradientDivider(),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'التوصيل',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlex',
                                  ),
                                ),
                                _buildPriceWithSymbol(
                                  context,
                                  deliveryFee,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الإجمالي',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'IBMPlex',
                                  ),
                                ),
                                _buildPriceWithSymbol(
                                  context,
                                  total,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    if (status == 'delivered')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            // TODO: إعادة الطلب
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'ميزة إعادة الطلب قريباً',
                                        style: TextStyle(
                                          fontFamily: 'IBMPlex',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.orange,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.all(16),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: [
                              Icon(
                                Icons.replay_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'إعادة هذا الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'IBMPlex',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
