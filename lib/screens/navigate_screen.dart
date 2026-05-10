import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class NavigateScreen extends ConsumerStatefulWidget {
  final bool isGuest;
  
  const NavigateScreen({super.key, this.isGuest = false});

  @override
  ConsumerState<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends ConsumerState<NavigateScreen> {
  UnityWidgetController? _unityWidgetController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<MapEntry<String, String>> _filteredResults = [];
  bool _isSearchFocused = false;
  bool _hasCameraPermission = false;
  bool _isCheckingPermission = true;

  final Map<String, List<String>> _destinations = {
    // ... (rest of destinations)

    // --- F Keys ---
    "F2": ["Staff Members Lounge - Mathematics Department"],
    "F3": ["Dr. Mohamed Abdel Azim Saud", "Dr. Diyaa Ibrahim Nasr"],
    "F5": ["Dr. Fatima Gadallah Abu El-Magd", "Dr. Hoda El-Sherbiny Ibrahim", "Dr. Ghada Nour El-Din Ahmed", "Dr. Nashwa Mohamed Abdel Ghaffar"],
    "F6": ["Dr. Mohamed Ahmed Mohamed Hassan", "Dr. Walid Sayed Abdel Zaher", "Dr. Tarek Nassar El-Din", "Dr. Hamed El-Saida"],
    "F7": ["Dr. Adel Taha Abdel Sammad", "Dr. Mohamed Fakhry El-Din", "Dr. Wael Zakaria Abdullah"],
    "F8": ["Dr. Ahmed Abdel Jawad El-Sonbati", "Dr. Sayed Abdel Fattah Zaki", "Dr. Ahmed Ezzat Amin", "Dr. Mohamed Ghaleeb"],
    "F9": ["Dr. Intisar El-Shabaki", "Seminar Hall"],
    "F10": ["Dr. Jehan Mohamed Masoud", "Dr. Azza Abdel Rahman Taha", "Dr. Huwaida Mohamed Said", "Dr. Suhair Mohamed Said Mahmoud", "Dr. Dawlat Abdel Aziz Mohamed"],
    "F15": ["Dr. Nadia Farid Ramadan", "Dr. Aliyah Suleiman Marzouq", "Dr. Nazal Bakit", "Dr. Ali Sweilem", "Dr. Nawal Naguib"],
    "F21": ["Hammad Auditorium"],
    "F22": ["Dr. Mohamed Hashem", "Dr. Mona Farid Abdel Rahman"],
    "F23": ["Lab (228 B)"],
    "F24": ["Lab (228 A)"],
    "F27": ["Dr. Mohamed Khaled Ibrahim", "Dr. Mohamed Abdel Montaser Abu Zaid", "Dr. Wael Samir Mahmoud", "Dr. Ahmed Mohamed Hosni", "Dr. Peter George Fouad Aziz"],
    "F28": ["Dr. Setaita Amin Salem", "Dr. Suzan Abdel Aziz Ahmed", "Dr. Hala El-Tantawy", "Dr. Ahmed Barakat", "Dr. Adel El-Halawy", "Dr. Mohamed Ali"],
    "F29": ["Dr. Khairy Tawfik Khalil", "Dr. Mohamed Ibrahim Arafa"],
    "F30": ["Microbiology Department", "Dr. Hala Abu Said"],
    "F31": ["Dr. Ali Mohamed Ali Saeed", "Dr. Einas Hamed El-Shorbagy", "Dr. Khaled Zakaria", "Dr. Ahmed Raafat", "Dr. Fekry Ali El-Dawy", "Dr. Adel Hassan", "Dr. Omar El-Farouk", "Dr. Sahar Talaat", "Applied Microbiology Program Coordinator"],
    "F32": ["Botany Department Lab"],
    "F33": ["Noah Auditorium"],
    "F34": ["Lab (225 B)"],
    "F35": ["Dr. Adel Fahmy Hamed", "Dr. Ishaq Fahmy Ishaq", "Dr. Noha Sayed Farag", "Dr. Mohamed Ibrahim Ghonima", "Dr. Amr Hassan Nassar", "Dr. Mohamed Mohamed Faheem"],
    "F36": ["Lab (225 A)"],
    "F39": ["Building Materials Technology Research Lab", "Dr. Saleh Abu El-Ainine"],
    "F40": ["Dr. Hesham Samir Abdel Samad", "Dr. Afaf Ayman Hassan"],
    "F41": ["Dr. Suzy Alphonse Selim", "Dr. Safaa Mohamed Awad", "Dr. Mohamed Abdel Khalek", "Dr. Dina Jamal Sayed"],
    "F42": ["Dr. Samia Masihi", "Dr. Issa Heikal", "Dr. Wajeeha Hamed Mahmoud", "Dr. Fatima Mohamed El-Zawawy", "Dr. Nabila Ishaq El-Hendi", "Dr. Sami Tobia", "Dr. Ibtisam Ahmed Saad"],
    "F43": ["Inorganic Chemistry Lab"],

    // --- S Keys ---
    "S11": ["Abdel Salam Lab"],
    "S12": ["Mahmoud Khairat Lab"],
    "S13": ["Dr. Nehad Hashim", "Dr. Mustafa Mohamed Zakaria", "Dr. Hatem Mohamed Bahig"],
    "S14": ["Bahaa Lab"],
    "S16": ["Dr. Wafaa Hassan", "Dr. Ayat Taha El-Sharkawy", "Dr. Maha Mustafa Hassan"],
    "S17": ["Dr. Faten", "Dr. Wiam Waheed", "Dr. Yasmin Hosni", "Dr. Marwa El-Najjar", "Dr. Ragaa Mahmoud El-Deeb", "Dr. Shadia Hassan Mohamed", "Dr. Hoda Jamal El-Din Hegazy"],
    "S18": ["Dr. Reda Hassan Ali", "Dr. Samia Mohamed Fawzy", "Dr. Manar Refaat Suleiman", "Dr. Amal Mahmoud", "Dr. William Rizkallah", "Dr. Fawzy Ibrahim Amer", "Dr. Ehab Kamal", "Dr. Mohamed Ibrahim Suleiman", "Dr. Mounir Ali Ez El-Din El-Ganzoury", "Dr. Abdullah Mohamed Ibrahim"],
    "S19": ["Dr. Hamza El-Shabaka", "Dr. Ali Abdel Al-Aal", "Dr. Sherif Helmy El-Alfy", "Dr. Ahmed Mohamed Hamdy Najm", "Dr. Amin Abdel Baqi Ashour", "Dr. Mohamed Ibrahim Suleiman"],
    "S23": ["Dr. Khairiya Abdel Ghani", "Dr. Fawqiya Mohamed El-Beih", "Dr. Saadiya Mohamed Hussein", "Dr. Al-Zahraa Karam El-Din", "Dr. Najwa Ahmed Abdullah", "Dr. Arwa Hassan Suleiman", "Dr. Shaimaa Khairy Mohamed Amer", "Dr. Samar Samir Mohamed", "Dr. Youssef Abdel Ghani", "Dr. Adel Kamel Madbouly", "Dr. Hassan Mahmoud Gebril", "Dr. Naziha Mohamed Hussein", "Dr. Sherif Mohamed Zaki", "Dr. Samah Abdullah", "Head of Botany Department Council (Dr. Hoda Abu Mansour)"],
    "S25": ["Dr. Abdel Salam Mohamed Shaaban", "Dr. Ahmed Salem El-Ghabashi", "Dr. Maher Mohamed Shehata", "Dr. Hossam El-Din Zaki Hassan", "Dr. Abdullah Antar Saber"],
    "S26": ["Dr. Hala Mohamed Abu Shadi", "Dr. Hebatullah Ibrahim", "Dr. Yusriya Mohamed Hassan", "Dr. Sahar Ahmed Shoman", "Dr. Nora Abdel Salam"],
    "S27": ["Dr. Abdel Salam Mohamed Shaaban", "Students Union", "Lab"],
    "S28": ["Dr. Mohamed Sayed Tantawy", "Dr. Zainab Abdel Samie Alwani", "Dr. Mohamed Mahmoud Moawad", "Dr. Mohamed Abdel Fattah Abdel Tawab", "Dr. Salma Said Abdel Ghani", "Dr. Maryam Ibrahim Hussein", "Dr. Nermin Kamal Hosni"],
    "S31": ["Botany Department Secretariat", "Dr. Hyam Abdel Nabi Dabbour", "Dr. Rasha Mohsen Mohamed", "Dr. Nevein Ahmed Ibrahim", "Dr. Dalia Ali Mahmoud", "Dr. Dina Hatem Mohamed", "Dr. Noha Mohamed Abdel Hamid", "Dr. Mohamed Gad"],
    "S32": ["Dr. Wagih El-Shaarawy", "Dr. Hanaa Shabara", "Dr. Marwa Kamal El-Din", "Dr. Nermin Adel", "Dr. Mohamed Faraj"],
    "S33": ["Secretariat (Public)"],
    "S34": ["Laboratory for Preparation of Fungi", "Dr. Youssef Abdel Ghani"],
    "S36": ["Dr. Mohamed Ramadan Abu Shady Lab (Bacterial Preparation Lab)"],
    "S37": ["Dr. Ahmed Hashem Mohamed Abdel Latif", "Dr. Ashraf Mohamed Youssef"],
    "S38": ["Mycology Lab"],
    "S39": ["Archegonates Lab"],
    "S40": ["Medicinal Plants Lab", "Dr. Mohamed Hassib Lab"],
    "S41": ["Dr. Ahmed Hussein"],
    "S42": ["Dr. Ahmed Abdel Rahman El-Awamri", "Dr. Mahmoud Samy Refaie", "Dr. Hesham Mohamed Abdel Fattah"],
    "S43": ["Ali Mohamed Ali Abdel Aal Hall"],
    "S46": ["Dr. Ahmed Hashem"],
    "S47": ["Third Year Physical Lab"],
    "S48": ["Dr. Mohamed Youssef El-Kadi", "Dr. Galal Hosni Sayed", "Dr. Kiriakis Akram Anwar"],
    "S49": ["Dr. Samh Ahmed Rezq", "Dr. Ibrahim Badr"],
    "S50": ["Dr. Farouk Fahmy", "Dr. Nawal Farahat", "Dr. Magdi Hamdan", "Dr. Amira El-Hagg"],
    "S51": ["Organic Chemistry Lab"],

    // --- T Keys ---
    "T2": ["Dr. Adham Ali Abdel Rahman", "Dr. Samia Ayyad", "Dr. Fawqiya Ibrahim Ali", "Dr. Rawda Mohamed Azmy", "Dr. Rabia Abdel Wahab Mahmoud Enani", "Dr. Iman Issa Fahmy Ahmed"],
    "T3": ["Dr. Fadia Abu Jabal", "Dr. Ola Helmy Zayan", "Dr. Rawda Mohamed Abdel Hamid", "Dr. Hayam El-Hamouly", "Dr. Rabab Fathi Mohamed Swabi", "Dr. Radwa Jihad Mohamed Attia", "Dr. Laila El-Sherif", "Dr. Hoda Mohamed Abdel Fattah"],
    "T4": ["Dr. Abdel Raouf Eid Mohamed Qandil", "Dr. Saber Mohamed Rizq", "Dr. Samira Nader El-Shili", "Dr. Helmy Abdel Aziz Ali Radwan"],
    "T5": ["Dr. Nashat Farid Mohamed Fathy", "Dr. Islah Mahmoud Youssef", "Dr. Hany Abdel Ghaffar Abdel Ati"],
    "T6": ["Dr. Saleh Mohamed Hassan", "Dr. Mohamed Abdel Hamid Mohamed Halawa", "Dr. Mohamed Mohamed Khalil Rashid", "Dr. Samir Sayed Mahmoud"],
    "T7": ["Dr. Ahmed Mustafa Kamal Mahmoud", "Dr. Manar El-Badry", "Dr. Tabarak Ibrahim", "Dr. Mohamed Gharib Mahmoud", "Dr. Mahmoud Amin Mahmoud Ahmed"],
    "T8": ["Dr. Nahed Abd El-Salam Mukhlis", "Dr. Bothaina Abdel Aziz Saied", "Dr. Amal Talaat Mohamed", "Dr. Neamat El-Sayed Hassanin"],
    "T9": ["Dr. Ibrahim Fahmy Ibrahim", "Dr. Fayez Latif Ibrahim", "Dr. Mahmoud Mohamed Mohamed El-Shafei"],
    "T10": ["Dr. Elham Mohamed Mahmoud Ismail", "Dr. Shadia Shehata Suleiman Abdel Wahed", "Dr. Iman Mohamed Zaki Ali", "Dr. Sarah Mohamed Tawfiq", "Dr. Hany Abdel Moneim El-Sharqawy"],
    "T11": ["Dr. Mervat Ibrahim Mikhail Hall", "Section 8 (Hall 8)"],
    "T12": ["Section 424 A", "Dr. Ahmed Hassan Kashef Hall"]
  };

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasCameraPermission = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredResults = [];
      });
      return;
    }

    final List<MapEntry<String, String>> results = [];
    _destinations.forEach((id, names) {
      for (var name in names) {
        if (name.toLowerCase().contains(query.toLowerCase())) {
          results.add(MapEntry(id, name));
        }
      }
    });

    setState(() {
      _filteredResults = results;
    });
  }

  void _selectDestination(String id, String name) {
    _searchController.text = name;
    _searchFocusNode.unfocus();
    setState(() {
      _filteredResults = [];
    });
    
    // Send to Unity
    _unityWidgetController?.postMessage('FlutterManager', 'SetDestination', id.toLowerCase());

    debugPrint('Destination selected: $name ($id)');
  }

  void onUnityCreated(UnityWidgetController controller) async {
    _unityWidgetController = controller;

    await Future.delayed(const Duration(seconds: 1));

    _unityWidgetController?.resume();
  }
  void onUnityMessage(message) {
    debugPrint('Received message from unity: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      debugPrint('Received scene loaded from unity: ${scene.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            // Unity View
            if (_isCheckingPermission)
              const Center(child: CircularProgressIndicator(color: Colors.blue))
            else if (!_hasCameraPermission)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.white54, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Camera permission is required for AR',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _requestCameraPermission,
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              )
            else
              UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                useAndroidViewSurface: false,
              ),



            
            // Premium Header Overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                            onPressed: () {
                              if (widget.isGuest) {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/welcome');
                                }
                              } else {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/home');
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Indoor Navigation',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: _onSearchChanged,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search here',
                              hintStyle: const TextStyle(color: Colors.black54),
                              prefixIcon: const Icon(Icons.search, color: Colors.black54),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              suffixIcon: _searchController.text.isNotEmpty 
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.black54),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  )
                                : null,
                            ),
                          ),
                        ),

                        // Dropdown Results
                        if (_isSearchFocused && _filteredResults.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            constraints: const BoxConstraints(maxHeight: 300),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _filteredResults.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                              itemBuilder: (context, index) {
                                final result = _filteredResults[index];
                                return ListTile(
                                  title: Text(
                                    result.value,
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    result.key,
                                    style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () => _selectDestination(result.key, result.value),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Overlay (Optional UI elements)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _UnityActionButton(
                      icon: Icons.my_location,
                      label: 'Recenter',
                      onTap: () {
                        _unityWidgetController?.postMessage('Player', 'RecenterPlayer', '');
                      },
                    ),
                    _UnityActionButton(
                      icon: Icons.layers,
                      label: 'Floors',
                      onTap: () {
                        _unityWidgetController?.postMessage('UIManager', 'ToggleFloorSelection', '');
                      },
                    ),
                    _UnityActionButton(
                      icon: Icons.search,
                      label: 'Search',
                      onTap: () {
                        // Handle search
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnityActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UnityActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
