import 'package:flutter/material.dart';
// 1. Importe o Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap; // Adicione esta linha

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 2. Variáveis para feedback ao usuário
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 3. Inicia o loading e limpa erros antigos
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 4. A Mágica! Tenta fazer login com o Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // .trim() remove espaços
        password: _passwordController.text.trim(),
      );
      
      // Se chegar aqui, o login foi um sucesso!
      // O AuthWrapper (que vamos implementar) cuidará de nos levar para a Home.
      
    } on FirebaseAuthException catch (e) {
      // 5. Trata erros comuns de login
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
          _errorMessage = 'Email ou senha inválidos.';
        } else {
          _errorMessage = 'Ocorreu um erro. Tente novamente.';
        }
      });
    } finally {
      // 6. Para o loading, independente de sucesso ou falha
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 7. Mostra a mensagem de erro, se houver
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),

              // 8. Mostra um loading ou o botão
              _isLoading
                  ? const CircularProgressIndicator() // Tela de loading
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
              
              TextButton(
                onPressed: widget.onTap,
                child: const Text('Não tem uma conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}