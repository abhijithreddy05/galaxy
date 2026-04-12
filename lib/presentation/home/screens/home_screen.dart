import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/presentation/home/providers/home_provider.dart';
import 'package:pinterest_clone/presentation/home/widgets/pin_grid_item.dart';
import 'package:pinterest_clone/presentation/search/screens/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      ref.read(homePinsProvider.notifier).fetchMorePins();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('All', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 24),
            Text('Today', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
            SizedBox(width: 48), // visually correct centering
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            // Unimplemented search navigation handling would happen here or via GoRouter
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 1) {
      return const SearchScreen();
    } else if (_currentIndex != 0) {
      return const Center(child: Text('Under Construction'));
    }

    final pinsState = ref.watch(homePinsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(homePinsProvider.notifier).refresh(),
      child: pinsState.when(
        data: (pins) {
          return MasonryGridView.count(
            controller: _scrollController,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: pins.length + 1,
            itemBuilder: (context, index) {
              if (index == pins.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final pin = pins[index];
              return PinGridItem(pin: pin);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load pins: \$err')),
      ),
    );
  }
}
