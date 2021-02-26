import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final imagePicker = ImagePicker();
  final Function onImageSelected;
  ImageSourceSheet({@required this.onImageSelected});

  Future<File> editImage(String path, BuildContext context){
    return ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar Imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar Imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir'
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return BottomSheet(
          onClosing: (){},
          builder: (_){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                    onPressed: () async {
                      final PickedFile file = await imagePicker.getImage(
                          source: ImageSource.camera);
                      final croppedImage = await editImage(file.path, context);
                      if(croppedImage!=null) {
                        onImageSelected(croppedImage);
                      }
                    },
                    child: Text('Câmera',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                ),
                FlatButton(
                    onPressed: () async {
                      final PickedFile file = await imagePicker.getImage(
                          source: ImageSource.gallery);
                      final croppedImage = await editImage(file.path, context);
                      if(croppedImage!=null) {
                        onImageSelected(croppedImage);
                      }
                    },
                    child: Text('Galeria',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                )
              ],
            );
          }
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancelar')
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final PickedFile file = await imagePicker.getImage(
                  source: ImageSource.camera);
              final croppedImage = await editImage(file.path, context);
              if(croppedImage!=null) {
                onImageSelected(croppedImage);
              }
            },
            child: const Text('Câmera')
          ),
          CupertinoActionSheetAction(
              onPressed: () async {
                final PickedFile file = await imagePicker.getImage(
                    source: ImageSource.gallery);
                final croppedImage = await editImage(file.path, context);
                if(croppedImage!=null) {
                  onImageSelected(croppedImage);
                }
              },
              child: const Text('Galeria')
          )
        ],
      );
    }

  }
}
