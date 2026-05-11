import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GradesFilesScreen extends StatelessWidget {
  final String title;
  final List<String> attachments;

  const GradesFilesScreen({
    super.key,
    required this.title,
    required this.attachments,
  });

  bool _isImage(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }

  Future<void> _openFile(BuildContext context, String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open file')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(
                color: Color(0xFF1D2B64), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1D2B64)),
      ),
      body: attachments.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No files attached',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                final url = attachments[index];
                final isImage = _isImage(url);
                final fileName = url.split('/').last.split('-').length > 1
                    ? url.split('/').last.split('-').skip(1).join('-')
                    : url.split('/').last;

                if (isImage) {
                  return _ImageTile(
                    url: url,
                    fileName: fileName,
                    index: index,
                    total: attachments.length,
                    onTap: () => _openFile(context, url),
                  );
                } else {
                  return _PdfTile(
                    fileName: fileName,
                    index: index,
                    total: attachments.length,
                    onTap: () => _openFile(context, url),
                  );
                }
              },
            ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String url;
  final String fileName;
  final int index;
  final int total;
  final VoidCallback onTap;

  const _ImageTile({
    required this.url,
    required this.fileName,
    required this.index,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: GestureDetector(
              onTap: onTap,
              child: Image.network(
                url,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : SizedBox(
                        height: 260,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                            color: const Color(0xFF7A6CF5),
                          ),
                        ),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.grey.shade100,
                  child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 48, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                const Icon(Icons.image_outlined,
                    size: 18, color: Color(0xFF7A6CF5)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${index + 1}/$total',
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(Icons.open_in_new,
                      size: 20, color: Color(0xFF7A6CF5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PdfTile extends StatelessWidget {
  final String fileName;
  final int index;
  final int total;
  final VoidCallback onTap;

  const _PdfTile({
    required this.fileName,
    required this.index,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
        ),
        title: Text(
          fileName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'File ${index + 1} of $total  •  PDF',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.open_in_new, size: 16),
          label: const Text('Open'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7A6CF5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
