import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/address.dart';
import 'package:lojavirtualv2/models/cart_manager.dart';
import 'package:lojavirtualv2/screens/address/components/address_input_field.dart';
import 'package:lojavirtualv2/screens/address/components/cep_input_field.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Form(
          child: Consumer<CartManager>(
            builder: (_, cartManager, __) {
              final address = cartManager.address ?? Address();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ),
                  ),
                  CepInputField(address),
                  AddressInputField(address)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
