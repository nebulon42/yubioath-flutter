import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/models.dart';
import '../../app/views/app_failure_screen.dart';
import '../models.dart';
import '../state.dart';
import 'delete_credential_dialog.dart';

class CredentialPage extends ConsumerWidget {
  final DeviceNode node;
  final FidoState state;

  const CredentialPage(this.node, this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(credentialProvider(node.path)).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppFailureScreen('$error'),
          data: (credentials) => ListView(
            children: [
              ListTile(
                title: Text(
                  'CREDENTIALS',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              ...credentials.map((cred) => ListTile(
                    title: Text(cred.userName),
                    subtitle: Text(cred.rpId),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    DeleteCredentialDialog(node, cred),
                              );
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  )),
            ],
          ),
        );
  }
}