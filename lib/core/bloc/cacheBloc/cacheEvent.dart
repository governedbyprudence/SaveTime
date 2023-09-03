import 'package:equatable/equatable.dart';

abstract class CacheEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CacheGetItemsEvent extends CacheEvent {

}

class CacheDeleteItemEvent extends CacheEvent {

}

class CacheDeleteItemByTagEvent extends CacheEvent{
  final String tag;
  CacheDeleteItemByTagEvent({required this.tag});
}

class CacheAddItemsEvent extends CacheEvent {

}

class ModifyItemEvent extends CacheEvent {

}