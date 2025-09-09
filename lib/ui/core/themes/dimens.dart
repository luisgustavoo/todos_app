import 'package:flutter/material.dart';

extension DimensExtension on BuildContext {
  Dimens get dimens {
    return Dimens.of(this);
  }
}

abstract final class Dimens {
  const Dimens();

  factory Dimens.of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return switch (width) {
      > 600 && < 840 => desktop,
      _ => mobile,
    };
  }

  static const paddingHorizontal = 20.0;
  static const paddingVertical = 24.0;

  double get paddingScreenHorizontal;
  double get paddingScreenVertical;
  double get profilePictureSize;

  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const Dimens desktop = _DimensDesktop();
  static const Dimens mobile = _DimensMobile();
}

final class _DimensMobile extends Dimens {
  const _DimensMobile();

  @override
  double get paddingScreenHorizontal => Dimens.paddingHorizontal;

  @override
  double get paddingScreenVertical => Dimens.paddingVertical;

  @override
  double get profilePictureSize => 64;
}

final class _DimensDesktop extends Dimens {
  const _DimensDesktop();
  @override
  double get paddingScreenHorizontal => 100;

  @override
  double get paddingScreenVertical => 64;

  @override
  double get profilePictureSize => 128;
}
