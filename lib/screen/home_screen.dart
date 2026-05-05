import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.isAuthenticated,
    required this.daysUntilNaadam,
    required this.onBiometricScan,
    required this.onTicketTypeTap,
    required this.onCreateGroupTap,
    required this.onLogoutTap,
  });

  final bool isAuthenticated;
  final int daysUntilNaadam;
  final Future<void> Function() onBiometricScan;
  final VoidCallback onTicketTypeTap;
  final VoidCallback onCreateGroupTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        children: [
          _HeaderCard(daysUntilNaadam: daysUntilNaadam),
          const SizedBox(height: 14),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child:
                  isAuthenticated
                      ? _AuthenticatedPanel(
                        key: const ValueKey('auth-panel'),
                        onTicketTypeTap: onTicketTypeTap,
                        onCreateGroupTap: onCreateGroupTap,
                        onLogoutTap: onLogoutTap,
                      )
                      : _LockedPanel(
                        key: const ValueKey('locked-panel'),
                        onBiometricScan: onBiometricScan,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.daysUntilNaadam});

  final int daysUntilNaadam;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF204E43), Color(0xFF356D58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33204E43),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Naadam Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your pass, ticket settings, and group management.',
                  style: TextStyle(
                    color: Color(0xFFE2F1EC),
                    fontFamily: 'RobotoMono',
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x55FFFFFF)),
            ),
            child: Center(
              child: Text(
                '$daysUntilNaadam\ndays',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedPanel extends StatelessWidget {
  const _LockedPanel({super.key, required this.onBiometricScan});

  final Future<void> Function() onBiometricScan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDCD9D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFFF4EEE2), Color(0xFFF9F6ED)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.face_3, size: 76, color: Color(0xFF204E43)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Biometric scan is required to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF20352F),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Face ID / fingerprint check unlocks ticket and group actions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 12,
              color: Color(0xFF5D6A66),
              height: 1.4,
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: const Color(0xFF204E43),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onBiometricScan,
            icon: const Icon(Icons.verified_user),
            label: const Text(
              'Biometric Scan',
              style: TextStyle(
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthenticatedPanel extends StatelessWidget {
  const _AuthenticatedPanel({
    super.key,
    required this.onTicketTypeTap,
    required this.onCreateGroupTap,
    required this.onLogoutTap,
  });

  final VoidCallback onTicketTypeTap;
  final VoidCallback onCreateGroupTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDCD9D0)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PassCard(),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    title: 'Ticket',
                    value: 'VIP',
                    icon: Icons.workspace_premium_outlined,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _MiniStatCard(
                    title: 'Group',
                    value: '3 Members',
                    icon: Icons.groups_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF20352F),
              ),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              title: 'Ticket Type',
              subtitle: 'Switch between Standard and VIP access.',
              icon: Icons.confirmation_num_outlined,
              onTap: onTicketTypeTap,
            ),
            const SizedBox(height: 10),
            _ActionTile(
              title: 'Create Group',
              subtitle: 'Invite friends and sync plans for Naadam days.',
              icon: Icons.group_add_outlined,
              onTap: onCreateGroupTap,
            ),
            const SizedBox(height: 16),
            const Text(
              'Today Plan',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF20352F),
              ),
            ),
            const SizedBox(height: 8),
            const _PlanRow(
              time: '09:00',
              title: 'Opening Ceremony',
              place: 'Main Arena',
            ),
            const _PlanRow(
              time: '11:30',
              title: 'Food Break',
              place: 'Food Court A',
            ),
            const _PlanRow(
              time: '14:30',
              title: 'Wrestling Round 2',
              place: 'Central Stadium',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onLogoutTap,
                icon: const Icon(Icons.lock_outline),
                label: const Text(
                  'Lock Session',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontWeight: FontWeight.w700,
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

class _PassCard extends StatelessWidget {
  const _PassCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF233B66), Color(0xFF2D5A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: Color(0xFFE9F2FF), size: 18),
              SizedBox(width: 6),
              Text(
                'EVENT PASS',
                style: TextStyle(
                  color: Color(0xFFE9F2FF),
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'B. Bat-Erdene',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
              fontSize: 21,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'NAADAM 2026 • Access Level: VIP',
            style: TextStyle(
              color: Color(0xFFCFE3FF),
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDEE5E2)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE1ECE8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF204E43)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 10,
                    color: Color(0xFF67706D),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
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

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF5F7F6),
          border: Border.all(color: const Color(0xFFDEE5E2)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFDFECE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF204E43)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 11,
                      color: Color(0xFF67706D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF204E43)),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({
    required this.time,
    required this.title,
    required this.place,
  });

  final String time;
  final String title;
  final String place;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0EC),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: Color(0xFF2E4E43),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9F8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE3E7E2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    place,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 10,
                      color: Color(0xFF66726D),
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
