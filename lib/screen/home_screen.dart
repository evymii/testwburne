import 'package:flutter/material.dart';

import '../theme/my_colors.dart';

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
          colors: [MyColors.surface, MyColors.surfaceMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: MyColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: MyColors.borderNeutral),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Наадам нэвтрэх',
                  style: TextStyle(
                    color: MyColors.textPrimary,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    shadows: [
                      Shadow(
                        color: MyColors.primaryBlue,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Тасалбар, тохиргоо, бүлгийн удирдлага.',
                  style: TextStyle(
                    color: MyColors.textSecondary,
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
              color: MyColors.blueSoft,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: MyColors.primaryBlue),
            ),
            child: Center(
              child: Text(
                '$daysUntilNaadam\nхоног',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.textPrimary,
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
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: MyColors.borderNeutral),
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
              child: Icon(Icons.face_3, size: 76, color: MyColors.primaryBlue),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Үргэлжлүүлэхийн тулд баталгаажна уу.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: MyColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Face ID эсвэл хурууны хээ шалгаад нээнэ.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'RobotoMono',
              fontSize: 12,
              color: MyColors.textSecondary,
              height: 1.4,
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: MyColors.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: onBiometricScan,
            icon: const Icon(Icons.verified_user),
            label: const Text(
              'Биометр шалгах',
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
        color: MyColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: MyColors.borderNeutral),
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
                    title: 'Тасалбар',
                    value: 'VIP',
                    icon: Icons.workspace_premium_outlined,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _MiniStatCard(
                    title: 'Бүлэг',
                    value: '3 гишүүн',
                    icon: Icons.groups_2_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Шуурхай үйлдэл',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: MyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              title: 'Тасалбарын төрөл',
              subtitle: 'Энгийн эсвэл VIP сонгох',
              icon: Icons.confirmation_num_outlined,
              onTap: onTicketTypeTap,
            ),
            const SizedBox(height: 10),
            _ActionTile(
              title: 'Бүлэг үүсгэх',
              subtitle: 'Найзуудаа уриад төлөвлөгөөгөө нэгтгэх',
              icon: Icons.group_add_outlined,
              onTap: onCreateGroupTap,
            ),
            const SizedBox(height: 16),
            const Text(
              'Өнөөдрийн төлөвлөгөө',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: MyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const _PlanRow(
              time: '09:00',
              title: 'Нээлтийн ёслол',
              place: 'Төв талбай',
            ),
            const _PlanRow(
              time: '11:30',
              title: 'Хоолны завсарлага',
              place: 'Хоолны хэсэг A',
            ),
            const _PlanRow(
              time: '14:30',
              title: 'Бөхийн 2-р даваа',
              place: 'Төв цэнгэлдэх',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onLogoutTap,
                icon: const Icon(Icons.lock_outline, color: MyColors.alertRed),
                label: const Text(
                  'Сешн түгжих',
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
        color: MyColors.blueSoft,
        border: Border.all(color: MyColors.primaryBlue),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: MyColors.primaryBlue, size: 18),
              SizedBox(width: 6),
              Text(
                'АРГА ХЭМЖЭЭНИЙ ЭРХ',
                style: TextStyle(
                  color: MyColors.primaryBlue,
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
              color: MyColors.textPrimary,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
              fontSize: 21,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'НААДАМ 2026 • Түвшин: VIP',
            style: TextStyle(
              color: MyColors.textSecondary,
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
        color: MyColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.borderNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: MyColors.blueSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: MyColors.primaryBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 10,
                    color: MyColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
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
          color: MyColors.surfaceMuted,
            border: Border.all(color: MyColors.borderNeutral),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MyColors.blueSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: MyColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: MyColors.primaryBlue,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 11,
                      color: MyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: MyColors.primaryBlue),
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
              color: MyColors.greenSoft,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              time,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: MyColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                color: MyColors.surfaceMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.borderNeutral),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    place,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 10,
                      color: MyColors.textSecondary,
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
