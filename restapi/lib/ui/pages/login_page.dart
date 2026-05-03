import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:restapi/logic/bloc/Auth/auth_bloc.dart';
import 'package:restapi/logic/bloc/Auth/auth_event.dart';
import 'package:restapi/logic/bloc/Auth/auth_state.dart';
import 'package:restapi/ui/pages/dashboard_page.dart';
import 'package:restapi/ui/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFFAD1457)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 200,
                  left: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Selamat Datang",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                _buildGlassTextField(
                                  controller: _emailController,
                                  hint: "Email",
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Email tidak boleh kosong';
                                    if (!_isValidEmail(value))
                                      return 'Format email salah';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                _buildGlassTextField(
                                  controller: _passwordController,
                                  hint: "Password",
                                  icon: Icons.lock_outline,
                                  isPassword: _isObscure,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white38,
                                    ),
                                    onPressed: () => setState(
                                      () => _isObscure = !_isObscure,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Password wajib diisi';
                                    if (value.length < 6)
                                      return 'Minimal 6 karakter';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 40),

                                state is AuthLoading
                                    ? Center(
                                        child: Lottie.asset(
                                          'assets/loading.json',
                                          width : 100,
                                          height: 100,
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                LoginRequested(
                                                    _emailController.text,
                                                   _passwordController.text,
                                                 ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.purple.shade700,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Belum punya akun? ",
                                      style:
                                          TextStyle(color: Colors.white70),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Daftar",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          errorStyle: const TextStyle(
            color: Colors.yellowAccent,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
