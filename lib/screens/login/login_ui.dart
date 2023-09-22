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
    Key? key,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              DropdownButtonFormField<UserRole>(
                value: userRole,
                onChanged: onUserRoleChanged,
                items: const [
                  DropdownMenuItem(
                    value: UserRole.client,
                    child: Text(
                      'Client',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: UserRole.lawyer,
                    child: Text(
                      'Lawyer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  labelText: 'Select Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              if (userRole == UserRole.lawyer) const SizedBox(height: 20),
              if (userRole == UserRole.lawyer) // Show only for lawyers
                TextFormField(
                  controller: identifierController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Bar Number',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onFormSubmitted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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
                  isLoginForm
                      ? 'Create an account'
                      : 'Have an account? Sign in',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (isLoading) const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
