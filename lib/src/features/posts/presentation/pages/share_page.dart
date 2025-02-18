import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/post_input.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/privacy_widget.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SharePage extends ConsumerWidget {
  final int postId;
  const SharePage(this.postId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: PopScope(
          onPopInvoked: (didPop) =>
              ref.watch(postControllerProvider).shareContentController.clear(),
          child: shareComponent(ref, context)),
    );
  }

  Widget shareComponent(WidgetRef ref, BuildContext context) {
    final userController = ref.watch(userControllerProvider);
    final postingController = ref.watch(postingControllerProvider);
    final postController = ref.watch(postControllerProvider);
    return Wrap(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(5)),
            width: 30,
            height: 4,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Wrap(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userController
                            .userData?.data?.avatar ??
                        "https://ui-avatars.com/api/?name=${userController.userData?.data?.fullName}&background=random"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userController.userData?.data?.fullName ?? "",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      privacyWidget(postingController, context)
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              postInput(
                  controller: postController.shareContentController,
                  minLines: 3,
                  maxLines: 10),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 35,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: AppColors.executeButton),
                      onPressed: () async => await postController.sharePost(
                          postId: postId,
                          privacy: postingController.selectedPrivacy,
                          context: context),
                      child: const Text(
                        "Chia sẻ",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      )),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
