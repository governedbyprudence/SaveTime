import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheEvent.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheState.dart';
import 'package:savetime/core/models/qr.dart';
import 'package:savetime/core/utils/logger.dart';

class CacheBloc extends Bloc<CacheEvent,CacheState>{

  CacheBloc():super(CacheInitialState()){

    on<CacheGetItemsEvent>(_getItems);
    on<CacheDeleteItemEvent>(_deleteAllItems);
  }

  FutureOr<void> _getItems(CacheGetItemsEvent event, Emitter<CacheState> emit)async{
    CustomLogger.debug("Getting Items");
    emit(CacheInitialState());
    CustomLogger.debug(("Initial State Emitted"));
    try{
      List<QRModel>? data= await QRModel.getListFromCache();
      if(data==null){
        emit(CacheItemNotPresentState());
      }
      else{
        emit(CacheItemPresentState(items: data));
      }
    }catch(e){
      emit(CacheErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _deleteAllItems(CacheDeleteItemEvent event, Emitter<CacheState> emit){
    emit(CacheInitialState());
    QRModel.deleteAllItemsFromCache();
    emit(CacheItemNotPresentState());
  }
}