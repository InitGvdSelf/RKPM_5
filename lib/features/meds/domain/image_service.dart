import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageService {
  ImageService._();
  static final ImageService instance = ImageService._();

  static const _spMedPoolKey = 'med_image_pool_v1';
  static const _spAvatarPoolKey = 'avatar_image_pool_v1';
  static const _spMedCursorKey = 'med_cursor_v1';
  static const _spAvatarCursorKey = 'avatar_cursor_v1';

  final BaseCacheManager _cache = DefaultCacheManager();

  List<String> _med = [];
  List<String> _avatars = [];
  int _medCur = 0;
  int _avaCur = 0;
  bool _inited = false;

  Future<void> initialize() async {
    if (_inited) return;
    final sp = await SharedPreferences.getInstance();

    _medCur = sp.getInt(_spMedCursorKey) ?? 0;
    _avaCur = sp.getInt(_spAvatarCursorKey) ?? 0;

    _med = sp.getStringList(_spMedPoolKey) ?? [];
    _avatars = sp.getStringList(_spAvatarPoolKey) ?? [];

    if (_med.isEmpty || _avatars.isEmpty) {
      await _generatePools();
      await _savePools();
    }

    await preloadImagePools();

    _inited = true;
  }
  Future<void> _generatePools() async {
    const int medCount = 50;
    const int avatarCount = 50;

    _med = List.generate(
      medCount,
          (i) => 'https://picsum.photos/seed/med_${DateTime.now().millisecondsSinceEpoch + i}/600/400',
    );

    _avatars = List.generate(
      avatarCount,
          (i) => 'https://picsum.photos/seed/avatar_${DateTime.now().millisecondsSinceEpoch + i}/400/400',
    );
  }

  Future<void> _savePools() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_spMedPoolKey, _med);
    await sp.setStringList(_spAvatarPoolKey, _avatars);
  }

  Future<void> preloadImagePools() async {
    final urls = [..._med, ..._avatars];
    for (final u in urls) {
      try {
        await _cache.getSingleFile(u);
      } catch (_) {}
    }
  }

  Future<String> nextMedImage() async {
    await initialize();
    final url = _med[_medCur % _med.length];
    _medCur = (_medCur + 1) % _med.length;
    final sp = await SharedPreferences.getInstance();
    unawaited(sp.setInt(_spMedCursorKey, _medCur));
    return url;
  }

  Future<String> nextAvatarImage() async {
    await initialize();
    final url = _avatars[_avaCur % _avatars.length];
    _avaCur = (_avaCur + 1) % _avatars.length;
    final sp = await SharedPreferences.getInstance();
    unawaited(sp.setInt(_spAvatarCursorKey, _avaCur));
    return url;
  }

  Future<void> prefetchAll() async {
    await initialize();
  }

  Future<String> nextImageUrl() async {
    return nextMedImage();
  }
}