import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_icon_button.dart';
import 'package:lojavirtualv2/models/item_size.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/screens/edit_product/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Product product;
  const SizesForm(this.product);

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if(sizes.isEmpty) {
          return 'Insira ao menos um tamanho';
        }
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: (){
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: (){
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first ? (){
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index-1, size);
                    state.didChange(state.value);
                  } : null,
                  onMoveDown: size != state.value.last ? (){
                    final index = state.value.indexOf(size);
                    state.value.remove(size);
                    state.value.insert(index+1, size);
                    state.didChange(state.value);
                  } : null,
                );
              }).toList(),
            ),
            if(state.hasError)
              Container(
                alignment: Alignment.centerLeft,
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