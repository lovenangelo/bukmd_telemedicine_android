import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/strings.dart';

import '../features/authentication/service/firebase_auth_service.dart';

import '../theme/theme.dart';

class UserProfileImage extends ConsumerStatefulWidget {
  const UserProfileImage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileImageState();
}

class _UserProfileImageState extends ConsumerState<UserProfileImage> {
  final _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    log(_auth.photoUrl!);
    return Material(
      elevation: 4,
      shape:
          const CircleBorder(side: BorderSide(color: primaryColor, width: 4)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
          borderRadius: BorderRadius.circular(50),
          splashColor: Colors.black26,
          child: displayPictureContainer()),
    );
  }

  Widget displayPictureContainer() => _auth.photoUrl == null
      ? Ink.image(
          image: const AssetImage(Strings.profileUserIcon),
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        )
      : CachedNetworkImage(
          key: UniqueKey(),
          imageUrl: _auth.photoUrl!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          },
          errorWidget: (context, url, error) {
            return const Icon(Icons.error);
          },
        );
}
