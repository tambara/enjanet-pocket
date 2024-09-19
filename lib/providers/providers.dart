// Dart imports:
import 'dart:async';

// Package imports:
import 'package:download_task/download_task.dart';
import 'package:enjanet_pocket/datas/searchtable.dart';
import 'package:enjanet_pocket/db/db.dart';
import 'package:enjanet_pocket/providers/userdb.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:enjanet_pocket/datas/search_criteria.dart';
import 'package:enjanet_pocket/datas/search_result.dart';

/* DBから検索するStreamProviderー */
final searchResultsProvider = StreamProvider<List<SearchResult>>((ref) {
  final searchTerm = ref.watch(enjanetDbSearchCriteriaNotifierProvider);
  final enjanetDb = ref.watch(enjanetDbProvider);
  final userDb = ref.watch(userDbProvider);

  return Stream.value(searchTerm)
      .debounceTime(const Duration(milliseconds: 300))
      .distinct()
      .switchMap((term) async* {
    // お気に入り一覧
    if (term.mode == SearchDbMode.bookmark) {
      // DBBからブックマーク一覧を取得
      final bookmarkList = userDb?.getBookmarkList();
      if (bookmarkList == null) {
        yield [];
        return;
      }

      // ブックマークから詳細情報を取得
      yield enjanetDb?.searchOnBookmarks(bookmarkList, term.term) ?? [];
      return;
    } else {
      if (term.term == null && term.categories.isEmpty) {
        yield [];
        return;
      }

      // 検索
      yield enjanetDb?.search(term) ?? [];
      return;
    }
  });
});

final enjanetDbProvider =
    StateNotifierProvider<EnjanetDbNotifier, EnjanetDatabase?>((ref) {
  return EnjanetDbNotifier();
});

// ブックマークのプロバイダー
class Bookmark extends StateNotifier<bool?> {
  final UserDatabase? db;
  final int itemId;
  final SearchTableNameEnum table;

  Bookmark(this.db, this.itemId, this.table)
      : super(db?.getBookmark(itemId, table) != null);

  void toggleBookmark() {
    if (state == null) {
      // throw Exception("bookmark state is null");
      return;
    }

    final newState = !state!;

    if (newState) {
      db?.addBookmark(
        itemId,
        table,
      );
    } else {
      db?.removeBookmark(
        itemId,
        table,
      );
    }

    state = newState;
  }
}

final bookmarkProvider = StateNotifierProvider.family<Bookmark, bool?,
    ({int itemId, SearchTableNameEnum table})>((ref, params) {
  final db = ref.watch(userDbProvider);
  return Bookmark(db, params.itemId, params.table);
});

class DownloadProgress {
  final bool start;
  final TaskEvent? event;
  final DownloadTask? task;

  DownloadProgress(
      {required this.start, required this.event, required this.task});
}
