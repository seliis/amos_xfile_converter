part of "home.dart";

class _InfoButton extends StatelessWidget {
  const _InfoButton();

  @override
  Widget build(context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: "Information",
      onPressed: () async {
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
        if (context.mounted) showDialog<void>(context: context, builder: (_) => _Info(packageInfo: packageInfo));
      },
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.packageInfo,
  });

  final PackageInfo packageInfo;

  @override
  Widget build(context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      title: const Text("Information"),
      content: SizedBox(
        width: size.width * 0.25,
        height: size.height * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${packageInfo.appName.toUpperCase()} v${packageInfo.version}",
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 24,
              ),
            ),
            const Row(
              children: [
                Text(
                  "AMOS",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "XFILE Generator",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Developed by: In Son\n"
              "Powered by Flutter & Dart",
              style: TextStyle(
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Dismiss"),
        ),
      ],
    );
  }
}
