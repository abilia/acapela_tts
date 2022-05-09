class AcapelaLicense {
  final int userId, password;
  final String license;
  const AcapelaLicense(this.userId, this.password, this.license);
  static Future<AcapelaLicense> parse(String data) async {
    final datas = data.split('\n');
    final userId = int.parse(datas[0]);
    final password = int.parse(datas[1]);
    final license = datas.skip(2).join('\n');

    return AcapelaLicense(
      userId,
      password,
      license,
    );
  }
}
