import 'package:component_library/src/theme/wonder_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _SvgAsset extends StatelessWidget {
  const _SvgAsset(
    this.assetPath, {
    this.width,
    this.height,
    this.color,
    Key? key,
  }) : super(key: key);

  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/$assetPath',
      width: width,
      height: height,
      color: color,
      package: 'component_library',
    );
  }
}

class OpeningQuoteSvgAsset extends StatelessWidget {
  const OpeningQuoteSvgAsset({
    this.width,
    this.height,
    this.color,
    Key? key,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return _SvgAsset(
      'opening-quote.svg',
      width: width,
      height: height,
      color: theme.quoteSvgColor,
    );
  }
}

class ClosingQuoteSvgAsset extends StatelessWidget {
  const ClosingQuoteSvgAsset({
    this.width,
    this.height,
    this.color,
    Key? key,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return _SvgAsset(
      'closing-quote.svg',
      width: width,
      height: height,
      color: theme.quoteSvgColor,
    );
  }
}
