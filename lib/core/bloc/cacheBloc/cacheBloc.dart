import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheEvent.dart';
import 'package:savetime/core/bloc/cacheBloc/cacheState.dart';
import 'package:savetime/core/models/qr.dart';

class CacheBloc extends Bloc<CacheEvent,CacheState>{

  CacheBloc():super(CacheInitialState()){

    on<CacheGetItemsEvent>(_getItems);
  }

  FutureOr<void> _getItems(CacheGetItemsEvent event, Emitter<CacheState> emit)async{
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
}