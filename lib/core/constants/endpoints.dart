class ApiEndpoints {
  // End Points for the Authentication
  static const auth = '/auth';
  static const login = '$auth/login';
  static const register = '$auth/register';
  static const logout = '$auth/logout';
  static const refreshToken = '$auth/refresh-token';
  static const profile = '$auth/profile';

  // End Points for To-Dos
  static const todo = '/todos';
  static const list = '$todo?page=';

  // End Points for Upload
  static const upload = '/upload/image';
}
