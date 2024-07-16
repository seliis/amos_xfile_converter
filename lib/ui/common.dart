import "package:flutter/material.dart";

void showingSnackBar(BuildContext context, String message, bool isGood) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // print("Export Failure: ${state.errorMessage}");
    // Prevents Showing SnackBars in Twices (I don't know why showing twice)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isGood ? Colors.teal.shade200 : Colors.pink.shade200,
        duration: const Duration(seconds: 10),
        content: Text(message),
        showCloseIcon: true,
      ),
    );
  });
}