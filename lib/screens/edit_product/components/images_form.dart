import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;
  const ImagesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if(images.isEmpty) {
          return 'Insira ao menos uma imagem';
        }
        return null;
      },
      onSaved: (images) => product.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if(image is String)
                        Image.network(image, fit: BoxFit.cover,)
                      else
                        Image.file(image as File, fit: BoxFit.cover,),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          color: Colors.red,
                          onPressed: (){
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()..add(
                  Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                      onPressed: (){
                        if(Platform.isAndroid) {
                          showBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              )
                          );
                        } else {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              )
                          );
                        }

                      },
                    ),
                  )
                ),
                dotSize: 4,
                dotSpacing: 15,
                dotColor: Theme.of(context).primaryColor,
                dotBgColor: Colors.transparent,
                autoplay: false,
              ),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12
                  ),
                ),
              )
          ],
        );
      }
    );
  }
}
