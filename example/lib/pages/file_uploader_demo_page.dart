import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonFileUploader component.
class FileUploaderDemoPage extends StatefulWidget {
  const FileUploaderDemoPage({super.key});

  @override
  State<FileUploaderDemoPage> createState() => _FileUploaderDemoPageState();
}

class _FileUploaderDemoPageState extends State<FileUploaderDemoPage> {
  final List<_FileItem> _files1 = [];
  final List<_FileItem> _files2 = [];
  final List<_FileItem> _files3 = [];
  bool _isDragging = false;

  void _simulateFileUpload(List<_FileItem> fileList) {
    // Simulate adding a file
    setState(() {
      fileList.add(
        _FileItem(
          name: 'document-${fileList.length + 1}.pdf',
          state: CarbonFileUploaderItemState.uploading,
        ),
      );
    });

    // Simulate upload completion after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (fileList.isNotEmpty) {
            fileList.last.state = CarbonFileUploaderItemState.complete;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'File Uploader',
      description:
          'File upload component with button and drop zone variants. Drop zone uses the super_drag_and_drop package for native drag-and-drop support.',
      sections: [
        DemoSection(
          title: 'Package Integration',
          description: 'This demo uses the super_drag_and_drop package',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.carbon.layer.layer02,
              border: Border.all(color: context.carbon.layer.borderSubtle01),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.integration_instructions,
                  size: 24,
                  color: context.carbon.text.textPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Using super_drag_and_drop package',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.carbon.text.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'The Drop Zone Uploader section demonstrates real native drag-and-drop functionality using the super_drag_and_drop package (v0.9.1). Try dragging files from your desktop!',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.carbon.text.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Button Uploader',
          description: 'Simple button that opens file picker',
          builder: (context) => CarbonFileUploader(
            labelTitle: 'Upload files',
            labelDescription:
                'Max file size is 500mb. Supported formats: PDF, DOC, DOCX',
            items: _files1
                .map(
                  (file) => CarbonFileUploaderItem(
                    filename: file.name,
                    state: file.state,
                    onDelete: () {
                      setState(() => _files1.remove(file));
                    },
                  ),
                )
                .toList(),
            child: CarbonFileUploaderButton(
              onPressed: () => _simulateFileUpload(_files1),
              child: const Text('Add files'),
            ),
          ),
        ),
        DemoSection(
          title: 'Drop Zone Uploader (Real Drag & Drop)',
          description:
              'Native drag and drop area powered by super_drag_and_drop - try dragging files from your desktop!',
          builder: (context) => CarbonFileUploader(
            labelTitle: 'Upload documents',
            labelDescription:
                'Drag and drop files from your desktop or click to browse',
            items: _files2
                .map(
                  (file) => CarbonFileUploaderItem(
                    filename: file.name,
                    state: file.state,
                    onDelete: () {
                      setState(() => _files2.remove(file));
                    },
                  ),
                )
                .toList(),
            child: DropRegion(
              formats: Formats.standardFormats,
              hitTestBehavior: HitTestBehavior.opaque,
              onDropOver: (event) {
                // Accept copy operations
                if (event.session.allowedOperations
                    .contains(DropOperation.copy)) {
                  return DropOperation.copy;
                }
                return DropOperation.none;
              },
              onDropEnter: (event) {
                setState(() {
                  _isDragging = true;
                });
              },
              onDropLeave: (event) {
                setState(() {
                  _isDragging = false;
                });
              },
              onPerformDrop: (event) async {
                setState(() {
                  _isDragging = false;
                });

                // Handle dropped files
                for (final item in event.session.items) {
                  final reader = item.dataReader;
                  if (reader != null && reader.canProvide(Formats.fileUri)) {
                    reader.getValue<Uri>(Formats.fileUri, (fileUri) {
                      if (fileUri != null) {
                        // Extract filename from URI
                        final fileName = fileUri.pathSegments.isNotEmpty
                            ? fileUri.pathSegments.last
                            : fileUri.path.split('/').last.split('\\').last;

                        setState(() {
                          _files2.add(
                            _FileItem(
                              name: fileName,
                              state: CarbonFileUploaderItemState.uploading,
                            ),
                          );
                        });

                        // Simulate upload completion
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              final fileItem = _files2.firstWhere(
                                (f) => f.name == fileName,
                                orElse: () => _files2.last,
                              );
                              fileItem.state =
                                  CarbonFileUploaderItemState.complete;
                            });
                          }
                        });
                      }
                    }, onError: (error) {
                      debugPrint('Error reading file: $error');
                    });
                  }
                }
              },
              child: GestureDetector(
                onTap: () => _simulateFileUpload(_files2),
                child: CarbonFileUploaderDropZone(
                  isDragging: _isDragging,
                  onBrowseFiles: () => _simulateFileUpload(_files2),
                ),
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Different Item States',
          description: 'Uploading, complete, and edit states',
          builder: (context) => const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonFileUploaderItem(
                filename: 'uploading-file.pdf',
                state: CarbonFileUploaderItemState.uploading,
              ),
              CarbonFileUploaderItem(
                filename: 'completed-file.docx',
                state: CarbonFileUploaderItemState.complete,
              ),
              CarbonFileUploaderItem(
                filename: 'editable-file.xlsx',
                state: CarbonFileUploaderItemState.edit,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Item Sizes',
          description: 'Small, medium, and large file items',
          builder: (context) => const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonFileUploaderItem(
                filename: 'small-file.pdf',
                size: CarbonFileUploaderItemSize.small,
                state: CarbonFileUploaderItemState.complete,
              ),
              SizedBox(height: 8),
              CarbonFileUploaderItem(
                filename: 'medium-file.pdf',
                size: CarbonFileUploaderItemSize.medium,
                state: CarbonFileUploaderItemState.complete,
              ),
              SizedBox(height: 8),
              CarbonFileUploaderItem(
                filename: 'large-file.pdf',
                size: CarbonFileUploaderItemSize.large,
                state: CarbonFileUploaderItemState.complete,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Error State',
          description: 'File upload with validation errors',
          builder: (context) => const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonFileUploaderItem(
                filename: 'invalid-file.exe',
                state: CarbonFileUploaderItemState.edit,
                invalid: true,
                errorSubject: 'Invalid file type',
                errorBody: 'Only PDF, DOC, and DOCX files are allowed',
              ),
              SizedBox(height: 16),
              CarbonFileUploaderItem(
                filename: 'too-large.pdf',
                state: CarbonFileUploaderItemState.edit,
                invalid: true,
                errorSubject: 'File too large',
                errorBody: 'Maximum file size is 500mb. This file is 750mb',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'File uploader when disabled',
          builder: (context) => const CarbonFileUploader(
            labelTitle: 'Upload disabled',
            labelDescription: 'File upload is currently unavailable',
            disabled: true,
            child: CarbonFileUploaderButton(
              disabled: true,
              onPressed: null,
              child: Text('Add files'),
            ),
          ),
        ),
        DemoSection(
          title: 'Complete Example',
          description: 'Full file uploader with multiple files',
          builder: (context) => CarbonFileUploader(
            labelTitle: 'Upload attachments',
            labelDescription: 'You can upload up to 10 files (max 500mb each)',
            items: _files3
                .map(
                  (file) => CarbonFileUploaderItem(
                    filename: file.name,
                    state: file.state,
                    size: CarbonFileUploaderItemSize.medium,
                    onDelete: () {
                      setState(() => _files3.remove(file));
                    },
                  ),
                )
                .toList(),
            child: CarbonFileUploaderButton(
              onPressed: () => _simulateFileUpload(_files3),
              child: const Text('Select files'),
            ),
          ),
        ),
        DemoSection(
          title: 'Custom Drop Zone Content',
          description: 'Drop zone with custom content',
          builder: (context) => CarbonFileUploaderDropZone(
            isDragging: false,
            onBrowseFiles: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: context.carbon.text.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Drop your files here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.carbon.text.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'or click to browse',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Supported: PDF, DOC, DOCX, XLS, XLSX',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FileItem {
  final String name;
  CarbonFileUploaderItemState state;

  _FileItem({required this.name, required this.state});
}
