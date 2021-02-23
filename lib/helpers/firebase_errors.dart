String getErrorString(String code){
  switch (code) {
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    case 'user-not-found':
      return 'Não há usuário com este e-mail.';
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
    case 'email-already-in-use':
      return 'Este email já está em uso';

    default:
      return 'Um erro indefinido ocorreu.';
  }
}