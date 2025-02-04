import 'package:relief_sphere/core/model/user_model.dart';

import '../base_state.dart';

class ProfileState extends BaseState{

  final UserModel? userModel;

  const ProfileState({
    super.status = Status.initial,
    super.error = '',
    this.userModel,

  } );

  @override
  List<Object?> get props => [ ...super.props,userModel];

  @override
  BaseState copyWith({Status? status, String? error, UserModel? userModel}) {
    return ProfileState(
      status: status ?? this.status,
      error: error ?? this.error,
      userModel: userModel ?? this.userModel,
    );
  }
    
}