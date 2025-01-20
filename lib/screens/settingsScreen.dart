import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.blue,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
