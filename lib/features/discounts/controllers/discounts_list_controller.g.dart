// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discounts_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiscountsListController)
const discountsListControllerProvider = DiscountsListControllerProvider._();

final class DiscountsListControllerProvider
    extends $NotifierProvider<DiscountsListController, List<Discount>> {
  const DiscountsListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discountsListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discountsListControllerHash();

  @$internal
  @override
  DiscountsListController create() => DiscountsListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Discount> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Discount>>(value),
    );
  }
}

String _$discountsListControllerHash() =>
    r'53ccc9b685efa60e77174971da6157318f6041b2';

abstract class _$DiscountsListController extends $Notifier<List<Discount>> {
  List<Discount> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Discount>, List<Discount>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Discount>, List<Discount>>,
              List<Discount>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
