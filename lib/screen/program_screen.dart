import 'package:flutter/material.dart';

import '../theme/my_colors.dart';

enum ProgramCategory {
  wrestling('Бөх'),
  archery('Сур'),
  knuckleBone('Шагай'),
  horseRacing('Морь');

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
      title: 'Бөхийн нээлтийн даваа',
      time: '07/11 09:00',
      location: 'Төв цэнгэлдэх',
      category: ProgramCategory.wrestling,
    ),
    ProgramItem(
      title: 'Бөхийн 2-р даваа',
      time: '07/11 14:30',
      location: 'Төв цэнгэлдэх',
      category: ProgramCategory.wrestling,
    ),
    ProgramItem(
      title: 'Сурын урьдчилсан харваа',
      time: '07/11 10:00',
      location: 'Сурын талбай',
      category: ProgramCategory.archery,
    ),
    ProgramItem(
      title: 'Сурын финал',
      time: '07/12 16:00',
      location: 'Сурын талбай',
      category: ProgramCategory.archery,
    ),
    ProgramItem(
      title: 'Шагайн тойрог',
      time: '07/12 11:00',
      location: 'Шагайн асар',
      category: ProgramCategory.knuckleBone,
    ),
    ProgramItem(
      title: 'Шагайн аварга',
      time: '07/13 12:30',
      location: 'Шагайн асар',
      category: ProgramCategory.knuckleBone,
    ),
    ProgramItem(
      title: 'Их насны морь',
      time: '07/11 08:30',
      location: 'Khui Doloon Hudag',
      category: ProgramCategory.horseRacing,
    ),
    ProgramItem(
      title: 'Соёолон морь',
      time: '07/12 08:30',
      location: 'Khui Doloon Hudag',
      category: ProgramCategory.horseRacing,
    ),
  ];

  void _handleTap(ProgramItem item) {
    if (!widget.isAuthenticated) {
      widget.onRequireAuth(
        'Эхлээд баталгаажаад хөтөлбөрийн мэдээлэл үзнэ үү.',
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
            'Наадмын хөтөлбөр',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: MyColors.textPrimary,
              shadows: [
                Shadow(
                  color: MyColors.primaryBlue,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: MyColors.borderNeutral),
                boxShadow: const [
                  BoxShadow(
                    color: MyColors.shadowSoft,
                    blurRadius: 10,
                    offset: Offset(0, 3),
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
              selected ? MyColors.blueSoft : MyColors.surfaceMuted,
          side: BorderSide(
            color:
                selected ? MyColors.primaryBlue : MyColors.borderNeutral,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: onTap,
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: MyColors.textPrimary,
            fontSize: compact ? 13 : 14,
            shadows:
                selected
                    ? const [
                      Shadow(
                        color: MyColors.primaryBlue,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ]
                    : null,
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
          colors: [MyColors.surface, MyColors.surfaceMuted],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MyColors.borderNeutral),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: MyColors.blueSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.time.split(' ').last,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: MyColors.textPrimary,
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
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: MyColors.textPrimary,
                    shadows: [
                      Shadow(
                        color: MyColors.primaryBlue,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.time} - ${item.location}',
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
    );
  }
}
