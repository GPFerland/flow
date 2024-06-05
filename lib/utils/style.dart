import 'package:flutter/material.dart';

const double drawerTileHeight = 60;
const double listTileHeight = 80;

TextStyle getTitleLargeOnPrimary(BuildContext context, {double? fontSize}) {
  return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: fontSize,
      );
}

TextStyle getTitleMediumOnPrimary(BuildContext context, {double? fontSize}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: fontSize,
      );
}

TextStyle getBodyMediumOnPrimary(BuildContext context, {double? fontSize}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: fontSize,
      );
}

TextStyle getTitleLargeOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getTitleMediumOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getTitleSmallOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getBodyLargeOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getBodyMediumOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getBodySmallOnPrimaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getTitleLargeOnSecondaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getTitleMediumOnSecondaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getTitleSmallOnSecondaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.titleSmall!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getBodyLargeOnSecondaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: fontSize,
      );
}

TextStyle getBodyMediumOnSecondaryContainer(BuildContext context,
    {double? fontSize}) {
  return Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: fontSize,
      );
}
