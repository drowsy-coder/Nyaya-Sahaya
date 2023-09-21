enum UserRole {
  lawyer,
  client,
}

String userRoleToString(UserRole role) {
  return role.toString().split('.').last;
}

UserRole stringToUserRole(String role) {
  return UserRole.values.firstWhere(
    (e) => e.toString().split('.').last == role,
    orElse: () => UserRole.client,
  );
}