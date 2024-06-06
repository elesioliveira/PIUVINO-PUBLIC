import 'package:flutter/material.dart';

import 'package:piu_vino/src/pages/perfil/componentes/image_perfil.dart';
import 'package:piu_vino/src/pages/perfil/componentes/settings.dart';

class PerfilUser extends StatefulWidget {
  const PerfilUser({super.key});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            UserImage(),
            SettingsUser(),
          ],
        ),
      ),
    );
  }
}
