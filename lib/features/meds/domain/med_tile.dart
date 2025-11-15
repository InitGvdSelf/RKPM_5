import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MedTile extends StatelessWidget {
  final Medicine med;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MedTile({
    super.key,
    required this.med,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = (med.imageUrl ?? '').trim().isNotEmpty;

    Widget leading;
    if (hasUrl) {
      leading = CircleAvatar(
        radius: 22,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: med.imageUrl!.trim(),
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
      );
    } else {
      leading = const CircleAvatar(
        radius: 22,
        child: Icon(Icons.medication),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: leading,
        title: Text(
          med.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${med.dose} • ${med.form}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}