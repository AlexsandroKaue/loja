import 'package:flutter/material.dart';
import 'package:lojavirtualv2/commom/custom_icon_button.dart';
import 'package:lojavirtualv2/models/item_size.dart';

class EditItemSize extends StatelessWidget {

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const EditItemSize({Key key, this.size, this.onRemove,
    this.onMoveUp, this.onMoveDown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            validator: (name) {
              if(name.isEmpty){
                return 'Inválido';
              }
              return null;
            },
            onChanged: (name) => size.name = name,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Flexible(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            validator: (stock) {
              if(int.tryParse(stock) == null) {
                return 'Inválido';
              }
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
            decoration: const InputDecoration(
                labelText: 'Estoque',
                isDense: true
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 4,),
        Flexible(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            validator: (price) {
              if(num.tryParse(price) == null) {
                return 'Inválido';
              }
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$ '
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        )
      ],
    );
  }
}
