import 'package:flutter/material.dart';
import 'package:relief_sphere/app/exceptions/exceptions.dart';

import 'base_state.dart';

abstract class BaseNotifier<T extends BaseState> extends ChangeNotifier {
  late T _state;

  BaseNotifier(T initialState) {
    _state = initialState;
  }

  T get state => _state;

  set state(T value) {
    _state = value;
    notifyListeners();
  }

  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();
      await operation();
      setSuccess();
    }on AppExceptions 
    
    catch (e) {
      setFailure(e.message);
    }
  }

  void loadMore() {}

  void resetState() {
    state = state.copyWith(status: Status.initial, error: '') as T;
  }

  void setFailure(String error) {
    state = state.copyWith(status: Status.failure, error: error) as T;
  }

  void setLoading() {
    state = state.copyWith(status: Status.loading) as T;
  }

  void setSuccess() {
    state = state.copyWith(status: Status.success) as T;
  }
}
