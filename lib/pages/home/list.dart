// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/providers/providers.dart';
import 'package:enjanet_pocket/layout/layout.dart';

// 事業所一覧を表示
class SearchResultsWidget extends ConsumerStatefulWidget {
  const SearchResultsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SearchResultsWidgetState();
  }
}

class _SearchResultsWidgetState extends ConsumerState<SearchResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: buildMain(context),
        ),
        // buildSlideUp(context),
      ],
    );
  }

  Widget buildMain(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    switch (searchResults) {
      case AsyncData(:final value):
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final result = value[index];
            final bookmark = ref.watch(bookmarkProvider(
                (itemId: result.itemId, table: result.tableType)));

            return ListTile(
              // カテゴリ
              // leading: getCycleAvatarFromTableType(result.tableType, 30),
              leading: result.eyecatch != null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // 枠の色
                          width: 2.0, // 枠の太さ
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(result.eyecatch!),
                      ))
                  : getCycleAvatarFromTableType(result.tableType, 30),
              // 事業所名
              title: Text(result.officeName),
              // サービス分類
              subtitle: Text(
                convertServiceCategoryStr(result.serviceCategory),
                overflow: TextOverflow.ellipsis,
              ),
              // お気に入り
              trailing: bookmark != null
                  ? IconButton(
                      iconSize: 24 * 0.9,
                      visualDensity: const VisualDensity(),
                      onPressed: () {
                        final bookmarkNotifier = ref.read(bookmarkProvider((
                          itemId: result.itemId,
                          table: result.tableType
                        )).notifier);
                        bookmarkNotifier.toggleBookmark();
                      },
                      icon: Icon(
                        bookmark != false
                            ? FontAwesomeIcons.solidBookmark
                            : FontAwesomeIcons.bookmark,
                        color: Colors.blue,
                      ))
                  : null,
              // 詳細表示
              onTap: () {
                // panelController.animatePanelToPosition(0.5);
                // setState(() {
                //   drawerData = result.service;
                // });

                context.push(
                    '/home/detail/${result.tableType.value}/${result.itemId}');
              },
            );
          },
        );
      case AsyncLoading():
        return const Center(
          child: SizedBox(
            height: 45.0,
            width: 45.0,
            child: CircularProgressIndicator(),
          ),
        );
      case AsyncError(:final error):
        return Text('Error: $error');
      default:
        return const CircularProgressIndicator(); // すべてのケースに対するデフォルトの戻り値
    }
  }
}

class VerticalFloatingActionButtonMenu extends StatelessWidget {
  final List<FloatingActionButton> buttons;
  final double spaceBetween;

  const VerticalFloatingActionButtonMenu({
    super.key,
    required this.buttons,
    this.spaceBetween = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: buttons.map((button) {
        int index = buttons.indexOf(button);
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : spaceBetween),
          child: button,
        );
      }).toList(),
    );
  }
}
