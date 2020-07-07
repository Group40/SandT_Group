/*import 'package:bloc/bloc.dart';
import 'package:sandtgroup/EventPublishingBooking/EventBooking.dart';
//import 'package:sandtgroup/UserManagementAdmin/Block.dart';
import 'package:sandtgroup/main.dart';

enum NavigationEvent { HomeClick, ProfileClick, PiyumalClick }

abstract class NavigationState {}

class Navigation extends Bloc<NavigationEvent, NavigationState> {
  @override
  // TODO: implement initialState
  NavigationState get initialState => Home();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    // TODO: implement mapEventToState
    switch (event) {
      case NavigationEvent.HomeClick:
        yield Home();
        break;
        case NavigationEvent.PiyumalClick:
        yield EventBooking();
        break;
        case NavigationEvent.ProfileClick:
        yield Home();
        break;
    }
    
  }
}*/
