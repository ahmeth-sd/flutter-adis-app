import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SymbolCard extends StatelessWidget {
  final String label;
  final String? imagePath;
  final int? iconCode;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SymbolCard({
    super.key,
    required this.label,
    this.imagePath,
    this.iconCode,
    this.color = Colors.white,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb 
                      ? Image.network(imagePath!, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                      : (File(imagePath!).existsSync() 
                          ? Image.file(File(imagePath!), fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported)),
                  ),
                ),
              )
            else if (iconCode != null)
              Expanded(
                child: Icon(
                  IconData(iconCode!, fontFamily: 'MaterialIcons'),
                  size: 48,
                  color: Colors.black87,
                ),
              )
            else
              const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
