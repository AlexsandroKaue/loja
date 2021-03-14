import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualv2/models/address.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  final Address address;
  const AddressInputField(this.address);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    String emptyValidator(String text) {
      return text.isEmpty ? 'Campo obrigatório' : null;
    }

    if(address.zipCode != null && cartManager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
                labelText: 'Rua/Avenida',
                hintText: 'Av. Brasil',
                isDense: true
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                      labelText: 'Número',
                      hintText: '123',
                      isDense: true
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,

                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                      labelText: 'Complemento',
                      hintText: 'Opicional',
                      isDense: true
                  ),
                  onSaved: (t) => address.complement = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
                labelText: 'Bairro',
                hintText: 'Parangaba',
                isDense: true
            ),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: address.city,
                  enabled: false,
                  decoration: const InputDecoration(
                      labelText: 'Cidade',
                      hintText: 'Fortaleza',
                      isDense: true
                  ),
                  validator: emptyValidator,
                  onSaved: (t) => address.city = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: address.state,
                  maxLength: 2,
                  enabled: false,
                  decoration: const InputDecoration(
                      labelText: 'Estado',
                      hintText: 'CE',
                      isDense: true,
                      counterText: ''
                  ),
                  keyboardType: TextInputType.text,
                  validator: emptyValidator,
                  onSaved: (t) => address.state = t,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
              color: primaryColor,
              disabledColor: primaryColor.withAlpha(100),
              textColor: Colors.white,
              onPressed: !cartManager.loading ?  () async {
                if(Form.of(context).validate()){
                  Form.of(context).save();
                  try {
                    await context.read<CartManager>().setAddress(address);
                  } catch(e) {
                   ScaffoldMessenger.of(context).removeCurrentSnackBar();
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$e'),
                        backgroundColor: Colors.red,
                      )
                   );
                  }
                }
              } : null,
              child: const Text('Calcular Frete')
          )
        ],
      );
    } else if(address.zipCode != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
            '${address.street}, ${address.number}\n${address.district}\n'
                '${address.city} - ${address.state}'
        ),
      );
    } else {
      return Container();
    }

  }
}
