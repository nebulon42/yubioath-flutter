/*
 * Copyright (C) 2023 Yubico.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';

import '../../widgets/list_title.dart';

enum ActionStyle { normal, primary, error }

class ActionListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget icon;
  final Widget? trailing;
  final ActionStyle actionStyle;
  final void Function()? onTap;

  const ActionListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.actionStyle = ActionStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        ButtonTheme.of(context).colorScheme ?? Theme.of(context).colorScheme;

    final (foreground, background) = switch (actionStyle) {
      ActionStyle.normal => (theme.onSecondary, theme.secondary),
      ActionStyle.primary => (theme.onPrimary, theme.primary),
      ActionStyle.error => (theme.onError, theme.error),
    };

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: Opacity(
        opacity: onTap != null ? 1.0 : 0.4,
        child: CircleAvatar(
          foregroundColor: foreground,
          backgroundColor: background,
          child: icon,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}

class ActionListSection extends StatelessWidget {
  final String title;
  final List<ActionListItem> children;

  const ActionListSection(this.title, {super.key, required this.children});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 360,
        child: Column(children: [
          ListTitle(
            title,
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          ...children,
        ]),
      );
}
