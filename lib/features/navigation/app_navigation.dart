import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/core/service_locator.dart';
import 'package:nomed/features/chat/bloc/chat_rooms_list_bloc.dart';
import 'package:nomed/features/home/bloc/room_cubit.dart';
import 'package:nomed/shared/network/room_network.dart';
import 'package:nomed/features/chat/ui/screens/chat_page.dart';
import 'package:nomed/features/home/ui/screens/home_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RoomsCubit(getIt<RoomNetwork>())),
        BlocProvider(create: (_) => ChatRoomsListBloc(getIt<RoomNetwork>())),
      ],
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [HomePage(), ChatPage()],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,

          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home_filled),
            ),
            BottomNavigationBarItem(label: "Chat", icon: Icon(Icons.chat)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
