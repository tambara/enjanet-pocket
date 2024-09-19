class MetadataJson {
  final String fileName;
  final int size;
  final int mtime;
  final String md5;
  final String sha256;

  const MetadataJson({
    required this.fileName,
    required this.size,
    required this.mtime,
    required this.md5,
    required this.sha256,
  });

  factory MetadataJson.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'filename': String fileName,
        'size': int size,
        'mtime': int mtime,
        'md5': String md5,
        'sha256': String sha256,
      } =>
        MetadataJson(
          fileName: fileName,
          size: size,
          mtime: mtime,
          md5: md5,
          sha256: sha256,
        ),
      _ => throw const FormatException('Failed to load Metadata.'),
    };
  }

  Map<String, dynamic> toJson() => {
        'filename': fileName,
        'size': size,
        'mtime': mtime,
        'md5': md5,
        'sha256': sha256,
      };
}
