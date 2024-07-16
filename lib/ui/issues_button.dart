part of "home.dart";

class _IssuesButton extends StatelessWidget {
  const _IssuesButton({
    required this.worksheet,
  });

  final entity.Worksheet worksheet;

  @override
  Widget build(context) {
    void invokeIssuesView() {
      showDialog<void>(
        context: context,
        builder: (context) {
          final Size size = MediaQuery.of(context).size;

          return AlertDialog(
            title: const Text(
              "Worksheet Issues",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.pink,
              ),
            ),
            content: SizedBox(
              width: size.width * 0.50,
              height: size.height * 0.50,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final entity.Issue issue in worksheet.issues)
                      ListTile(
                        title: Text(
                          "#${worksheet.issues.indexOf(issue) + 1} ${issue.type.display}: ${issue.message.display}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          "Row: ${issue.position.row}, Column: ${issue.position.column}",
                          style: const TextStyle(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return IconButton(
      icon: const Icon(Icons.rule),
      tooltip: "Issues",
      onPressed: worksheet.issues.isNotEmpty ? invokeIssuesView : null,
    );
  }
}
