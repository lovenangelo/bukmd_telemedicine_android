// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'prescription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Prescription {
  String get appointmentId => throw _privateConstructorUsedError;
  String get medicineDescription => throw _privateConstructorUsedError;
  Event get appointmentInfo => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PrescriptionCopyWith<Prescription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionCopyWith<$Res> {
  factory $PrescriptionCopyWith(
          Prescription value, $Res Function(Prescription) then) =
      _$PrescriptionCopyWithImpl<$Res, Prescription>;
  @useResult
  $Res call(
      {String appointmentId,
      String medicineDescription,
      Event appointmentInfo});
}

/// @nodoc
class _$PrescriptionCopyWithImpl<$Res, $Val extends Prescription>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? medicineDescription = null,
    Object? appointmentInfo = null,
  }) {
    return _then(_value.copyWith(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String,
      medicineDescription: null == medicineDescription
          ? _value.medicineDescription
          : medicineDescription // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentInfo: null == appointmentInfo
          ? _value.appointmentInfo
          : appointmentInfo // ignore: cast_nullable_to_non_nullable
              as Event,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PrescriptionCopyWith<$Res>
    implements $PrescriptionCopyWith<$Res> {
  factory _$$_PrescriptionCopyWith(
          _$_Prescription value, $Res Function(_$_Prescription) then) =
      __$$_PrescriptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String appointmentId,
      String medicineDescription,
      Event appointmentInfo});
}

/// @nodoc
class __$$_PrescriptionCopyWithImpl<$Res>
    extends _$PrescriptionCopyWithImpl<$Res, _$_Prescription>
    implements _$$_PrescriptionCopyWith<$Res> {
  __$$_PrescriptionCopyWithImpl(
      _$_Prescription _value, $Res Function(_$_Prescription) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? medicineDescription = null,
    Object? appointmentInfo = null,
  }) {
    return _then(_$_Prescription(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String,
      medicineDescription: null == medicineDescription
          ? _value.medicineDescription
          : medicineDescription // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentInfo: null == appointmentInfo
          ? _value.appointmentInfo
          : appointmentInfo // ignore: cast_nullable_to_non_nullable
              as Event,
    ));
  }
}

/// @nodoc

class _$_Prescription extends _Prescription {
  const _$_Prescription(
      {required this.appointmentId,
      required this.medicineDescription,
      required this.appointmentInfo})
      : super._();

  @override
  final String appointmentId;
  @override
  final String medicineDescription;
  @override
  final Event appointmentInfo;

  @override
  String toString() {
    return 'Prescription(appointmentId: $appointmentId, medicineDescription: $medicineDescription, appointmentInfo: $appointmentInfo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Prescription &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.medicineDescription, medicineDescription) ||
                other.medicineDescription == medicineDescription) &&
            (identical(other.appointmentInfo, appointmentInfo) ||
                other.appointmentInfo == appointmentInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, appointmentId, medicineDescription, appointmentInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PrescriptionCopyWith<_$_Prescription> get copyWith =>
      __$$_PrescriptionCopyWithImpl<_$_Prescription>(this, _$identity);
}

abstract class _Prescription extends Prescription {
  const factory _Prescription(
      {required final String appointmentId,
      required final String medicineDescription,
      required final Event appointmentInfo}) = _$_Prescription;
  const _Prescription._() : super._();

  @override
  String get appointmentId;
  @override
  String get medicineDescription;
  @override
  Event get appointmentInfo;
  @override
  @JsonKey(ignore: true)
  _$$_PrescriptionCopyWith<_$_Prescription> get copyWith =>
      throw _privateConstructorUsedError;
}
