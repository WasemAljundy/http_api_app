import 'package:api_project/getx/images_getx_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  void initState() {
    Get.put(ImageGetxController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image_screen'),
            icon: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
      body: GetX<ImageGetxController>(
        builder: (controller) {
          if (controller.studentImages.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: controller.studentImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        controller.studentImages[index].imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                color: Colors.white60,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsetsDirectional.only(start: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.studentImages[index].image,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async => await showDeleteDialog(
                                        id: controller.studentImages[index].id,
                                      ),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (controller.studentImages.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 85,
                    color: Colors.grey,
                  ),
                  Text(
                    'NO DATA!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


  Future<void> deleteImage({required int id}) async {
    await ImageGetxController.to.deleteImage(context, id: id);
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> showDeleteDialog({required int id}) async {
    Dialogs.materialDialog(
      msg: 'Are you sure to delete this image?\nYou can\'t undo this !',
      title: 'Delete',
      color: Colors.white,
      titleStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      msgStyle: const TextStyle(fontSize: 17),
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () => Navigator.pop(context),
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: const TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () => deleteImage(id: id),
          text: 'Delete',
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

}
