import 'dart:math' as math;

import 'package:flutter/material.dart';

enum VenueKind {
  toilet,
  food,
  activity;

  String get label {
    switch (this) {
      case VenueKind.toilet:
        return 'Toilet';
      case VenueKind.food:
        return 'Food';
      case VenueKind.activity:
        return 'Activity';
    }
  }

  String get shortLabel {
    switch (this) {
      case VenueKind.toilet:
        return '00';
      case VenueKind.food:
        return 'FOOD';
      case VenueKind.activity:
        return 'ACT';
    }
  }

  IconData get icon {
    switch (this) {
      case VenueKind.toilet:
        return Icons.wc;
      case VenueKind.food:
        return Icons.restaurant;
      case VenueKind.activity:
        return Icons.celebration;
    }
  }

  Color get color {
    switch (this) {
      case VenueKind.toilet:
        return const Color(0xFF4D8CCF);
      case VenueKind.food:
        return const Color(0xFFBC6C25);
      case VenueKind.activity:
        return const Color(0xFF2D8A62);
    }
  }
}

class VenueSpot {
  const VenueSpot({
    required this.name,
    required this.kind,
    required this.x,
    required this.y,
    this.note = '',
  });

  final String name;
  final VenueKind kind;
  final double x;
  final double y;
  final String note;
}

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.isAuthenticated,
    required this.onRequireAuth,
    required this.onSpotTap,
  });

  final bool isAuthenticated;
  final void Function(String message) onRequireAuth;
  final void Function(VenueSpot spot) onSpotTap;

  static const List<VenueSpot> _spots = [
    VenueSpot(
      name: 'North Gate Toilet',
      kind: VenueKind.toilet,
      x: 0.18,
      y: 0.18,
      note: 'Near gate A entrance',
    ),
    VenueSpot(
      name: 'East Side Toilet',
      kind: VenueKind.toilet,
      x: 0.82,
      y: 0.46,
      note: 'Behind east tribune',
    ),
    VenueSpot(
      name: 'Food Court A',
      kind: VenueKind.food,
      x: 0.28,
      y: 0.70,
      note: 'Main quick meal area',
    ),
    VenueSpot(
      name: 'Food Street B',
      kind: VenueKind.food,
      x: 0.64,
      y: 0.72,
      note: 'Traditional dishes',
    ),
    VenueSpot(
      name: 'Kids Activity Zone',
      kind: VenueKind.activity,
      x: 0.52,
      y: 0.34,
      note: 'Family friendly games',
    ),
    VenueSpot(
      name: 'Cultural Stage',
      kind: VenueKind.activity,
      x: 0.40,
      y: 0.50,
      note: 'Dance and music program',
    ),
  ];

  void _handleSpotTap(VenueSpot spot) {
    if (!isAuthenticated) {
      onRequireAuth('Please authenticate first to view location details.');
      return;
    }
    onSpotTap(spot);
  }

  void _handleKindTap(VenueKind kind) {
    final spot = _spots.firstWhere((item) => item.kind == kind);
    _handleSpotTap(spot);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        children: [
          _MapHeader(isAuthenticated: isAuthenticated),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFBF8EF), Color(0xFFF3F8F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0xFFD9DCCE)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 620) {
                    return _WideMapLayout(
                      spots: _spots,
                      onKindTap: _handleKindTap,
                      onSpotTap: _handleSpotTap,
                    );
                  }
                  return _MobileMapLayout(
                    spots: _spots,
                    onKindTap: _handleKindTap,
                    onSpotTap: _handleSpotTap,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tuv Tsengeldekh Hureelen',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF22332D),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Tap map points to open venue details.',
                style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                  color: Color(0xFF5E6B65),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                isAuthenticated
                    ? const Color(0xFFDDF3E7)
                    : const Color(0xFFFCE8E8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color:
                  isAuthenticated
                      ? const Color(0xFF8CC8A8)
                      : const Color(0xFFE8A1A1),
            ),
          ),
          child: Text(
            isAuthenticated ? 'Unlocked' : 'Locked',
            style: TextStyle(
              color:
                  isAuthenticated
                      ? const Color(0xFF1E7A51)
                      : const Color(0xFF9A3E3E),
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileMapLayout extends StatelessWidget {
  const _MobileMapLayout({
    required this.spots,
    required this.onKindTap,
    required this.onSpotTap,
  });

  final List<VenueSpot> spots;
  final void Function(VenueKind kind) onKindTap;
  final void Function(VenueSpot spot) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _LegendRow(onKindTap: onKindTap),
          const SizedBox(height: 10),
          Expanded(child: _VenueMapCanvas(spots: spots, onSpotTap: onSpotTap)),
          const SizedBox(height: 10),
          _BottomSpotStrip(spots: spots, onSpotTap: onSpotTap),
        ],
      ),
    );
  }
}

class _WideMapLayout extends StatelessWidget {
  const _WideMapLayout({
    required this.spots,
    required this.onKindTap,
    required this.onSpotTap,
  });

  final List<VenueSpot> spots;
  final void Function(VenueKind kind) onKindTap;
  final void Function(VenueSpot spot) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_LegendColumn(onKindTap: onKindTap)],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: _VenueMapCanvas(spots: spots, onSpotTap: onSpotTap),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: _SpotListPanel(spots: spots, onSpotTap: onSpotTap),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.onKindTap});

  final void Function(VenueKind kind) onKindTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: VenueKind.values
          .map(
            (kind) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _LegendButton(
                  kind: kind,
                  vertical: false,
                  onTap: () => onKindTap(kind),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _LegendColumn extends StatelessWidget {
  const _LegendColumn({required this.onKindTap});

  final void Function(VenueKind kind) onKindTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: VenueKind.values
          .map(
            (kind) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _LegendButton(
                kind: kind,
                vertical: true,
                onTap: () => onKindTap(kind),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _LegendButton extends StatelessWidget {
  const _LegendButton({
    required this.kind,
    required this.vertical,
    required this.onTap,
  });

  final VenueKind kind;
  final bool vertical;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: vertical ? 76 : 52,
      width: vertical ? 86 : null,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: kind.color.withValues(alpha: 0.11),
          side: BorderSide(color: kind.color.withValues(alpha: 0.45)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        child:
            vertical
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(kind.icon, color: kind.color, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      kind.shortLabel,
                      style: TextStyle(
                        color: kind.color,
                        fontFamily: 'RobotoMono',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(kind.icon, color: kind.color, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      kind.shortLabel,
                      style: TextStyle(
                        color: kind.color,
                        fontFamily: 'RobotoMono',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _VenueMapCanvas extends StatelessWidget {
  const _VenueMapCanvas({required this.spots, required this.onSpotTap});

  final List<VenueSpot> spots;
  final void Function(VenueSpot spot) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFFEFF2EC)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mapWidth = constraints.maxWidth;
            final mapHeight = constraints.maxHeight;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: CustomPaint(painter: _StadiumPainter())),
                ...spots.map((spot) {
                  final pinWidth = 26.0;
                  final pinHeight = 26.0;
                  final left = math.max(
                    0.0,
                    math.min(
                      mapWidth - pinWidth,
                      mapWidth * spot.x - pinWidth / 2,
                    ),
                  );
                  final top = math.max(
                    0.0,
                    math.min(
                      mapHeight - pinHeight,
                      mapHeight * spot.y - pinHeight / 2,
                    ),
                  );

                  return Positioned(
                    left: left,
                    top: top,
                    child: GestureDetector(
                      onTap: () => onSpotTap(spot),
                      child: _SpotPin(spot: spot),
                    ),
                  );
                }),
                const Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(child: _YouAreHerePill()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StadiumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFE2EBE5), Color(0xFFF7F8F4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final venueRect = Rect.fromLTWH(
      size.width * 0.10,
      size.height * 0.08,
      size.width * 0.80,
      size.height * 0.84,
    );
    final venueBorder = RRect.fromRectAndRadius(
      venueRect,
      const Radius.circular(28),
    );
    final venueFillPaint = Paint()..color = const Color(0xFFE9E4D8);
    canvas.drawRRect(venueBorder, venueFillPaint);

    final ringRect = Rect.fromLTWH(
      size.width * 0.17,
      size.height * 0.16,
      size.width * 0.66,
      size.height * 0.66,
    );
    final ringPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 34
          ..color = const Color(0xFFC7D2CB);
    canvas.drawOval(ringRect, ringPaint);

    final fieldRect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.24,
      size.width * 0.50,
      size.height * 0.50,
    );
    final fieldPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFCEE6D8), Color(0xFFA8D1BE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(fieldRect);
    canvas.drawOval(fieldRect, fieldPaint);

    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6
          ..color = const Color(0xFF3D4E47);
    canvas.drawRRect(venueBorder, borderPaint);

    final pathPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0x77909D95);
    canvas.drawLine(
      Offset(size.width * 0.20, size.height * 0.42),
      Offset(size.width * 0.80, size.height * 0.42),
      pathPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.12),
      Offset(size.width * 0.50, size.height * 0.86),
      pathPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _YouAreHerePill extends StatelessWidget {
  const _YouAreHerePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF9AB1A6)),
      ),
      child: const Text(
        'You are here',
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: Color(0xFF38534A),
        ),
      ),
    );
  }
}

class _SpotPin extends StatelessWidget {
  const _SpotPin({required this.spot});

  final VenueSpot spot;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '${spot.name} - ${spot.note}',
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: spot.kind.color,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(spot.kind.icon, size: 14, color: Colors.white),
      ),
    );
  }
}

class _BottomSpotStrip extends StatelessWidget {
  const _BottomSpotStrip({required this.spots, required this.onSpotTap});

  final List<VenueSpot> spots;
  final void Function(VenueSpot spot) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final spot = spots[index];
          return _SpotMiniCard(spot: spot, onTap: () => onSpotTap(spot));
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: spots.length,
      ),
    );
  }
}

class _SpotListPanel extends StatelessWidget {
  const _SpotListPanel({required this.spots, required this.onSpotTap});

  final List<VenueSpot> spots;
  final void Function(VenueSpot spot) onSpotTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDBDFD3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.separated(
          itemCount: spots.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final spot = spots[index];
            return _SpotMiniCard(spot: spot, onTap: () => onSpotTap(spot));
          },
        ),
      ),
    );
  }
}

class _SpotMiniCard extends StatelessWidget {
  const _SpotMiniCard({required this.spot, required this.onTap});

  final VenueSpot spot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 170,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDFE3D9)),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: spot.kind.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(spot.kind.icon, color: spot.kind.color, size: 17),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    spot.kind.label,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 10,
                      color: Color(0xFF64706A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
