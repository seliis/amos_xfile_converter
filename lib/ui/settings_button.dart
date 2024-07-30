part of "home.dart";

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: "Settings",
      onPressed: () {
        Navigator.pushNamed(context, ui.Settings.pageName);
      },
    );
  }
}
