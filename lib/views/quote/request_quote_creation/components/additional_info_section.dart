part of '../create_quote_screen.dart';

class _AdditionalSection extends StatefulWidget {
  final String? notes;
  // final QuoteMailType? mailType;
  final Function(String?) onNotesChanged;
  // final Function(QuoteMailType, List<String>? quantityOpts) onMailTypeChanged;
  const _AdditionalSection({
    required this.notes,
    // required this.mailType,
    required this.onNotesChanged,
    // required this.onMailTypeChanged,
  });

  @override
  State<_AdditionalSection> createState() => _AdditionalSectionState();
}

class _AdditionalSectionState extends State<_AdditionalSection> {
  // ** Constants - base data
  final List<(QuoteMailType, String)> _mailOptions = [
    (QuoteMailType.greenBeanQuote, 'Báo giá nhân xanh'),
    (QuoteMailType.brandQuote, 'Báo giá thương hiệu'),
    (QuoteMailType.quantityQuote, 'Báo giá số lượng'),
  ];
  // ** State management - data controller
  final CommonService _commonService = di<CommonService>();
  final OrderRepository _orderRepository = di<OrderRepository>();
  // ** States - variables
  String? _notes;
  // List<TemplateMailData> _templateMails = [];
  // QuoteMailType _crMailType = QuoteMailType.values.first;

  @override
  void initState() {
    super.initState();
    // if (widget.mailType.isNotNull) _crMailType = widget.mailType!;
    if (widget.notes.isNotNull) _notes = widget.notes!;
    // _loadActiveQuoteTemplateMails();
  }

  void _loadActiveQuoteTemplateMails() {
    // if ((_orderRepository.templateMails.valueOrNull ?? []).isNotEmpty) {
    //   _templateMails = _orderRepository.templateMails.valueOrNull ?? [];
    //   _notes = _templateMails
    //       .valueBy((e) => e.code == _crMailType.toConstant)
    //       ?.note;

    //   // Defer to next frame to avoid FocusScope assertion (parent setState during build)
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (mounted) widget.onNotesChanged(_notes);
    //   });
    // } else {
    //   _commonService.getActiveQuoteTemplateMails().then((value) {
    //     // Defer to next frame to avoid FocusScope assertion after async completion
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (!mounted) return;
    //       setState(() {
    //         _templateMails = value;
    //         _notes = _templateMails
    //             .valueBy((e) => e.code == _crMailType.toConstant)
    //             ?.note;
    //       });
    //       final opts = _templateMails
    //           .valueBy((e) => e.code == _crMailType.toConstant)
    //           ?.contentJSON?["headerQuantities"];
    //       widget.onMailTypeChanged(
    //         _crMailType,
    //         opts is List<String>? ? opts : null,
    //       );
    //       widget.onNotesChanged(_notes);
    //     });
    //   });
    // }
  }

  @override
  void didUpdateWidget(_AdditionalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.mailType != widget.mailType) {
    //   _crMailType = widget.mailType!;
    // }

    if (_notes != widget.notes) {
      _notes = widget.notes ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppColors.white,
      width: .infinity,
      child: ColumnWidget(
        crossAxisAlignment: CrossAxisAlignment.start,
        gap: 12.h,
        children: [
          Text(
            'Thông tin bổ sung',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
          // Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
          // ColumnWidget(
          //   crossAxisAlignment: .start,
          //   children: List.generate(
          //     _mailOptions.length,
          //     (index) => CommonRadioButtonItem(
          //       label: _mailOptions[index].$2,
          //       isSelected: _crMailType == _mailOptions[index].$1,
          //       onSelect: () {
          //         setState(() {
          //           _crMailType = _mailOptions[index].$1;
          //           _notes = _templateMails
          //               .valueBy((e) => e.code == _crMailType.toConstant)
          //               ?.note;
          //         });
          //         final opts = _templateMails
          //             .valueBy((e) => e.code == _crMailType.toConstant)
          //             ?.contentJSON?["headerQuantities"];

          //         widget.onMailTypeChanged(
          //           _mailOptions[index].$1,
          //           (opts ?? []).length > 0
          //               ? List.generate(opts.length, (i) => opts[i].toString())
          //               : null,
          //         );
          //       },
          //       trailing: Offstage(
          //         offstage: !_templateMails.any(
          //           (e) =>
          //               e.code == _mailOptions[index].$1.toConstant &&
          //               e.exampleImageUrl != null &&
          //               e.exampleImageUrl!.trim().isNotEmpty,
          //         ),
          //         child: TextButton(
          //           onPressed: () {
          //             final template = _templateMails
          //                 .where(
          //                   (e) =>
          //                       e.code == _mailOptions[index].$1.toConstant &&
          //                       e.exampleImageUrl != null &&
          //                       e.exampleImageUrl!.trim().isNotEmpty,
          //                 )
          //                 .firstOrNull;
          //             final url = template?.exampleImageUrl?.trim();
          //             if (url != null && url.isNotEmpty && context.mounted) {
          //               PreviewImageUrlScreen.open(
          //                 context,
          //                 title: _mailOptions[index].$2,
          //                 imageUrl: url,
          //               );
          //             }
          //           },
          //           child: Text(
          //             '(Xem mẫu)',
          //             style: AppStyles.text.medium(
          //               fSize: 12.sp,
          //               color: Colors.blue,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (_) => HtmlNoteEditorPage(
                        initialHtml: _notes ?? '',
                        title: 'Ghi chú báo giá',
                        hint: 'Nhập ghi chú báo giá',
                      ),
                    ),
                  )
                  .then((value) {
                    if (value is String?) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) widget.onNotesChanged(value);
                      });
                    }
                  });
            },
            child: Container(
              padding: .symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: .all(color: AppColors.greyC0),
              ),
              child: Html(
                data: _notes ?? "",
                style: {"*": Style(fontSize: FontSize(12), textAlign: .start)},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HtmlNoteEditorPage extends StatefulWidget {
  final String initialHtml;
  final String title;
  final String hint;
  const HtmlNoteEditorPage({
    super.key,
    required this.initialHtml,
    required this.title,
    required this.hint,
  });

  @override
  State<HtmlNoteEditorPage> createState() => _HtmlNoteEditorPageState();
}

class _HtmlNoteEditorPageState extends State<HtmlNoteEditorPage> {
  final HtmlEditorController _controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: widget.title,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        actions: [
          TextButton(
            onPressed: () => _save(context),
            child: RowWidget(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              mainAxisSize: .min,
              gap: 4.w,
              children: [
                Text(
                  'Lưu',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    height: 16 / 14,
                    color: AppColors.black3,
                  ),
                ),
                Icon(Icons.check_rounded, color: AppColors.black3, size: 16.sp),
              ],
            ),
          ),
        ],
      ),
      body: HtmlEditor(
        controller: _controller,
        htmlEditorOptions: HtmlEditorOptions(
          initialText: widget.initialHtml,
          hint: widget.hint,
          autoAdjustHeight: false,
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.aboveEditor,
          defaultToolbarButtons: [
            FontButtons(),
            ListButtons(),
            ParagraphButtons(),
            InsertButtons(link: true, picture: true, video: false),
          ],
        ),
        otherOptions: OtherOptions(height: MediaQuery.of(context).size.height),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    _controller.getText().then((value) {
      if (context.mounted) {
        context.navigator.pop(value);
      }
    });
  }
}
