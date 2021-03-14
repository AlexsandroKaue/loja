import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/models/address.dart';
import 'package:lojavirtualv2/models/cart_product.dart';
import 'package:lojavirtualv2/models/product.dart';
import 'package:lojavirtualv2/models/user.dart';
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:lojavirtualv2/services/cepaberto_service.dart';
import 'package:lojavirtualv2/services/viacep_service.dart';
import 'package:geolocator/geolocator.dart';

class CartManager extends ChangeNotifier{
  List<CartProduct> items = [];
  User user;
  num productsPrice = 0.0;
  num deliveryPrice;
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  Address address;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.get();

    items = cartSnap.docs.map((d) {
      return CartProduct.fromDocument(d)..addListener(_onItemUpdated);
    }).toList();
  }

  Future<void> _loadUserAddress() async {
    if(user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
  }

  void addToCart(Product product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch(e) {
      final cartProduct = CartProduct.fromProduct(product);
      //Adiciona um ouvinte para quando o cartProduct chama notifyListener
      // e em seguida executa _onItemUpdated
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toMap()).then(
          (ref) => cartProduct.id = ref.id
      );
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct){
    items.removeWhere((p) => p.id == cartProduct.id);
    user.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if(user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  bool get isCartValid {
    for(final cartProduct in items) {
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  void _onItemUpdated(){
    productsPrice = 0.0;
    final iterator = items.iterator;
    for(int i=0; i<items.length; i++){
      final cartProduct = items[i];
      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  Future<void> _updateCartProduct(CartProduct cartProduct) async {
    if(cartProduct.id != null) {
      await user.cartReference.doc(cartProduct.id)
          .update(cartProduct.toMap());
    }
  }

  //ADDRESS

  Future<void> getAddress(String cep) async {
    loading = true;

    final cepabertoService = CepAbertoService();
    //final viaCepService = ViaCepService();

    try{
      final cepAbertoAddress = await cepabertoService.getAddressFromCep(cep);
      //final viaCepAddress = await viaCepService.getAddressFromCep(cep);

      if(cepAbertoAddress != null){
        address = Address(
            street: cepAbertoAddress.logradouro,
            district: cepAbertoAddress.bairro,
            zipCode: cepAbertoAddress.cep,
            city: cepAbertoAddress.cidade.nome,
            state: cepAbertoAddress.estado.sigla,
            lat: cepAbertoAddress.latitude,
            long: cepAbertoAddress.longitude
        );
      }

      /*if(viaCepAddress != null){
        address = Address(
            street: viaCepAddress.logradouro,
            district: viaCepAddress.bairro,
            zipCode: viaCepAddress.cep,
            city: viaCepAddress.localidade,
            state: viaCepAddress.uf,
        );
      }*/
      loading = false;
    } catch(e) {
      loading = false;
      return Future.error(e);
    }

  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if(await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    final latStore = doc.data()['lat'] as double;
    final longStore = doc.data()['long'] as double;
    final maxkm = doc.data()['maxkm'] as num;
    final taxbase = doc.data()['taxbase'] as num;
    final taxkm = doc.data()['taxkm'] as num;

    double distance = Geolocator.distanceBetween(latStore, longStore, lat, long);
    distance /= 1000.0;
    if(distance > maxkm) {
      return false;
    }

    debugPrint('Distância: $distance');
    deliveryPrice = taxbase + distance * taxkm;
    debugPrint('Valor do frete: $deliveryPrice');
    return true;
  }
}
