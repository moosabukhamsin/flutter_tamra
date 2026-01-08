import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamra/models/cart_item.dart';
import 'package:tamra/presentation/screens/layout_screen.dart';
import 'package:tamra/presentation/widgets/custom_gradient_divider.dart';
import 'package:tamra/constants/app_colors.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String deliveryAddress;
  final String deliveryAddressName;
  final List<CartItem> items;
  final double deliveryFee;
  final double total;

  const OrderSuccessScreen({
    Key? key,
    required this.deliveryAddress,
    required this.deliveryAddressName,
    required this.items,
    required this.deliveryFee,
    required this.total,
  }) : super(key: key);

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
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
            backgroundColor: Colors.transparent,
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
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                children: [
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'تم استلام الطلب بنجاح',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'IBMPlex',
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'سيتم تجهيز وتوصيل طلبك\nفي غضون 4 ساعات',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'IBMPlex',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
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
                            Icons.location_on_rounded,
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
                                'عنوان التوصيل',
                                style: TextStyle(
                                  color: AppColors.textPlaceholder,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlex',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.deliveryAddressName.isNotEmpty
                                    ? widget.deliveryAddressName
                                    : widget.deliveryAddress,
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
                  ...widget.items.map((item) {
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
                                      item.nameAr,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'IBMPlex',
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
                                    'الكمية: ${item.quantity}',
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
                                        item.price,
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
                                        item.totalPrice,
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
                                widget.deliveryFee,
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
                                widget.total,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        // إزالة جميع الصفحات من الستاك والعودة للصفحة الرئيسية
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LayoutScreen(),
                          ),
                          (route) => false,
                        );
                      },
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
                      child: Text(
                        'العودة للصفحة الرئيسية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'IBMPlex',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
