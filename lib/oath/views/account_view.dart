import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/circle_timer.dart';
import '../../app/models.dart';
import '../models.dart';
import '../state.dart';

class AccountView extends ConsumerWidget {
  final DeviceNode device;
  final OathCredential credential;
  final OathCode? code;
  const AccountView(this.device, this.credential, this.code, {Key? key})
      : super(key: key);

  bool get _expired =>
      (code?.validTo ?? 0) * 1000 < DateTime.now().millisecondsSinceEpoch;

  String get _avatarLetter {
    var name = credential.issuer ?? credential.name;
    return name.substring(0, 1).toUpperCase();
  }

  String get _label => '${credential.issuer} (${credential.name})';

  String get _code {
    var value = code?.value;
    if (value == null) {
      return '••• •••';
    } else if (value.length < 6) {
      return value;
    } else {
      var i = value.length ~/ 2;
      return value.substring(0, i) + ' ' + value.substring(i);
    }
  }

  Color get _color =>
      Colors.primaries.elementAt(_label.hashCode % Colors.primaries.length);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoriteProvider(credential.id));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: _color,
          child: Text(_avatarLetter, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_code,
                style: _expired
                    ? Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.grey)
                    : Theme.of(context).textTheme.headline6),
            Text(_label, style: Theme.of(context).textTheme.caption),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {
                ref
                    .read(favoriteProvider(credential.id).notifier)
                    .toggleFavorite();
              },
              icon: Icon(favorite ? Icons.star : Icons.star_border),
            ),
            SizedBox.square(
              dimension: 16,
              child: code != null && code!.validTo - code!.validFrom < 600
                  ? CircleTimer(code!.validFrom * 1000, code!.validTo * 1000)
                  : null,
            ),
            if (code == null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref
                      .read(credentialListProvider(device.path).notifier)
                      .calculate(credential);
                },
              )
          ],
        ),
      ]),
    );
  }
}