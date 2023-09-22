import 'package:flutter/material.dart';
import '../../models/user_role.dart';

class LoginUI extends StatelessWidget {
  final bool isLoginForm;
  final UserRole userRole;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController identifierController;
  final Function(UserRole?) onUserRoleChanged;
  final Function() onFormSubmitted;
  final Function() onToggleFormMode;
  final bool isLoading;

  const LoginUI({
    super.key,
    required this.isLoginForm,
    required this.userRole,
    required this.emailController,
    required this.passwordController,
    required this.identifierController,
    required this.onUserRoleChanged,
    required this.onFormSubmitted,
    required this.onToggleFormMode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isLoginForm ? 'Login' : 'Create Account',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => onUserRoleChanged(UserRole.client),
                  style: ElevatedButton.styleFrom(
                    primary: userRole == UserRole.client
                        ? Colors.red
                        : Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Client',
                    style: TextStyle(
                      fontSize: 18,
                      color: userRole == UserRole.client
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => onUserRoleChanged(UserRole.lawyer),
                  style: ElevatedButton.styleFrom(
                    primary: userRole == UserRole.lawyer
                        ? Colors.red
                        : Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Lawyer',
                    style: TextStyle(
                      fontSize: 18,
                      color: userRole == UserRole.lawyer
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildTextFormField(emailController, 'Email'),
            const SizedBox(height: 20),
            _buildTextFormField(passwordController, 'Password',
                isPassword: true),
            if (userRole == UserRole.lawyer) const SizedBox(height: 20),
            if (userRole == UserRole.lawyer)
              _buildTextFormField(identifierController, 'Bar Number'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: onFormSubmitted,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLoginForm ? 'Login' : 'Create Account',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onToggleFormMode,
              child: Text(
                isLoginForm ? 'Create an account' : 'Have an account? Sign in',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (isLoading) const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: isPassword,
    );
  }
}
