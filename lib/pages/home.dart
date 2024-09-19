// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:enjanet_pocket/datas/search_criteria.dart';
import 'package:enjanet_pocket/pages/home/bottomSheetNav.dart';
import 'package:enjanet_pocket/pages/home/list.dart';
import 'package:enjanet_pocket/pages/home/map.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchOptions = [
    '事業所名', /*'Full Text', 'Tag', 'Author'*/
  ];
  String _selectedOption = '事業所名';
  String _viewMode = "LIST";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showHomeBottomSheetWidget(context, false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final title =
                ref.watch(enjanetDbSearchCriteriaNotifierProvider).title;

            return Text(title);
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bars),
            onPressed: () {
              showHomeBottomSheetWidget(context, true);
            },
          ),
        ],
      ),
      body: Container(
        // color: Colors.grey[200],
        child: buildMainWidget(),
      ),
      floatingActionButton: VerticalFloatingActionButtonMenu(buttons: [
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _viewMode = _viewMode == "MAP" ? "LIST" : "MAP";
            });
          },
          child: FaIcon(_viewMode == "MAP"
              ? FontAwesomeIcons.list
              : FontAwesomeIcons.mapLocationDot),
        ),
      ]),
    );
  }

  void _performSearch(String query) {
    final state = ref.read(enjanetDbSearchCriteriaNotifierProvider.notifier);
    state.updateTerm(query);
  }

  Widget buildMainWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              //   Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       TextButton(
              //         onPressed: () {},
              //         child: const Text(
              //           'フィルター',
              //           style: TextStyle(
              //             fontSize: 12,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _performSearch,
                        decoration: const InputDecoration(
                          hintText: '検索...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: PopupMenuButton<String>(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedOption,
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down,
                                  color: Colors.grey[600]),
                            ],
                          ),
                        ),
                        onSelected: (String value) {
                          setState(() {
                            _selectedOption = value;
                            _performSearch(_searchController.text);
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return _searchOptions.map((String option) {
                            return PopupMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            // decoration: const BoxDecoration(color: Colors.white), // 追加
            child: (_viewMode == "LIST")
                ? const SearchResultsWidget()
                : const MapScreen(),
          ),
        ),
      ],
    );
  }
}
