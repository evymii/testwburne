import 'package:flutter/material.dart';

enum ProgramCategory {
  wrestling('Buh'),
  archery('Harvaa'),
  knuckleBone('Shagai'),
  horseRacing('Mori');

  const ProgramCategory(this.label);
  final String label;
}

class ProgramItem {
  const ProgramItem({
    required this.title,
    required this.time,
    required this.location,
    required this.category,
  });

  final String title;
  final String time;
  final String location;
  final ProgramCategory category;
}

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({
    super.key,
    required this.isAuthenticated,
    required this.onRequireAuth,
    required this.onProgramTap,
  });

  final bool isAuthenticated;
  final void Function(String message) onRequireAuth;
  final void Function(ProgramItem item) onProgramTap;

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  ProgramCategory _selectedCategory = ProgramCategory.wrestling;

  static const List<ProgramItem> _programItems = [
    ProgramItem(
      title: 'Opening Wrestling Round',
      time: '07/11 09:00',
      location: 'Central Stadium',
      category: ProgramCategory.wrestling,
    ),
    ProgramItem(
      title: 'Wrestling Round 2',
      time: '07/11 14:30',
      location: 'Central Stadium',
      category: ProgramCategory.wrestling,
    ),
    ProgramItem(
      title: 'Archery Qualifier',
      time: '07/11 10:00',
      location: 'Archery Field',
      category: ProgramCategory.archery,
    ),
    ProgramItem(
      title: 'Archery Final',
      time: '07/12 16:00',
      location: 'Archery Field',
      category: ProgramCategory.archery,
    ),
    ProgramItem(
      title: 'Shagai Round',
      time: '07/12 11:00',
      location: 'Shagai Arena',
      category: ProgramCategory.knuckleBone,
    ),
    ProgramItem(
      title: 'Shagai Championship',
      time: '07/13 12:30',
      location: 'Shagai Arena',
      category: ProgramCategory.knuckleBone,
    ),
    ProgramItem(
      title: 'Adult Horse Race',
      time: '07/11 08:30',
      location: 'Khui Doloon Hudag',
      category: ProgramCategory.horseRacing,
    ),
    ProgramItem(
      title: 'Soyolon Horse Race',
      time: '07/12 08:30',
      location: 'Khui Doloon Hudag',
      category: ProgramCategory.horseRacing,
    ),
  ];

  void _handleTap(ProgramItem item) {
    if (!widget.isAuthenticated) {
      widget.onRequireAuth(
        'Please authenticate first to open program details.',
      );
      return;
    }
    widget.onProgramTap(item);
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _programItems
        .where((item) => item.category == _selectedCategory)
        .toList(growable: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Naadam Program',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: Color(0xFF22332D),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD9DCCE)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final useWide = constraints.maxWidth > 560;
                  if (useWide) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: _CategoryRail(
                            selectedCategory: _selectedCategory,
                            onSelect: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ProgramList(
                            items: filteredItems,
                            onTap: _handleTap,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      _CategoryRow(
                        selectedCategory: _selectedCategory,
                        onSelect: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: _ProgramList(
                          items: filteredItems,
                          onTap: _handleTap,
                        ),
                      ),
                    ],
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

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({required this.selectedCategory, required this.onSelect});

  final ProgramCategory selectedCategory;
  final void Function(ProgramCategory category) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: ProgramCategory.values.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final category = ProgramCategory.values[index];
        return _CategoryChip(
          label: category.label,
          selected: category == selectedCategory,
          onTap: () => onSelect(category),
          compact: false,
        );
      },
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.selectedCategory, required this.onSelect});

  final ProgramCategory selectedCategory;
  final void Function(ProgramCategory category) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ProgramCategory.values
          .map(
            (category) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _CategoryChip(
                  label: category.label,
                  selected: category == selectedCategory,
                  onTap: () => onSelect(category),
                  compact: true,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.compact,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 48 : 64,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? const Color(0xFFFADDD1) : const Color(0xFFF8F8F6),
          side: BorderSide(
            color: selected ? const Color(0xFFE09A7E) : const Color(0xFFD5D8CB),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF2B3532),
            fontSize: compact ? 13 : 14,
          ),
        ),
      ),
    );
  }
}

class _ProgramList extends StatelessWidget {
  const _ProgramList({required this.items, required this.onTap});

  final List<ProgramItem> items;
  final void Function(ProgramItem item) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onTap(item),
          child: _ProgramCard(item: item),
        );
      },
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.item});

  final ProgramItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF7FAF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE2D8)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2ED),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.time.split(' ').last,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF33574A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Color(0xFF26342F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.time} - ${item.location}',
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 11,
                    color: Color(0xFF66726D),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF3A4C45)),
        ],
      ),
    );
  }
}
