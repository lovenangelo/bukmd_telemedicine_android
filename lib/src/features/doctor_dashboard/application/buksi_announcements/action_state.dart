import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Action { create, read, update, delete }

final actionProvider =
    StateNotifierProvider.autoDispose<ActionNotifier, Action>((ref) {
  return ActionNotifier();
});

class ActionNotifier extends StateNotifier<Action> {
  ActionNotifier() : super(Action.read);

  get actionRead => Action.read;
  get actionCreate => Action.create;
  get actionUpdate => Action.update;

  setStateCreate() {
    state = Action.create;
  }

  setStateRead() {
    state = Action.read;
  }

  setStateUpdate() {
    state = Action.update;
  }
}
