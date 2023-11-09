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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/models.dart';
import '../core/state.dart';
import 'models.dart';

final otpStateProvider = AsyncNotifierProvider.autoDispose
    .family<OtpStateNotifier, OtpState, DevicePath>(
  () => throw UnimplementedError(),
);

abstract class OtpStateNotifier extends ApplicationStateNotifier<OtpState> {
  Future<String> generateStaticPassword(int length, String layout);
  Future<String> modhexEncodeSerial(int serial);
  Future<Map<String, List<String>>> getKeyboardLayouts();
  Future<void> swapSlots();
  Future<void> configureSlot(SlotId slot,
      {required SlotConfiguration configuration});
  Future<void> deleteSlot(SlotId slot);
}
