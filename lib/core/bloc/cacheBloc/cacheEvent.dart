import 'package:equatable/equatable.dart';

abstract class CacheEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CacheGetItemsEvent extends CacheEvent {

}

class CacheDeleteItemEvent extends CacheEvent {

}
class CacheAddItemsEvent extends CacheEvent {

}

class ModifyItemEvent extends CacheEvent {

}