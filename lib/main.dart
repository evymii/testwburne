import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'theme/my_colors.dart';
import 'screen/home_screen.dart';
import 'screen/map_screen.dart';
import 'screen/program_screen.dart';

void main() {
  runApp(const NaadamApp());
}

class NaadamApp extends StatelessWidget {
  const NaadamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Наадам хөтөч',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColors.primaryBlue,
          primary: MyColors.primaryBlue,
          surface: MyColors.surface,
          error: MyColors.alertRed,
        ),
        scaffoldBackgroundColor: MyColors.baseBackground,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: MyColors.surface,
          indicatorColor: MyColors.blueSoft,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontFamily: 'Raleway',
              color:
                  states.contains(WidgetState.selected)
                      ? MyColors.textPrimary
                      : MyColors.textSecondary,
              fontWeight:
                  states.contains(WidgetState.selected)
                      ? FontWeight.w800
                      : FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  static const bool _previewAuthenticatedHome = true;
  int _currentTab = _previewAuthenticatedHome ? 0 : 1;
  bool _isAuthenticated = _previewAuthenticatedHome;

  int get _daysUntilNaadam {
    final now = DateTime.now();
    var target = DateTime(now.year, 7, 11);
    if (now.isAfter(target)) {
      target = DateTime(now.year + 1, 7, 11);
    }
    final startOfToday = DateTime(now.year, now.month, now.day);
    return target.difference(startOfToday).inDays;
  }

  Future<void> _scanBiometric() async {
    bool didAuthenticate = false;
    try {
      final isSupported = await _localAuthentication.isDeviceSupported();
      if (!isSupported) {
        _showSnack('Энэ төхөөрөмж биометр дэмжихгүй байна.');
        return;
      }

      didAuthenticate = await _localAuthentication.authenticate(
        localizedReason: 'Аппын боломжийг нээхийн тулд баталгаажуулна уу.',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      _showSnack('Биометр шалгалт амжилтгүй боллоо.');
      return;
    }

    if (!mounted) {
      return;
    }

    if (didAuthenticate) {
      setState(() {
        _isAuthenticated = true;
      });
      _showSnack('Баталгаажлаа.');
    } else {
      _showSnack('Цуцаллаа.');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        backgroundColor: MyColors.surface,
        content: Text(
          message,
          style: const TextStyle(color: MyColors.textPrimary),
        ),
      ),
    );
  }

  void _requireAuth(String message) {
    if (_isAuthenticated) {
      return;
    }
    setState(() {
      _currentTab = 0;
    });
    _showSnack(message);
  }

  void _showTicketTypeDialog() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Тасалбарын төрөл',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Танд тохирох төрлөө сонгоно уу.',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                    color: Color(0xFF66726D),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.confirmation_num_outlined),
                  title: const Text('Энгийн'),
                  subtitle: const Text('Ердийн суудал'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('VIP'),
                  subtitle: const Text('Тусгай суудал, нэмэлт үйлчилгээ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Бүлэг үүсгэх'),
          content: const Text(
            'Найзуудаа уриад тасалбараа хамт удирдаарай.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  void _showSpotDetail(VenueSpot spot) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(spot.name),
          content: Text('${spot.kind.label}\n${spot.note}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  void _showProgramDetail(ProgramItem item) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: Text('${item.time}\n${item.location}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        isAuthenticated: _isAuthenticated,
        daysUntilNaadam: _daysUntilNaadam,
        onBiometricScan: _scanBiometric,
        onTicketTypeTap: _showTicketTypeDialog,
        onCreateGroupTap: _showCreateGroupDialog,
        onLogoutTap: () {
          setState(() {
            _isAuthenticated = false;
            _currentTab = 0;
          });
        },
      ),
      MapScreen(
        isAuthenticated: _isAuthenticated,
        onRequireAuth: _requireAuth,
        onSpotTap: _showSpotDetail,
      ),
      ProgramScreen(
        isAuthenticated: _isAuthenticated,
        onRequireAuth: _requireAuth,
        onProgramTap: _showProgramDetail,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _currentTab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.fingerprint), label: 'Нэвтрэх'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Газрын зураг'),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            label: 'Хөтөлбөр',
          ),
        ],
      ),
    );
  }
}
