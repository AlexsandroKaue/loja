import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtualv2/commom/custom_icon_button.dart';
import 'package:lojavirtualv2/models/address.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  final Address address;
  const CepInputField(this.address);

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final _cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;


    if(widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'CEP',
                hintText: '12.524-61'
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter()
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if(cep.isEmpty) {
                return 'Campo obrigatório';
              } else if(cep.length < 10) {
                return 'CEP inválido';
              }
              return null;
            },
            controller: _cepController,
          ),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          const SizedBox(height: 8,),
          RaisedButton(
            onPressed: !cartManager.loading ? () async {
              if(Form.of(context).validate()) {
                try{
                  await context.read<CartManager>().getAddress(_cepController.text);
                } catch (e) {
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
            textColor: Colors.white,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            child: const Text('Buscar CEP'),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: primaryColor
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }

  }
}
