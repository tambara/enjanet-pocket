// Package imports:
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:enjanet_pocket/datas/appdata.dart';
import 'package:enjanet_pocket/datas/searchtable.dart';

part 'search_criteria.g.dart';

enum SearchDbMode { enjaDb, bookmark }

class DbSearchCriteria {
  final String title;
  final String? term;
  List<int> categories;
  SearchDbMode mode;

  final Set<SearchTableNameEnum> tables;

  DbSearchCriteria({
    required this.title,
    required this.term,
    required this.categories,
    required this.tables,
    required this.mode,
  });

  @override
  String toString() {
    return 'EnjanetDbSearchCriteria(term: $term, categories: $categories, mode: $mode, tables: $tables)';
  }
}

/* 事業所情報を検索一覧を保持するプロバイダ */
@Riverpod(keepAlive: true)
class EnjanetDbSearchCriteriaNotifier
    extends _$EnjanetDbSearchCriteriaNotifier {
  // static const Map<int, bool> initCategories = {
  //   1: false, // '地域活動支援センターⅠ型' を bool に変更
  //   2: false, // '地域活動支援センターⅡ型' を bool に変更
  //   3: false, // '地域活動支援センターⅢ型' を bool に変更
  //   4: false, // '就労移行支援' を bool に変更
  //   5: false, // '就労継続支援A型' を bool に変更
  //   6: false, // '就労継続支援B型' を bool に変更
  //   7: false, // '生活介護' を bool に変更
  //   8: false, // '療養介護' を bool に変更
  //   9: false, // '自立訓練' を bool に変更
  //   10: false, // 'ホームヘルプ' を bool に変更
  //   12: false, // '施設入所支援' を bool に変更
  //   13: false, // '短期入所' を bool に変更
  //   14: false, // 'グループホーム' を bool に変更
  //   15: false, // '日中一時支援' を bool に変更
  //   16: false, // '児童発達支援' を bool に変更
  //   17: false, // '計画相談（相談支援事業所）' を bool に変更
  //   18: false, // '放課後等デイサービス' を bool に変更
  //   19: false, // '訪問看護' を bool に変更
  //   20: false, // '病院・クリニック' を bool に変更
  //   21: false, // '就労定着支援' を bool に変更
  //   9000: false, // 'その他' を bool に変更
  // };

  @override
  DbSearchCriteria build() {
    return DbSearchCriteria(
        title: "",
        term: null,
        tables: Set<SearchTableNameEnum>.from(SearchTableNameEnum.all),
        categories: [],
        mode: SearchDbMode.enjaDb);
  }

  void updateTerm(String? newTerm) {
    state = DbSearchCriteria(
      title: state.title,
      term: newTerm,
      categories: state.categories,
      tables: state.tables,
      mode: state.mode,
    );
  }

  void updateCategories(List<int> newFilters) {
    state = DbSearchCriteria(
      title: state.title,
      term: state.term,
      categories: newFilters,
      tables: state.tables,
      mode: state.mode,
    );
  }

  void updateTables(Set<SearchTableNameEnum> newTables) {
    state = DbSearchCriteria(
      title: state.title,
      term: state.term,
      categories: state.categories,
      tables: newTables,
      mode: state.mode,
    );
  }

  void updateCategoriesFrom(ProviderCategory e) {
    updateCategories(getServices(e));
  }

  void updateMode(SearchDbMode e) {
    state = DbSearchCriteria(
      title: state.title,
      term: state.term,
      categories: state.categories,
      tables: state.tables,
      mode: e,
    );
  }

  void updateTitle(String title) {
    state = DbSearchCriteria(
      title: title,
      term: state.term,
      categories: state.categories,
      tables: state.tables,
      mode: state.mode,
    );
  }
  // void toggleCategories(int id) {

  //   state.categories[index] = !state.categories[index]!;
  //   updateCategories(state.categories);
  // }

  // void onCategories(int index) {
  //   if (!state.categories.containsKey(index)) {
  //     throw Exception("知らないindexです");
  //   }

  //   state.categories[index] = true;
  //   updateCategories(state.categories);
  // }

  // void onlyCategories(int index) {
  //   if (!state.categories.containsKey(index)) {
  //     throw Exception("知らないindexです");
  //   }

  //   state.categories.updateAll((key, value) => false);
  //   state.categories[index] = true;
  //   updateCategories(state.categories);
  // }

  // void onlyListCategories(List<int> indices) {
  //   state.categories.updateAll((key, value) => false);
  //   for (int index in indices) {
  //     if (state.categories.containsKey(index)) {
  //       state.categories[index] = true;
  //     }
  //   }
  //   updateCategories(state.categories);
  // }

  // void onlyFromCategories(ProviderCategory cat) {
  //   onlyListCategories(getServices(cat));
  //   updateCategories(state.categories);
  // }
}
