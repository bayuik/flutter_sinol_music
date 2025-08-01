import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:masterstudy_app/data/repository/purchase_repository.dart';

import './bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final PurchaseRepository _repository;

  OrdersBloc(this._repository) : super(InitialOrdersState()) {
    on<FetchEvent>(
      (event, emit) async {
        try {
          var orders = await _repository.getOrders();
          if (orders.isNotEmpty) {
            emit(LoadedOrdersState(orders));
          } else
            emit(EmptyOrdersState());
        } catch (e, s) {
          print(e);
          print(s);
        }
      },
    );
  }

  @override
  OrdersState get initialState => InitialOrdersState();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is FetchEvent) {
      // try {
      //   var orders = await _repository.getOrders();
      //   if (orders != null && orders.isNotEmpty) {
      //     yield LoadedOrdersState(orders);
      //   } else
      //     yield EmptyOrdersState();
      // } catch (e, s) {
      //   print(e);
      //   print(s);
      // }
    }
  }
}
