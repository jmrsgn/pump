import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';

import '../../constants/app/ui_constants.dart';
import '../../utils/ui_utils.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final FocusNode? focusNode;

  const AppTextInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    this.focusNode,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  bool _canSend = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;

    if (hasText != _canSend) {
      setState(() => _canSend = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimen12,
        vertical: AppDimens.dimen10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.textDisabled.withValues(alpha: 0.12),
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          // Attach button
          InkWell(
            onTap: widget.onAttach,

            borderRadius: BorderRadius.circular(AppDimens.dimen24),

            child: Container(
              width: AppDimens.dimen40,
              height: AppDimens.dimen40,

              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                FontAwesomeIcons.paperclip,
                size: AppDimens.dimen16,
                color: AppColors.primary,
              ),
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppDimens.dimen48,
                maxHeight: 140,
              ),

              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimens.dimen24),
              ),

              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,

                minLines: 1,
                maxLines: 5,

                textCapitalization: TextCapitalization.sentences,

                style: AppTextStyles.body,

                decoration: InputDecoration(
                  hintText: AppStrings.typeAMessage,

                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textDisabled,
                  ),

                  border: InputBorder.none,

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimen16,
                    vertical: AppDimens.dimen12,
                  ),
                ),

                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    widget.onSend();
                  }
                },
              ),
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          // Send button
          AnimatedContainer(
            duration: Duration(milliseconds: UIConstants.milliseconds180),

            child: InkWell(
              onTap: _canSend ? widget.onSend : null,

              borderRadius: BorderRadius.circular(AppDimens.dimen24),

              child: Container(
                width: AppDimens.dimen44,
                height: AppDimens.dimen44,

                decoration: BoxDecoration(
                  color: _canSend ? AppColors.primary : AppColors.background,

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  _canSend
                      ? FontAwesomeIcons.paperPlane
                      : FontAwesomeIcons.microphone,

                  size: AppDimens.dimen16,

                  color: _canSend
                      ? AppColors.textOnPrimary
                      : AppColors.textDisabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
