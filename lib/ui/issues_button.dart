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
              "** Worksheet Issues **",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: SizedBox(
              width: size.width * 0.50,
              height: size.height * 0.50,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final entity.Issue issue in worksheet.issues) _Issue(issue: issue),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Badge(
      isLabelVisible: worksheet.issues.isNotEmpty,
      label: Text("${worksheet.issues.length}"),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      child: SizedBox(
        width: 48,
        child: IconButton(
          icon: const Icon(Icons.rule),
          tooltip: "${worksheet.issues.length} Issues",
          onPressed: worksheet.issues.isNotEmpty ? invokeIssuesView : null,
        ),
      ),
    );
  }
}

class _Issue extends StatelessWidget {
  const _Issue({
    required this.issue,
  });

  final entity.Issue issue;

  @override
  Widget build(context) {
    return ListTile(
      leading: issue.type.icon,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            issue.type.display,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "R${issue.position.row}:C${issue.position.column}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            issue.message.display,
            style: const TextStyle(
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              "data: ${issue.data}",
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          if (issue.additionalInfo != null)
            Text(
              issue.additionalInfo!,
              style: const TextStyle(
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
