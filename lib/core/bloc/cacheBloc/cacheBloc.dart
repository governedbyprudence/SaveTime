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
    on<CacheDeleteItemByTagEvent>(_deleteItemByTag);
  }

  FutureOr<void> _getItems(CacheGetItemsEvent event, Emitter<CacheState> emit)async{
    emit(CacheInitialState());
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

  FutureOr<void> _deleteItemByTag(CacheDeleteItemByTagEvent event,Emitter<CacheState> emit)async{
    emit(CacheInitialState());
    try{
      await QRModel.deleteItemByTag(event.tag);
      add(CacheGetItemsEvent());
    }catch(e){
      emit(CacheItemNotPresentState());
    }

  }
}