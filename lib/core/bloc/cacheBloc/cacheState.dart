
import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../models/qr.dart';

abstract class CacheState extends Equatable{

@override
  List<Object> get props => [];
}

class CacheInitialState extends CacheState{

}

class CacheItemPresentState extends CacheState{
  List<QRModel> items;

  CacheItemPresentState({required this.items});
}

class CacheItemNotPresentState extends CacheState {

}

class CacheErrorState extends CacheState {
  String errorMessage;
  CacheErrorState({required this.errorMessage});
}