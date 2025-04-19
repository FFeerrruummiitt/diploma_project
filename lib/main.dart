import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'services/api_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    // NEW FEATURE USER PLEASE
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(
              'assets/images/logoLaunch.png',
              width: size.width * 0.4, // 40% от ширины экрана
              height: size.height * 0.12, // 12% от высоты экрана
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              "Skyler TechHire",
              style:
                  TextStyle(fontSize: size.width * 0.06, color: Colors.white),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              "Welcome back!",
              style: TextStyle(
                  fontSize: size.width * 0.045, color: Colors.white70),
            ),
            SizedBox(height: size.height * 0.04),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, size.height * 0.07),
              ),
              child: Text("Sign IN",
                  style: TextStyle(
                      fontSize: size.width * 0.05, color: Colors.white)),
            ),
            SizedBox(height: size.height * 0.025),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.8, size.height * 0.07),
              ),
              child: Text("Sign UP",
                  style: TextStyle(fontSize: size.width * 0.05)),
            ),
            const Spacer(),
            Text(
              "Login with Social Media",
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/socialMedia/googleLogo.png'),
                  iconSize: size.width * 0.12,
                  onPressed: () {},
                ),
                SizedBox(width: size.width * 0.05),
                IconButton(
                  icon:
                      Image.asset('assets/images/socialMedia/facebookLogo.png'),
                  iconSize: size.width * 0.12,
                  onPressed: () {},
                ),
                SizedBox(width: size.width * 0.05),
                IconButton(
                  icon:
                      Image.asset('assets/images/socialMedia/twitterLogo.png'),
                  iconSize: size.width * 0.12,
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}

// РЕГИСТРАЦИЯ
class SignUpScreen extends StatefulWidget {  // Меняем на StatefulWidget для обновления состояния
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _message = '';

  void _register() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    // Проверка на совпадение паролей
    if (password != _confirmPasswordController.text) {
      setState(() {
        _message = 'Passwords do not match.';
      });
      return;
    }

    final apiService = ApiService();
    final result = await apiService.signup(username, email, password);

    if (result['message'] != null) {
      setState(() {
        _message = 'Registration successful!';
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInScreen(),
            ));
      });
    } else {
      // Если ошибка
      setState(() {
        _message = result['error'] ?? 'Registration failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Верхняя черная часть
          Container(
            width: double.infinity,
            height: size.height * 0.3, // 30% высоты экрана
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Your",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Account",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          // Закругленный белый контейнер
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.03),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Gmail"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // Сообщение о статусе регистрации
                  if (_message.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      color: _message == 'Registration successful!' 
                          ? Colors.green 
                          : Colors.red,
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    ),

                  // Кнопка "Sign UP"
                  Center(
                    child: ElevatedButton(
                      onPressed: _register,  // Вызываем _register
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7360DF),
                        minimumSize: Size(size.width * 0.8, size.height * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Sign UP",
                        style: TextStyle(
                            fontSize: size.width * 0.05, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // "Have you already registered?" + "Sign IN"
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Have you already registered?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.04),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                            },
                            child: Text(
                              "Sign IN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.045,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// Логин
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _message = ''; // Сообщение для отображения статуса входа

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final apiService = ApiService();
    final result = await apiService.login(email, password);

    if (result['message'] != null) {
      // Если логин успешен, показываем сообщение и переходим на следующий экран
      setState(() {
        _message = 'Login successful!';
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoleSelectionScreen(), // Замените на нужный экран после входа
            ));
      });
    } else {
      // Если ошибка
      setState(() {
        _message = result['error'] ?? 'Login failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Верхняя черная часть
          Container(
            width: double.infinity,
            height: size.height * 0.3,
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nice to see",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "You here again!",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          // Закругленный белый контейнер
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.03),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        // Действие при нажатии на "Forgot Password"
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.005),
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.04,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Сообщение о статусе логина
                  if (_message.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10),
                      color: _message == 'Login successful!' 
                          ? Colors.green 
                          : Colors.red,
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    ),

                  // Кнопка "Sign IN"
                  Center(
                    child: ElevatedButton(
                      onPressed: _login, // Вызываем _login
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7360DF),
                        minimumSize: Size(size.width * 0.8, size.height * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Sign IN",
                        style: TextStyle(
                            fontSize: size.width * 0.05, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ВЫБОР РОЛИ
class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(
                bottom: size.height * 0.2,
                top: size.height * 0.1,
              ),
              child: Image.asset('assets/images/logoLaunch.png',
                  width: size.width * 0.4, height: size.height * 0.12),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Join as a",
                    style: TextStyle(
                        fontSize: size.width * 0.045, color: Colors.white)),
                Text(
                  "Freelancer or Contractor!",
                  style: TextStyle(
                      fontSize: size.width * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(size.width * 0.75, size.height * 0.07),
              ),
              child: Text("Freelancer",
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * 0.05)),
            ),
            SizedBox(height: size.height * 0.02),
            ElevatedButton(
              onPressed: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WhoAreYouScreen()));
              
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.75, size.height * 0.07),
              ),
              child: Text("Contractor",
                  style: TextStyle(fontSize: size.width * 0.05)),
            ),
            SizedBox(height: size.height * 0.3),
          ],
        ),
      ),
    );
  }
}


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String selectedGender = "";
  String selectedCountry = "";
  String selectedCity = "";
  String selectedEmailDomain = "";
  TextEditingController emailController = TextEditingController();

  final List<String> countries = [
    "Russia",
    "Kazakhstan",
    "Uzbekistan",
    "Kyrgyzstan"
  ];
  final Map<String, List<String>> cities = {
    "Russia": ["Moscow", "Saint Petersburg", "Novosibirsk", "Yekaterinburg"],
    "Kazakhstan": ["Almaty", "Astana", "Shymkent", "Karaganda"],
    "Uzbekistan": ["Tashkent", "Samarkand", "Bukhara", "Andijan"],
    "Kyrgyzstan": ["Bishkek", "Osh", "Jalal-Abad", "Karakol"]
  };
  final List<String> emailDomains = ["@gmail.com", "@mail.ru", "@yahoo.com"];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: countries
            .map((country) => ListTile(
                  title: Text(country, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedCountry = country;
                      selectedCity = "";
                    });
                    Navigator.pop(context);
                    _showCityPicker(country);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showCityPicker(String country) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: cities[country]!
            .map((city) => ListTile(
                  title: Text(city, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showEmailDomainPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: emailDomains
            .map((domain) => ListTile(
                  title: Text(domain, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedEmailDomain = domain;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  TextEditingController _dateController = TextEditingController();

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dateController.text = "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight + MediaQuery.of(context).size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Закругление только внизу
            ),
          ),
          backgroundColor: Colors.black,
          leading: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                0.0001), // Адаптивные отступы
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage: const AssetImage(
                    'assets/images/backButton.png'), // Добавьте свое изображение
                radius: MediaQuery.of(context).size.width *
                    0.16, // Адаптивный размер аватарки
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RoleSelectionScreen()));
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Fill out the form",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: "Name")),
            TextField(decoration: InputDecoration(labelText: "Surname")),
            TextField(decoration: InputDecoration(labelText: "Father's name")),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var gender in ["Male", "Female"])
                  GestureDetector(
                    onTap: () => setState(() => selectedGender = gender),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: selectedGender == gender
                            ? Colors.black
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        gender,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              readOnly:
                  true, // Запрещает ручной ввод, только выбор через календарь
              decoration: const InputDecoration(
                labelText: "Date of Birth (DD MM YYYY)",
                suffixIcon: Icon(Icons.calendar_today), // Иконка календаря
              ),
              onTap: () => _selectDate(context),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Write email"))),
                IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: _showEmailDomainPicker),
                Text(selectedEmailDomain, style: TextStyle(fontSize: 16)),
              ],
            ),
            const TextField(
                decoration: InputDecoration(labelText: "Write phone number")),
            GestureDetector(
              onTap: _showCountryPicker,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: selectedCountry.isEmpty
                        ? "Where are you from? (click here)"
                        : selectedCountry,
                  ),
                ),
              ),
            ),
            if (selectedCountry.isNotEmpty)
              GestureDetector(
                onTap: () => _showCityPicker(selectedCountry),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: selectedCity.isEmpty
                          ? "Choose your City"
                          : selectedCity,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.3, // 30% от ширины экрана
                height: MediaQuery.of(context).size.height *
                    0.04, // 4% от высоты экрана
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EducationSelectionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationSelectionScreen extends StatefulWidget {
  @override
  _EducationSelectionScreenState createState() =>
      _EducationSelectionScreenState();
}

class _EducationSelectionScreenState extends State<EducationSelectionScreen> {
  String selectedEducation = "";
  String selectedUniversity = "";

  final List<String> educationLevels = [
    "Secondary education",
    "Higher education",
    "Bachelor",
    "Master’s degree",
    "PhD",
    "Doctor of Science"
  ];

  final List<String> universities = [
    "Al-Farabi Kazakh National University",
    "Astana IT University",
    "International Information TU",
    "Kazakh-British TU",
    "Kazakh National Agrarian U",
    "Satbayev University",
    "Kazakh National University",
    "Kazakh-American University",
    "KIMEP University",
    "Eurasian National University",
    "M. Auezov University",
    "Narxoz University",
    "S. Seifullin Kazakh Agro TU",
  ];

  void _showUniversityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: universities
            .map((university) => ListTile(
                  title:
                      Text(university, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedUniversity = university;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight + MediaQuery.of(context).size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Colors.black,
          leading: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0001),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/backButton.png'),
                radius: MediaQuery.of(context).size.width * 0.16,
              ),
              onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));},
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What’s your education?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: educationLevels
                  .map((level) => Row(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: level,
                            groupValue: selectedEducation,
                            onChanged: (value) {
                              setState(() {
                                selectedEducation = value.toString();
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              level,
                              style: TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              "What educational institution did you graduate from?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: _showUniversityPicker,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: selectedUniversity.isEmpty
                        ? "Select your university"
                        : selectedUniversity,
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width *
                          0.42, // 40% ширины экрана
                      MediaQuery.of(context).size.height *
                          0.04, // 6% высоты экрана
                    ),
                  ),
                  child: Text("Back",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobSelectionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width *
                          0.42, // 40% ширины экрана
                      MediaQuery.of(context).size.height *
                          0.04, // 6% высоты экрана
                    ),
                  ),
                  child: Text("Next",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,)
          ],
        ),
      ),
    );
  }
}

class JobSelectionScreen extends StatefulWidget {
  @override
  _JobSelectionScreenState createState() => _JobSelectionScreenState();
}

class _JobSelectionScreenState extends State<JobSelectionScreen> {
  String? aboutMe;
  List<Map<String, dynamic>> techStacks = [];
  List<String> selectedTechs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTechStacks();
  }

  Future<void> fetchTechStacks() async {
    try {
      final apiService = ApiService();
      final techData = await apiService.getTechStacks();
      setState(() {
        techStacks = techData;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching tech stacks: $e');
      setState(() => isLoading = false);
    }
  }

  void toggleSelection(String techName) {
    setState(() {
      if (selectedTechs.contains(techName)) {
        selectedTechs.remove(techName);
      } else {
        selectedTechs.add(techName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/images/backButton.png'),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What do you wanna work for?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  aboutMe = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Select your primary skills:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            isLoading ? _buildLoadingShimmer() : _buildTechStackButtons(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.42,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                  child: Text("Back", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: (
                    
                  ) {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.42,
                      MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03)
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(6, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTechStackButtons() {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth; 
      double spacing = 10; 
      int maxPerRow = 3; 
      double flexibleWidth = (maxWidth - (spacing * (maxPerRow - 1))) / maxPerRow; 

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: techStacks.map((tech) {
          final isSelected = selectedTechs.contains(tech['name']);

          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: flexibleWidth / 2, 
              maxWidth: flexibleWidth, 
            ),
            child: GestureDetector(
              onTap: () => toggleSelection(tech['name']),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    tech['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

}


// class JobSelectionScreen extends StatefulWidget {
//   @override
//   _JobSelectionScreenState createState() => _JobSelectionScreenState();
// }

// class _JobSelectionScreenState extends State<JobSelectionScreen> {
//   String? selectedJobType;
//   List<String> selectedSkills = [];

//   final Map<String, List<String>> jobCategories = {
//     "Frontend": ["React", "Vue", "Angular", "Flutter"],
//     "Backend": ["Node.js", "Django", "Spring", "Laravel"],
//     "Mobile": ["Swift", "Kotlin", "Flutter", "React Native"],
//     "Data Science": ["Python", "R", "TensorFlow", "PyTorch"],
//   };

//   void _showJobTypePicker() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.black,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => ListView(
//         padding: EdgeInsets.all(20),
//         children: jobCategories.keys
//             .map((jobType) => ListTile(
//                   title: Text(jobType, style: TextStyle(color: Colors.white)),
//                   onTap: () {
//                     setState(() {
//                       selectedJobType = jobType;
//                       selectedSkills.clear();
//                     });
//                     Navigator.pop(context);
//                   },
//                 ))
//             .toList(),
//       ),
//     );
//   }

//   void _toggleSkillSelection(String skill) {
//     setState(() {
//       if (selectedSkills.contains(skill)) {
//         selectedSkills.remove(skill);
//       } else {
//         selectedSkills.add(skill);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: CircleAvatar(
//             backgroundImage: AssetImage('assets/images/backButton.png'),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("What do you wanna work for?",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: _showJobTypePicker,
//               child: AbsorbPointer(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     labelText: selectedJobType ?? "Select job type",
//                     suffixIcon: Icon(Icons.arrow_drop_down),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (selectedJobType != null) ...[
//               Text("Select your primary skills:",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: jobCategories[selectedJobType]!
//                     .map((skill) => ChoiceChip(
//                           label: Text(skill),
//                           selected: selectedSkills.contains(skill),
//                           selectedColor: Colors.black,
//                           backgroundColor: Colors.white,
//                           labelStyle: TextStyle(
//                               color: selectedSkills.contains(skill)
//                                   ? Colors.white
//                                   : Colors.black),
//                           onSelected: (_) => _toggleSkillSelection(skill),
//                         ))
//                     .toList(),
//               ),
//             ],
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF7360DF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     minimumSize: Size(
//                       MediaQuery.of(context).size.width * 0.42,
//                       MediaQuery.of(context).size.height * 0.04,
//                     ),
//                   ),
//                   child: Text("Back",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF7360DF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     minimumSize: Size(
//                       MediaQuery.of(context).size.width * 0.42,
//                       MediaQuery.of(context).size.height * 0.04,
//                     ),
//                   ),
//                   child: Text("Next",
//                       style: TextStyle(color: Colors.white, fontSize: 16)),
//                 ),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.03)
//           ],
//         ),
//       ),
//     );
//   }
// }



  // Widget _buildLoadingShimmer() {
  //   return Column(
  //     children: List.generate(6, (index) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Shimmer.fromColors(
  //           baseColor: Colors.grey[300]!,
  //           highlightColor: Colors.grey[100]!,
  //           child: Container(
  //             width: double.infinity,
  //             height: 50,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }



/// Первый экран, где пользователь выбирает, кто он: Company, Education или Private Person
class WhoAreYouScreen extends StatefulWidget {
  @override
  _WhoAreYouScreenState createState() => _WhoAreYouScreenState();
}

class _WhoAreYouScreenState extends State<WhoAreYouScreen> {
  // Храним выбранный вариант
  String _selectedRole = 'Company'; // По умолчанию

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// Адаптивная высота AppBar с закруглённым низом
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          kToolbarHeight + MediaQuery.of(context).size.height * 0.01,
        ),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // закругляем только низ
            ),
          ),
          backgroundColor: Colors.black,
          leading: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.0001,
            ), // Адаптивный отступ
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage: const AssetImage('assets/images/backButton.png'),
                radius: MediaQuery.of(context).size.width * 0.16,
              ),
              onPressed: () {
                // Логика возврата назад, либо Navigator.pop(context)
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Заголовок
            const Text(
              "Who are You?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// Радио-кнопки для выбора роли
            RadioListTile<String>(
              title: const Text("Company (General category for organizations)"),
              value: "Company",
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Privat Persons (e.g. employer for privat work)"),
              value: "Private",
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 20),
            SizedBox(height: MediaQuery.of(context).size.height * 0.48,),
            /// Кнопка Next
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,  // 30% от ширины экрана
                height: MediaQuery.of(context).size.height * 0.04, // 4% от высоты экрана
                
                child: ElevatedButton(
                  onPressed: () {
                    /// В зависимости от выбранной роли переходим на разные экраны
                    if (_selectedRole == "Company") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompanyRegistrationScreen(),
                        ),
                      );
                    }else if (_selectedRole == "Private") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivatePersonRegistrationScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CompanyRegistrationScreen extends StatefulWidget {
  @override
  _CompanyRegistrationScreenState createState() =>
      _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
  // Контроллеры для каждого поля формы
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController companySizeController = TextEditingController();
  final TextEditingController registeredAddressController =
      TextEditingController();
  final TextEditingController contactPersonNameController =
      TextEditingController();
  final TextEditingController contactPersonPositionController =
      TextEditingController();
  final TextEditingController contactDetailsPhoneController =
      TextEditingController();
  final TextEditingController contactDetailsEmailController =
      TextEditingController();
  final TextEditingController iinController = TextEditingController();
  final TextEditingController organizationLinkController =
      TextEditingController();
  final TextEditingController addMoreLink1Controller = TextEditingController();
  final TextEditingController addMoreLink2Controller = TextEditingController();
  final TextEditingController addMoreLink3Controller = TextEditingController();
  final TextEditingController overviewController = TextEditingController();

  final ApiService _apiService = ApiService();

  void _onNextPressed() async {
    final data = {
      'employer': 'company', // Ensure this matches the backend's expected value
      'company_name': companyNameController.text,
      'industry': industryController.text,
      'num_of_employees': companySizeController.text,
      'location': registeredAddressController.text,
      'contact_person_full_name': contactPersonNameController.text,
      'contact_person_position': contactPersonPositionController.text,
      'contact_person_phone_number': contactDetailsPhoneController.text,
      'contact_person_email': contactDetailsEmailController.text,
      'bin_of_company': iinController.text,
      'links': [
        organizationLinkController.text,
        addMoreLink1Controller.text,
        addMoreLink2Controller.text,
        addMoreLink3Controller.text,
      ].where((link) => link.isNotEmpty).toList(),
      'description': overviewController.text,
      // 'date_of_birth': _dateController.text,
      // 'email': emailController.text + selectedEmailDomain,
      // 'name': nameController.text,
      // 'surname': surnameController.text,
      // 'father_name': fatherNameController.text,
      // 'gender': selectedGender,
      // 'phone_number': phoneNumberController.text,
      // 'country': selectedCountry,
      // 'city': selectedCity,
    };

    final result = await _apiService.submitEmployerInfo(data, 'your_token_here');
    if (result['message'] == 'success') {
      // Navigate to the next screen or show success message
    } else {
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Фон
      backgroundColor: Colors.white,

      // Адаптивный AppBar с закруглённым нижним краем
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight + MediaQuery.of(context).size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // закругляем только низ
            ),
          ),
          backgroundColor: Colors.black,
          leading: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.0001,
            ),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/backButton.png'),
                radius: MediaQuery.of(context).size.width * 0.16,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),

      // Тело экрана со скроллом
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            const Text(
              "Fill out the form Company",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Поля ввода
            TextField(
              controller: companyNameController,
              decoration: const InputDecoration(labelText: "Company Name"),
            ),
            TextField(
              controller: industryController,
              decoration: const InputDecoration(labelText: "Industry/Sector"),
            ),
            TextField(
              controller: companySizeController,
              decoration:
                  const InputDecoration(labelText: "Company Size (Num of Employee)"),
            ),
            TextField(
              controller: registeredAddressController,
              decoration: const InputDecoration(labelText: "Registered Address"),
            ),
            TextField(
              controller: contactPersonNameController,
              decoration:
                  const InputDecoration(labelText: "Contact Person (Full Name)"),
            ),
            TextField(
              controller: contactPersonPositionController,
              decoration:
                  const InputDecoration(labelText: "Contact Person (Position)"),
            ),
            TextField(
              controller: contactDetailsPhoneController,
              decoration:
                  const InputDecoration(labelText: "Contact Details (Phone)"),
            ),
            TextField(
              controller: contactDetailsEmailController,
              decoration:
                  const InputDecoration(labelText: "Contact Details (Email)"),
            ),
            TextField(
              controller: iinController,
              decoration: const InputDecoration(
                labelText: "Write your IIN (BIN of Company)",
              ),
            ),

            // Блок ссылок
            const SizedBox(height: 10),
            const Text("Overall Links",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: organizationLinkController,
              decoration: const InputDecoration(labelText: "Organization Link"),
            ),
            TextField(
              controller: addMoreLink1Controller,
              decoration: const InputDecoration(labelText: "Add one more links"),
            ),
            TextField(
              controller: addMoreLink2Controller,
              decoration: const InputDecoration(labelText: "Add one more links"),
            ),
            TextField(
              controller: addMoreLink3Controller,
              decoration: const InputDecoration(labelText: "Add one more links"),
            ),

            // Поле Overviews
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const Text(
              "Overviews (main info about Company)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Оборачиваем TextField в Container, чтобы добавить тень и закругления
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white, // фон внутри контейнера
                borderRadius: BorderRadius.circular(20), // закругляем углы
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // цвет тени
                    spreadRadius: 2,  // "расплыв" тени
                    blurRadius: 5,    // "размытие" тени
                    offset: const Offset(0, 3), // сдвиг тени по x,y
                  ),
                ],
              ),
              child: TextField(
                controller: overviewController,
                maxLines: 4, // Можно увеличить при необходимости
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  hintText: "Write Here...",
                  border: InputBorder.none, // убираем стандартную обводку
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Кнопка Next
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.04,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7360DF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Заглушка экрана для Private Person
class PrivatePersonRegistrationScreen extends StatefulWidget {
  @override
  _PrivatePersonRegistrationScreenState createState() =>
      _PrivatePersonRegistrationScreenState();
}

class _PrivatePersonRegistrationScreenState
    extends State<PrivatePersonRegistrationScreen> {
  // Контроллеры для полей ввода
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String selectedGender = "";
  String selectedCountry = "";
  String selectedCity = "";
  String selectedEmailDomain = "";

  final List<String> countries = [
    "Russia",
    "Kazakhstan",
    "Uzbekistan",
    "Kyrgyzstan"
  ];
  final Map<String, List<String>> cities = {
    "Russia": ["Moscow", "Saint Petersburg", "Novosibirsk", "Yekaterinburg"],
    "Kazakhstan": ["Almaty", "Astana", "Shymkent", "Karaganda"],
    "Uzbekistan": ["Tashkent", "Samarkand", "Bukhara", "Andijan"],
    "Kyrgyzstan": ["Bishkek", "Osh", "Jalal-Abad", "Karakol"]
  };
  final List<String> emailDomains = ["@gmail.com", "@mail.ru", "@yahoo.com"];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: countries
            .map((country) => ListTile(
                  title: Text(country, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedCountry = country;
                      selectedCity = "";
                    });
                    Navigator.pop(context);
                    _showCityPicker(country);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showCityPicker(String country) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: cities[country]!
            .map((city) => ListTile(
                  title: Text(city, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showEmailDomainPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        padding: EdgeInsets.all(20),
        children: emailDomains
            .map((domain) => ListTile(
                  title: Text(domain, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedEmailDomain = domain;
                    });
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dateController.text =
          "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
    }
  }

  final ApiService _apiService = ApiService();

  void _onNextPressed() async {
    final data = {
  'employer': 'private',
  'employer_name': nameController.text, // можно переименовать в employer_name
  'employer_surname': surnameController.text, // в employer_surname
  'employer_fathers_name': fatherNameController.text, // в employer_fathers_name
  'sex': selectedGender, // изменить на sex, если нужно
  'date_of_birth': _dateController.text,
  'email': emailController.text + selectedEmailDomain,
  'phone_number': phoneNumberController.text,
  'location': '$selectedCountry, $selectedCity',
};


    final result =
        await _apiService.submitEmployerInfo(data, 'your_token_here');
    if (result['message'] == 'success') {
      // Перейти к следующему экрану или показать сообщение об успехе
    } else {
      // Показать сообщение об ошибке
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    fatherNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            kToolbarHeight + MediaQuery.of(context).size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: Colors.black,
          leading: Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.width * 0.0001),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/backButton.png'),
                radius: MediaQuery.of(context).size.width * 0.16,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Fill out the form",
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: "Surname"),
              ),
              TextField(
                controller: fatherNameController,
                decoration:
                    const InputDecoration(labelText: "Father's name"),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var gender in ["Male", "Female"])
                    GestureDetector(
                      onTap: () =>
                          setState(() => selectedGender = gender),
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width * 0.42,
                        height:
                            MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: selectedGender == gender
                              ? Colors.black
                              : Colors.grey[800],
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          gender,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date of Birth (DD MM YYYY)",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration:
                          const InputDecoration(labelText: "Write email"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: _showEmailDomainPicker,
                  ),
                  Text(selectedEmailDomain,
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                    labelText: "Write phone number"),
              ),
              GestureDetector(
                onTap: _showCountryPicker,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: selectedCountry.isEmpty
                          ? "Where are you from? (click here)"
                          : selectedCountry,
                    ),
                  ),
                ),
              ),
              if (selectedCountry.isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      _showCityPicker(selectedCountry),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: selectedCity.isEmpty
                            ? "Choose your City"
                            : selectedCity,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.3,
                  height:
                      MediaQuery.of(context).size.height * 0.04,
                  child: ElevatedButton(
                    onPressed: () async{
                           _onNextPressed();
                            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewVacancyScreenCompany()),
            );
                    },
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7360DF),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class VacancyContractorScreen extends StatelessWidget {
  const VacancyContractorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем размеры экрана
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar добавлен по вашему примеру
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(size.width * 0.0001),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/backButtonBlack.png',
                    
                    ),
                    
                radius: size.width * 0.1,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        // SingleChildScrollView позволяет прокручивать экран, если места не хватает
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                // Заголовок
                Text(
                  "Your resume is ready!\nWhat's next?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // Иллюстрация (заглушка)
                Image.asset(
              'assets/contractor/cont.png',
              width: size.width * 1.2, // 40% от ширины экрана
              height: size.height * 0.4, // 12% от высоты экрана
            ),
                SizedBox(height: size.height * 0.03),
                // Описание
                Text(
                  "Create a new vacancy or \ncontinue to the homepage.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: size.height * 0.06),
                // Кнопки
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        // TODO: переход на главную страницу
                      },
                      child: Text(
                        "Go to Homepage",
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    //SizedBox(height: size.height * 0.001),
                    Text(
                        "or",
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VacancyContractorScreenCreate()),
                    );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // обнуляем отступы
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9D65C9),
                              Color(0xFF7360DF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.8,
                            minHeight: size.height * 0.06,
                          ),
                          child: Text(
                            "Create Vacancy",
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class VacancyContractorScreenCreate extends StatelessWidget {
  const VacancyContractorScreenCreate({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar с заголовком и кнопкой "назад" на одной строке
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(size.width * 0.0001),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/backButtonBlack.png'),
                radius: size.width * 0.1,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VacancyContractorScreen()),
                );
              },
            ),
          ),
          title: Text(
            "Create a vacancy",
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
      ),
      // Основное тело экрана
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01),
                // Подзаголовок
                Text(
                  "Choose a Category",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // 2×2 сетка из контейнеров с onPressed (onTap)
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: size.height * 0.02,
                  crossAxisSpacing: size.width * 0.04,
                  childAspectRatio: 1, // квадратные элементы
                  children: [
                    // 1-й блок
                    InkWell(
                      onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewVacancyScreenCompany()),
                    );
                        print("Code & Build pressed");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/code.png',
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Code & Build",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 2-й блок
                    InkWell(
                      onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewVacancyScreenPrivatePerson()),
                    );
                        print("Data & Intelligence pressed");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/data.png',
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Data & Intelligence",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 3-й блок
                    InkWell(
                      onTap: () {
                        // Добавьте нужное действие здесь
                        print("Systems & Cloud pressed");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/code.png',
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Systems & Cloud",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 4-й блок
                    InkWell(
                      onTap: () {
                        // Добавьте нужное действие здесь
                        print("Design & Experience pressed");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/data.png',
                              width: size.width * 0.15,
                              height: size.width * 0.15,
                              color: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Design & Experience",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                // Текст внизу
                Column(
                  children: [
                    Text(
                      "Select one category before creating a new",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.black54,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Vacancy",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.black54,
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
    );
  }
}
// new_vacancy_screen_company.dart

// new_vacancy_screen_company.dart
class VacancyData {
  final String name;
  final String position;
  final int experience;
  final int salary;
  final int compensation;
  final String skills;
  final String responsibilities;
  final String deadline; // Дата в формате ISO8601
  final String workConditions;

  VacancyData({
    required this.name,
    required this.position,
    required this.experience,
    required this.salary,
    required this.compensation,
    required this.skills,
    required this.responsibilities,
    required this.deadline,
    required this.workConditions,
  });
}

class NewVacancyScreenCompany extends StatefulWidget {
  const NewVacancyScreenCompany({Key? key}) : super(key: key);

  @override
  State<NewVacancyScreenCompany> createState() => _NewVacancyScreenCompanyState();
}

class _NewVacancyScreenCompanyState extends State<NewVacancyScreenCompany> {
  // Контроллеры для текстовых полей
  final TextEditingController positionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController compensationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController responsibilitiesController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController workConditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Vacancy (Company)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: positionController,
              decoration: const InputDecoration(
                labelText: "Position (e.g. Android, UX/UI Design, ...)",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Experience (years)",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Salary",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: compensationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Compensation",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: skillsController,
              decoration: const InputDecoration(
                labelText: "Skills (comma separated)",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: responsibilitiesController,
              decoration: const InputDecoration(
                labelText: "Responsibilities",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Deadline (YYYY-MM-DD)",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: workConditionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Work Conditions",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Собираем данные вакансии из формы.
                final vacancyData = VacancyData(
                  name: "Your Company Name", // Пример; установите актуальное значение
                  position: positionController.text,
                  experience: int.tryParse(experienceController.text) ?? 0,
                  salary: int.tryParse(salaryController.text) ?? 0,
                  compensation: int.tryParse(compensationController.text) ?? 0,
                  skills: skillsController.text,
                  responsibilities: responsibilitiesController.text,
                  // Преобразуем введённую дату или устанавливаем текущую дату
                  deadline: DateTime.tryParse(deadlineController.text)
                          ?.toIso8601String() ??
                      DateTime.now().toIso8601String(),
                  workConditions: workConditionController.text,
                );
                // Переход на экран деталей вакансии с передачей данных.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailScreen(vacancyData: vacancyData),
                  ),
                );
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}


// Private person vacancy 

class NewVacancyScreenPrivatePerson extends StatefulWidget {
  const NewVacancyScreenPrivatePerson({Key? key}) : super(key: key);

  @override
  State<NewVacancyScreenPrivatePerson> createState() => _NewVacancyScreenPrivatePersonState();
}

class _NewVacancyScreenPrivatePersonState extends State<NewVacancyScreenPrivatePerson> {
  // Для примера – если хотите отмечать "Вашу компанию" радио-кнопкой
  String selectedCompany = ""; 

  // Контроллеры для текстовых полей
  final TextEditingController positionController = TextEditingController();
  final TextEditingController devController = TextEditingController();
  final TextEditingController responsibilitiesController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController deadlinesController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController compensationController = TextEditingController();
  final TextEditingController workConditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // ---------- APP BAR ----------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + size.height * 0.01),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(size.width * 0.0001),
            child: IconButton(
              icon: CircleAvatar(
                backgroundImage: const AssetImage('assets/images/backButtonBlack.png'),
                radius: size.width * 0.1,
              ),
              onPressed: () {
                // Возвращаемся или переходим на другой экран
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VacancyContractorScreenCreate()),
                );
              },
            ),
          ),
          title: Text(
            "New vacancy", // <-- заменили заголовок
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
      ),

      // ---------- BODY ----------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              Text(
                "Vacancy Conditions",
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Радио-кнопка / Ваш текст
              Row(
                children: [
                  Radio(
                    value: "myCompany",
                    groupValue: selectedCompany,
                    onChanged: (value) {
                      setState(() {
                        selectedCompany = value.toString();
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "(Your Name) Company",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),

              // Подзаголовок
              Text(
                "Open Vacancies",
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Поля для ввода
              TextField(
                controller: positionController,
                decoration: InputDecoration(
                  labelText: "Position (e.g. Android, UX/UI Design, ...)",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: devController,
                decoration: InputDecoration(
                  labelText: "Which Dev Are You looking for (e.g Junior, Middle, ...)",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: responsibilitiesController,
                decoration: InputDecoration(
                  labelText: "Responsibilities",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: skillsController,
                decoration: InputDecoration(
                  labelText: "Show the Skills you need",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: deadlinesController,
                decoration: InputDecoration(
                  labelText: "Deadlines",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: salaryController,
                decoration: InputDecoration(
                  labelText: "Salary",
                ),
              ),
              SizedBox(height: size.height * 0.015),

              TextField(
                controller: compensationController,
                decoration: InputDecoration(
                  labelText: "Compensation",
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Подсказки по Compensation
              Text(
                "If he complete the project faster than 2 times",
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "Compensation shouldn’t be less than 40% of the total amount of the Project",
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // Work Condition...
              Text(
                "Work Condition...",
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // Многострочное поле
              TextField(
                controller: workConditionController,
                maxLines: 4, // побольше строк
                decoration: const InputDecoration(
                  hintText: "Write here...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Кнопка Next
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика при нажатии на Next
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7360DF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}


//jobd
// job_detail_screen.dart // Для доступа к классу VacancyData

class JobDetailScreen extends StatelessWidget {
  final VacancyData vacancyData;

  const JobDetailScreen({Key? key, required this.vacancyData}) : super(key: key);

  // Функция для показа модального окна подтверждения публикации.
  void _showConfirmBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Окно становится скроллируемым
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(size.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm the Publication of the Vacancy",
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Отображаем собранные данные вакансии.
                  Text("Position: ${vacancyData.position}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Experience: ${vacancyData.experience} years",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Salary: ${vacancyData.salary}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Compensation: ${vacancyData.compensation}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Skills: ${vacancyData.skills}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Responsibilities: ${vacancyData.responsibilities}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Deadline: ${vacancyData.deadline}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  Text("Work Conditions: ${vacancyData.workConditions}",
                      style: TextStyle(fontSize: size.width * 0.04)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Вызываем API для публикации вакансии и выводим отладочную информацию.
                      final result = await ApiService().submitVacancy(
                        name: vacancyData.name,
                        position: vacancyData.position,
                        experience: vacancyData.experience,
                        salary: vacancyData.salary,
                        compensation: vacancyData.compensation,
                        skills: vacancyData.skills,
                        responsibilities: vacancyData.responsibilities,
                        deadline: vacancyData.deadline,
                        workConditions: vacancyData.workConditions,
                      );

                      // Отладочный вывод результата в консоль.
                      print("API response: $result");

                      if (result.containsKey("error")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result["error"])),
                        );
                      } else {
                        Navigator.pop(context); // Закрываем модальное окно
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Vacancy successfully published")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7360DF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                    ),
                    child: Text(
                      "Confirm & Publish",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Vacancy Details")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showConfirmBottomSheet(context),
          child: const Text("Publish"),
        ),
      ),
    );
  }
}




// class NewsPage extends StatefulWidget {
//   const NewsPage({Key? key}) : super(key: key);

//   @override
//   State<NewsPage> createState() => _NewsPageState();
// }

// class _NewsPageState extends State<NewsPage> {
//   final String apiKey = "f7c3ab80476d41db85279e989b79d901";
//   late Future<List<Article>> _articlesFuture;

//   Future<List<Article>> fetchArticles() async {
//     // Запрос новостей по теме "computer science" с датой с 2023-04-01.
//     final url =
//         "https://newsapi.org/v2/everything?q=freelance&sortBy=popularity&apiKey=$apiKey";
//     final response = await http.get(Uri.parse(url));
//     print("Status code: ${response.statusCode}");
//     print("Response body: ${response.body}");
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       List<Article> articles = [];
//       for (var item in jsonData['articles']) {
//         articles.add(Article.fromJson(item));
//       }
//       return articles;
//     } else {
//       throw Exception("Ошибка при загрузке новостей");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _articlesFuture = fetchArticles();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     // Главная страница новостей с адаптивной прокруткой
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("News"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<Article>>(
//         future: _articlesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Ошибка: ${snapshot.error}"));
//           } else {
//             final articles = snapshot.data!;
//             // Первые 4 новости для горизонтального слайдера
//             final trending =
//                 articles.length >= 4 ? articles.sublist(0, 4) : articles;
//             // Остальные новости для списка
//             final rest = articles.length > 4 ? articles.sublist(4) : <Article>[];
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Заголовок "Trending Now"
//                     Padding(
//                       padding: EdgeInsets.all(size.width * 0.04),
//                       child: Text(
//                         "Trending Now",
//                         style: TextStyle(
//                           fontSize: size.width * 0.06,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     // Горизонтальный слайдер (карусель) с 4 новостями
//                     SizedBox(
//                       height: size.height * 0.3,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: trending.length,
//                         itemBuilder: (context, index) {
//                           final article = trending[index];
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       NewsDetailPage(article: article),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               width: size.width * 0.8,
//                               margin: EdgeInsets.only(
//                                 left: index == 0 ? size.width * 0.04 : size.width * 0.02,
//                                 right: size.width * 0.02,
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     Image.network(
//                                       article.urlToImage ?? "",
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) =>
//                                           Container(
//                                         color: Colors.grey[300],
//                                         child: Icon(Icons.error,
//                                             color: Colors.red, size: size.width * 0.1),
//                                       ),
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             Colors.black.withOpacity(0.6),
//                                             Colors.transparent,
//                                           ],
//                                           begin: Alignment.bottomCenter,
//                                           end: Alignment.topCenter,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: size.width * 0.03,
//                                       left: size.width * 0.03,
//                                       child: Text(
//                                         article.title,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: size.width * 0.045,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: size.height * 0.02),
//                     // Вертикальный список новостей (карточки)
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
//                       child: Column(
//                         children: rest
//                             .map((article) => NewsListCard(article: article))
//                             .toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// /// Модель новости
// class Article {
//   final String title;
//   final String description;
//   final String? urlToImage;
//   final String author;
//   final String publishedAt;
//   final String url;
  
//   Article({
//     required this.title,
//     required this.description,
//     required this.urlToImage,
//     required this.author,
//     required this.publishedAt,
//     required this.url,
//   });
  
//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       title: (json["title"] as String?) ?? "",
//       description: (json["description"] as String?) ?? "",
//       urlToImage: json["urlToImage"] as String?,
//       author: (json["author"] as String?) ?? "Unknown",
//       publishedAt: (json["publishedAt"] as String?) ?? "",
//       url: (json["url"] as String?) ?? "",
//     );
//   }
// }

// /// Карточка новости для списка (нижняя часть страницы)
// class NewsListCard extends StatelessWidget {
//   final Article article;
//   const NewsListCard({Key? key, required this.article}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => NewsDetailPage(article: article)),
//          );
//       },
//       child: Card(
//         elevation: 4,
//         margin: EdgeInsets.only(bottom: size.height * 0.02),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Stack(
//           children: [
//             // Основной белый прямоугольник карточки с внутренними отступами
//             Container(
//               padding: EdgeInsets.only(
//                 left: size.width * 0.30,
//                 top: size.height * 0.02,
//                 right: size.width * 0.04,
//                 bottom: size.height * 0.02,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Заголовок новости
//                   Text(
//                     article.title,
//                     style: TextStyle(
//                       fontSize: size.width * 0.045,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     // maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: size.height * 0.01),
//                   // Краткое описание новости
//                   Text(
//                     article.description,
//                     style: TextStyle(
//                       fontSize: size.width * 0.04,
//                       color: Colors.black87,
//                     ),
//                     // maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: size.height * 0.01),
//                   // Ряд с автором и датой публикации, разделёнными вертикальной линией
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           article.author,
//                           style: TextStyle(
//                             fontSize: size.width * 0.035,
//                             color: Colors.grey,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         width: 1,
//                         height: size.height * 0.03,
//                         color: Colors.grey[300],
//                         margin: EdgeInsets.symmetric(horizontal: size.width * 0.02),
//                       ),
//                       Text(
//                         article.publishedAt.length >= 10
//                             ? article.publishedAt.substring(0, 10)
//                             : article.publishedAt,
//                         style: TextStyle(
//                           fontSize: size.width * 0.035,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Левый квадрат с изображением, немного выступающий из карточки
//             Positioned(
//               top: size.height * 0.02,
//               left: size.width * 0.04,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   article.urlToImage ?? "",
//                   width: size.width * 0.24,
//                   height: size.width * 0.24,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: size.width * 0.24,
//                     height: size.width * 0.24,
//                     color: Colors.grey[300],
//                     child: Icon(Icons.error, color: Colors.red, size: size.width * 0.1),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Страница с подробностями новости
// class NewsDetailPage extends StatelessWidget {
//   final Article article;
//   const NewsDetailPage({Key? key, required this.article}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       // AppBar с адаптивным размером, закруглением нижней части и кнопкой "назад"
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight + size.height * 0.01),
//         child: AppBar(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(20),
//             ),
//           ),
//           backgroundColor: Colors.black,
//           leading: Padding(
//             padding: EdgeInsets.all(size.width * 0.01),
//             child: IconButton(
//               icon: CircleAvatar(
//                 backgroundImage: const AssetImage('assets/images/backButton.png'),
//                 radius: size.width * 0.16,
//               ),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Верхнее изображение новости
//             article.urlToImage != null
//                 ? Image.network(
//                     article.urlToImage!,
//                     width: double.infinity,
//                     height: size.height * 0.3,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: size.height * 0.3,
//                       color: Colors.grey[300],
//                       child: Icon(Icons.error, color: Colors.red, size: size.width * 0.2),
//                     ),
//                   )
//                 : Container(
//                     height: size.height * 0.3,
//                     color: Colors.grey[300],
//                   ),
//             Padding(
//               padding: EdgeInsets.all(size.width * 0.04),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Заголовок новости
//                   Text(
//                     article.title,
//                     style: TextStyle(
//                       fontSize: size.width * 0.06,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.01),
//                   // Ряд с автором и датой
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         article.author,
//                         style: TextStyle(
//                           fontSize: size.width * 0.045,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         article.publishedAt.length >= 10
//                             ? article.publishedAt.substring(0, 10)
//                             : article.publishedAt,
//                         style: TextStyle(
//                           fontSize: size.width * 0.045,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   // Описание новости
//                   Text(
//                     article.description,
//                     style: TextStyle(fontSize: size.width * 0.045),
//                   ),
                  
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



