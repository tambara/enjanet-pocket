// Flutter imports:
import 'package:enjanet_pocket/thema/color.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:enjanet_pocket/datas/env.dart';
import 'package:enjanet_pocket/datas/search_criteria.dart';
import '../../datas/appdata.dart';

class BottomSheetNavLayoutData {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double verticalPadding;
  final double horizontalPadding;
  final double fontSize;
  final double iconSize;

  BottomSheetNavLayoutData({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.verticalPadding,
    required this.horizontalPadding,
    required this.fontSize,
    required this.iconSize,
  });

  factory BottomSheetNavLayoutData.fromContext(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      return BottomSheetNavLayoutData(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        verticalPadding: 32,
        horizontalPadding: 32,
        fontSize: 16,
        iconSize: 48,
      );
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return BottomSheetNavLayoutData(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        verticalPadding: 6,
        horizontalPadding: 6,
        fontSize: 13,
        iconSize: 42,
      );
    } else {
      return BottomSheetNavLayoutData(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        verticalPadding: 3,
        horizontalPadding: 3,
        fontSize: 13,
        iconSize: 42,
      );
    }
  }
}

class BottomSheetNav extends ConsumerWidget {
  final bool enableClose;

  const BottomSheetNav({super.key, required this.enableClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
        canPop: enableClose,
        child: DefaultTabController(
          length: 3, // タブの数
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "ナビゲーション",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "目的"),
                  Tab(text: "種別"),
                  Tab(text: "その他"),
                ],
              ),
              actions: [
                if (enableClose)
                  IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.xmark,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
              ],
            ),
            body: Container(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                child: TabBarView(
                  children: [
                    _buildPurposeTab(context, ref),
                    _buildCategoryTab(context, ref),
                    _buildSearchTab(context, ref),
                  ],
                )),
          ),
        ));
  }

  Color getColor(BottomSheetNavColors thema, ProviderCategory p) {
    switch (p) {
      case ProviderCategory.work:
        return thema.workButtonColor;
      case ProviderCategory.medical:
        return thema.medicalButtonColor;
      case ProviderCategory.rest:
        return thema.restButtonColor;
      case ProviderCategory.child:
        return thema.childButtonColor;
      case ProviderCategory.activity:
        return thema.activityButtonColor;
      case ProviderCategory.plan:
        return thema.planButtonColor;
      case ProviderCategory.helper:
        return thema.helperButtonColor;
    }
  }

  Widget _buildPurposeTab(BuildContext context, WidgetRef ref) {
    final thema = Theme.of(context).extension<BottomSheetNavColors>();
    if (thema == null) {
      throw Exception("BottomSheetNavColors is null");
    }

// providerServiceInfoMap の定義
    Map<ProviderCategory, ServiceInfo> providerServiceInfoMap = {
      ProviderCategory.plan: ServiceInfo(FontAwesomeIcons.clipboardList,
          thema.planButtonColor, "福祉サービス利用に関する相談（計画相談支援・障害児相談支援）"),
      ProviderCategory.work: ServiceInfo(
          FontAwesomeIcons.briefcase, thema.workButtonColor, "働きたい"),
      ProviderCategory.medical: ServiceInfo(FontAwesomeIcons.stethoscope,
          thema.medicalButtonColor, "（精神科）医療を受けたい"),
      ProviderCategory.rest: ServiceInfo(
          FontAwesomeIcons.bed, thema.restButtonColor, "短期入所・施設入所を探したい"),
      ProviderCategory.child: ServiceInfo(
          FontAwesomeIcons.child, thema.childButtonColor, "子ども・子育て・日中一時支援"),
      ProviderCategory.activity: ServiceInfo(
          FontAwesomeIcons.peopleGroup, thema.activityButtonColor, "日中活動をしたい"),
      ProviderCategory.helper: ServiceInfo(FontAwesomeIcons.handHoldingHeart,
          thema.helperButtonColor, "居宅介護（ホームヘルプ）等を探したい"),
    };

    for (var v in ProviderCategory.values) {
      final color = getColor(thema, v);
      providerServiceInfoMap[v]?.color = color;
    }

    final searchCriteria =
        ref.watch(enjanetDbSearchCriteriaNotifierProvider.notifier);
    return SingleChildScrollView(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final layoutData = BottomSheetNavLayoutData.fromContext(context);
        return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: layoutData.crossAxisSpacing),
            child: Column(children: [
              SizedBox(
                height: layoutData.mainAxisSpacing,
              ),
              _buildGridSection(
                context,
                "目的から探す",
                [
                  for (var e in providerServiceInfoMap.entries)
                    _buildCategoryButton2(
                        e.value.icon,
                        e.value.name,
                        e.value.color,
                        Colors.transparent,
                        layoutData.fontSize, () {
                      searchCriteria.updateMode(SearchDbMode.enjaDb);
                      searchCriteria.updateCategoriesFrom(e.key);
                      searchCriteria.updateTitle(e.value.name);

                      Navigator.pop(context);
                    }, layoutData.mainAxisSpacing, layoutData.crossAxisSpacing,
                        layoutData.iconSize),
                ],
                layoutData.crossAxisCount,
                layoutData.mainAxisSpacing,
                layoutData.crossAxisSpacing,
              ),
            ]));
      }),
    );
  }

  Widget _buildCategoryButton2(
    IconData icon,
    String label,
    Color color,
    Color borderColor,
    double fontSize,
    void Function()? onTap,
    double px,
    double py,
    double iconSize,
  ) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'あ\nあ', // 2行分のテキストを想定（上下の文字を含む）
        style: TextStyle(fontSize: fontSize),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);

    double textHeight = textPainter.height;

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: py, horizontal: px),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: borderColor, // ボーダーの色
            width: 2, // ボーダーの幅
          ),
          borderRadius: BorderRadius.circular(0), // 角の丸み（オプション）
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: FaIcon(icon),
                  )),
            ),
            SizedBox(height: py),
            SizedBox(
              height: textHeight,
              child: Center(
                  child: Text(
                label,
                style: TextStyle(fontSize: fontSize),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, WidgetRef ref) {
    final thema = Theme.of(context).extension<BottomSheetNavColors>();
    if (thema == null) {
      throw Exception("BottomSheetNavColors is null");
    }

    Map<int, ServiceInfo> serviceInfoMap = {
      1: ServiceInfo(FontAwesomeIcons.users, Colors.blue[50]!, '地域活動支援センターⅠ型'),
      2: ServiceInfo(
          FontAwesomeIcons.userGroup, Colors.blue[50]!, '地域活動支援センターⅡ型'),
      3: ServiceInfo(FontAwesomeIcons.user, Colors.blue[50]!, '地域活動支援センターⅢ型'),
      4: ServiceInfo(FontAwesomeIcons.briefcase, Colors.orange[50]!, '就労移行支援'),
      5: ServiceInfo(FontAwesomeIcons.userTie, Colors.orange[50]!, '就労継続支援A型'),
      6: ServiceInfo(
          FontAwesomeIcons.handHoldingHeart, Colors.orange[50]!, '就労継続支援B型'),
      7: ServiceInfo(
          FontAwesomeIcons.handHoldingMedical, Colors.green[50]!, '生活介護'),
      8: ServiceInfo(FontAwesomeIcons.bedPulse, Colors.red[50]!, '療養介護'),
      9: ServiceInfo(FontAwesomeIcons.personWalking, Colors.teal[50]!, '自立訓練'),
      10: ServiceInfo(FontAwesomeIcons.house, Colors.purple[50]!, 'ホームヘルプ'),
      12: ServiceInfo(FontAwesomeIcons.building, Colors.indigo[50]!, '施設入所支援'),
      13: ServiceInfo(FontAwesomeIcons.bed, Colors.cyan[50]!, '短期入所'),
      14: ServiceInfo(
          FontAwesomeIcons.houseUser, Colors.deepPurple[50]!, 'グループホーム'),
      15: ServiceInfo(FontAwesomeIcons.clock, Colors.amber[50]!, '日中一時支援'),
      16: ServiceInfo(FontAwesomeIcons.child, Colors.lightGreen[50]!, '児童発達支援'),
      17: ServiceInfo(
          FontAwesomeIcons.clipboardList, Colors.brown[50]!, '計画相談（相談支援事業所）'),
      18: ServiceInfo(FontAwesomeIcons.school, Colors.lime[50]!, '放課後等デイサービス'),
      19: ServiceInfo(FontAwesomeIcons.userNurse, Colors.pink[50]!, '訪問看護'),
      20: ServiceInfo(FontAwesomeIcons.hospital, Colors.red[50]!, '病院・クリニック'),
      21: ServiceInfo(FontAwesomeIcons.thumbsUp, Colors.grey[500]!, '就労定着支援'),
      9000: ServiceInfo(FontAwesomeIcons.ellipsis, Colors.grey[500]!, 'その他'),
    };

    for (var v in ProviderCategory.values) {
      final list = getServices(v);
      for (var num in list) {
        serviceInfoMap[num]?.color = getColor(thema, v);
      }
    }

    final searchCriteria =
        ref.watch(enjanetDbSearchCriteriaNotifierProvider.notifier);
    return SingleChildScrollView(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final layoutData = BottomSheetNavLayoutData.fromContext(context);

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: layoutData.crossAxisSpacing),
          child: Column(
            children: [
              SizedBox(
                height: layoutData.mainAxisSpacing,
              ),
              _buildGridSection(
                context,
                "種別から探す",
                serviceInfoMap.entries.map((e) {
                  return _buildCategoryButton2(
                      e.value.icon,
                      e.value.name,
                      e.value.color,
                      Colors.transparent,
                      layoutData.fontSize, () {
                    searchCriteria.updateMode(SearchDbMode.enjaDb);
                    searchCriteria.updateCategories([e.key]);
                    searchCriteria.updateTitle(e.value.name);
                    Navigator.pop(context);
                  }, layoutData.mainAxisSpacing, layoutData.crossAxisSpacing,
                      layoutData.iconSize);
                }).toList(),
                layoutData.crossAxisCount,
                layoutData.mainAxisSpacing,
                layoutData.crossAxisSpacing,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchTab(BuildContext context, WidgetRef ref) {
    final thema = Theme.of(context).extension<BottomSheetNavColors>();
    if (thema == null) {
      throw Exception("BottomSheetNavColors is null");
    }

    final searchCriteria =
        ref.watch(enjanetDbSearchCriteriaNotifierProvider.notifier);
    return SingleChildScrollView(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final layoutData = BottomSheetNavLayoutData.fromContext(context);
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: layoutData.crossAxisSpacing),
          child: Column(
            children: [
              SizedBox(
                height: layoutData.mainAxisSpacing,
              ),
              _buildGridSection(
                context,
                "機能",
                [
                  _buildCategoryButton2(
                      FontAwesomeIcons.bookBookmark,
                      '保存したお気に入り',
                      thema.bookmarksButtonColor,
                      Colors.transparent,
                      layoutData.fontSize, () {
                    searchCriteria.updateMode(SearchDbMode.bookmark);
                    searchCriteria.updateTitle("保存したお気に入り");
                    Navigator.pop(context);
                  }, layoutData.mainAxisSpacing, layoutData.crossAxisSpacing,
                      layoutData.iconSize),
                  _buildCategoryButton2(
                      FontAwesomeIcons.gear,
                      '設定',
                      thema.settingsButtonColor,
                      Colors.transparent,
                      layoutData.fontSize, () {
                    context.go('/home/settings/');
                  }, layoutData.mainAxisSpacing, layoutData.crossAxisSpacing,
                      layoutData.iconSize),
                ],
                layoutData.crossAxisCount,
                layoutData.mainAxisSpacing,
                layoutData.crossAxisSpacing,
              ),
              SizedBox(
                height: layoutData.mainAxisSpacing,
              ),
              _buildGridSection(
                context,
                "情報",
                [
                  _buildCategoryButton2(
                      FontAwesomeIcons.globe,
                      'え〜んじゃネット（Webサイト）にアクセスする',
                      thema.websiteButtonColor,
                      Colors.transparent,
                      layoutData.fontSize, () async {
                    await launchUrl(Uri.parse(Env.enjanetUrl));
                  }, layoutData.mainAxisSpacing, layoutData.crossAxisSpacing,
                      layoutData.iconSize),
                ],
                layoutData.crossAxisCount,
                layoutData.mainAxisSpacing,
                layoutData.crossAxisSpacing,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildGridSection(
    BuildContext context,
    String title,
    List<Widget> buttons,
    int crossAxisCount,
    double mainAxisSpacing,
    double crossAxisSpacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: mainAxisSpacing,
        ),
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.414,
            // childAspectRatio: 1 / 1.414,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: buttons,
        ),
      ],
    );
  }
}
