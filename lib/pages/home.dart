// Flutter imports:
import 'dart:ui';

import 'package:enjanet_pocket/db/db.dart';
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:enjanet_pocket/datas/search_criteria.dart';
import 'package:enjanet_pocket/pages/home/bottomSheetNav.dart';
import 'package:enjanet_pocket/pages/home/list.dart';
import 'package:enjanet_pocket/pages/home/map.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> with HomeTutorial {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchOptions = [
    '事業所名', /*'Full Text', 'Tag', 'Author'*/
  ];
  String _selectedOption = '事業所名';
  String _viewMode = "LIST";

  @override
  void initState() {
    super.initState();

    final userDb = ref.read(userDbProvider);
    if (userDb == null) {
      throw Exception("UserDb is null");
    }

    createTutorial(userDb);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showHomeBottomSheetWidget(context, false);
    });
  }

  void showHomeBottomSheetWidget(
      BuildContext context, bool isDismissibleAndEnableDrag) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: isDismissibleAndEnableDrag, // 画面外タップでの閉じを無効化
      enableDrag: isDismissibleAndEnableDrag, // ドラッグでの閉じを無効化
      constraints: const BoxConstraints.expand(),
      builder: (BuildContext context) {
        return BottomSheetNav(enableClose: isDismissibleAndEnableDrag);
      },
    );

    if (isDismissibleAndEnableDrag == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTutorial(context);
      });
    }
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
            key: _navButtonKey,
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

mixin HomeTutorial {
  late TutorialCoachMark tutorialCoachMark;

  String? homeTutorial;
  final GlobalKey _navButtonKey = GlobalKey();

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "_navButtonKey",
        keyTarget: _navButtonKey,
        contents: [
          TargetContent(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ヒント",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text("ここから再度、ナビゲーションを表示できます",
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    return targets;
  }

  void createTutorial(UserDatabase userDb) {
    homeTutorial = userDb.getSetting("home_tutorial");

    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "スキップ",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        userDb.upsertSetting("home_tutorial", "1");
        homeTutorial = "1";
      },
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {
        return false;
      },
    );
  }

  void showTutorial(BuildContext context) {
    if (homeTutorial != "1") {
      tutorialCoachMark.show(context: context);
    }
  }
}
