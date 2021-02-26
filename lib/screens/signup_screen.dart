import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtualv2/helpers/validators.dart';
import 'package:lojavirtualv2/models/user.dart' as local;
import 'package:lojavirtualv2/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  local.User user = local.User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Nome Completo'),
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (name.trim().split(' ').length < 2) {
                          return 'Preencha seu nome completo';
                        }
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                      enabled: !userManager.loading,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!emailValid(email)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      controller: _passwordController,
                      validator: (password) {
                        if (password.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (password.length < 6) {
                          return 'Senha deve ter mais de 6 caracteres';
                        }
                        return null;
                      },
                      onSaved: (password) => user.password = password,
                      enabled: !userManager.loading,
                      autocorrect: false,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Repita a Senha'),
                      controller: _confirmController,
                      validator: (confirm) {
                        if (confirm.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (confirm.length < 6) {
                          return 'Senha deve ter no mínimo 6 caracteres';
                        }
                        /*else if(_passwordController.text != _confirmController.text){
                        return 'Confirmação diferente da senha';
                      }*/
                        return null;
                      },
                      onSaved: (confirm) => user.confirmPassword = confirm,
                      enabled: !userManager.loading,
                      autocorrect: false,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        color: userManager.loading
                            ? Theme.of(context).primaryColor.withAlpha(100)
                            : Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  if (user.password != user.confirmPassword) {
                                    scaffoldKey.currentState.removeCurrentSnackBar();
                                    scaffoldKey.currentState.showSnackBar(const SnackBar(
                                      content: Text('Senhas não coincidem!'),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                    return;
                                  }
                                  userManager.signUp(
                                    user,
                                    onFail: (errorCode) {
                                      scaffoldKey.currentState.removeCurrentSnackBar();
                                      scaffoldKey.currentState.showSnackBar(SnackBar(
                                        content: Text('$errorCode'),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                    },
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                    }
                                  );
                                }
                              },
                        child: userManager.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'Criar Conta',
                                style: TextStyle(fontSize: 18.0),
                              ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
