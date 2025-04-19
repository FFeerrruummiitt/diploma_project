import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // URL вашего бэкенда
  static const String _baseUrl = 'http://127.0.0.1:8000'; // Замените на ваш URL

  // Функция для регистрации пользователя
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/signup/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': username,
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Успешный ответ
        return json.decode(response.body);
      } else {
        // Если ошибка на сервере
        return {
          'error': 'Failed to register user: ${response.body}',
        };
      }
    } catch (e) {
      // Ошибка при отправке запроса
      return {
        'error': 'Failed to connect to the server. Please try again later.',
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login/');  // Путь для логина
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Invalid credentials. Please try again.'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to the server. Please try again later.'};
    }
  }

  Future<List<Map<String, dynamic>>> getTechStacks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/techstacks/'));

      // Проверка, что запрос успешен
      if (response.statusCode == 200) {
        // Парсим JSON-ответ в список
        final data = json.decode(response.body);
        final List techStacks = data['tech_stacks'];

        // Возвращаем список технологий
        return techStacks.map((techStack) {
          return {
            'id': techStack['id'],
            'name': techStack['name'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load tech stacks');
      }
    } catch (e) {
      print('Error fetching tech stacks: $e');
      rethrow; // Пробрасываем ошибку дальше
    }
  }

  static Future<Map<String, dynamic>> submitForm({
    required String firstName,
    required String lastName,
    required String fathersName,
    required String sex,
    required String birthDate,
    required String phoneNumber,
    required String country,
    required String city,
    required String role,
    required String bin,
    required String education,
    required String institution,
    required String specialization,
    required List<String> techStack,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/form/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode({
      'first_name': firstName,
      'last_name': lastName,
      'fathers_name': fathersName,
      'sex': sex,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'country': country,
      'city': city,
      'role': role,
      'bin': bin,
      'education': education,
      'institution': institution,
      'specialization': specialization,
      'tech_stack': techStack,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to submit form. Try again later.'};
      }
    } on SocketException {
      return {'error': 'No Internet connection'};
    } on HttpException {
      return {'error': 'Couldn\'t reach the server'};
    } on FormatException {
      return {'error': 'Invalid server response'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
    }
  }

  Future<Map<String, dynamic>> submitEmployerInfo(Map<String, dynamic> data, String token) async {
    final csrfToken = await getCsrfToken();
    final url = Uri.parse('$_baseUrl/info/');
    final headers = {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken ?? '',
      'Cookie': 'csrftoken=$csrfToken',
    };

    // Ensure all fields are included and properly formatted
    final body = {
      'employer': data['employer'],
      'company_name': data['company_name'] ?? '',
      'industry': data['industry'] ?? '',
      'num_of_employees': data['num_of_employees'] ?? '',
      'location': data['location'] ?? '',
      'contact_person_full_name': data['contact_person_full_name'] ?? '',
      'contact_person_position': data['contact_person_position'] ?? '',
      'contact_person_phone_number': data['contact_person_phone_number'] ?? '',
      'contact_person_email': data['contact_person_email'] ?? '',
      'bin_of_company': data['bin_of_company'] ?? '',
      'links': data['links'] ?? [],
      'description': data['description'] ?? '',
      'institution_type': data['institution_type'] ?? '',
      'institution_name': data['institution_name'] ?? '',
      'employer_name': data['employer_name'] ?? '',
      'employer_surname': data['employer_surname'] ?? '',
      'employer_fathers_name': data['employer_fathers_name'] ?? '',
      'sex': data['sex'] ?? '',
      'date_of_birth': data['date_of_birth'] ?? '',
      'email': data['email'] ?? '',
      'phone_number': data['phone_number'] ?? '',
      'country': data['country'] ?? '',
      'city': data['city'] ?? '',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to submit employer info: ${response.body}'};
      }
    } catch (e) {
      return {'error': 'Failed to connect to the server. Please try again later.'};
    }
  }
// api_service.dart

  // Функция для получения CSRF-токена
  Future<String?> getCsrfToken() async {
    final url = Uri.parse('$_baseUrl/get-csrf-token/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Вы можете получить токен из JSON-ответа:
        final data = json.decode(response.body);
        final token = data['csrfToken'];
        print("Получен CSRF токен: $token");
        return token;
      } else {
        print('Ошибка при получении CSRF токена: ${response.body}');
      }
    } catch (e) {
      print('Exception при получении CSRF токена: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> submitVacancy({
    required String name,
    required String position,
    required int experience,
    required int salary,
    required int compensation,
    required String skills,
    required String responsibilities,
    required String deadline,
    required String workConditions,
  }) async {
    final url = Uri.parse('$_baseUrl/vacancy/');
    
    final csrfToken = await getCsrfToken();
    
    // Если вы получили токен, явно добавляем его в заголовки:
    final headers = {
      'Content-Type': 'application/json',
      if (csrfToken != null) 'X-CSRFToken': csrfToken,
      if (csrfToken != null) 'Cookie': 'csrftoken=$csrfToken', // Передаем куку
    };

    final body = json.encode({
      'name': name,
      'position': position,
      'experience': experience,
      'salary': salary,
      'compensation': compensation,
      'skills': skills,
      'responsibilities': responsibilities,
      'deadline': deadline,
      'work_conditions': workConditions,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Server error: ${response.body}'};
      }
    } catch (e) {
      print("Exception during submitVacancy: $e");
      return {'error': 'Connection error: $e'};
    }
  }
}

// api_service.dart
