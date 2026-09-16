import 'package:flutter/material.dart';
import 'theme/brondix_theme.dart';
import 'painters/stamp_punch_card_painter.dart';

class BrondixApp extends StatefulWidget {
  const BrondixApp({super.key});

  @override
  State<BrondixApp> createState() => _BrondixAppState();
}

class _BrondixAppState extends State<BrondixApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _cards = [
    {
      'shop': 'Artisan Roasters Co.',
      'reward': 'Free Pour-over or Flat White',
      'total': 8,
      'punches': 6,
      'color': BrondixTheme.accent,
    },
    {
      'shop': 'Sourdough & Cinnamon Bakery',
      'reward': 'Artisan Croissant / Pastry',
      'total': 6,
      'punches': 4,
      'color': const Color(0xFFD97706),
    },
    {
      'shop': 'Old Town Paperback Bookstore',
      'reward': '\$10 Book Voucher',
      'total': 10,
      'punches': 10,
      'color': const Color(0xFF059669),
    },
  ];

  int _selectedCardIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _punchCurrentCard() {
    setState(() {
      final card = _cards[_selectedCardIndex];
      final current = card['punches'] as int;
      final total = card['total'] as int;
      if (current < total) {
        card['punches'] = current + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brondix Stamp Cards',
      debugShowCheckedModeBanner: false,
      theme: BrondixTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'BRONDIX STAMP WALLET',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: BrondixTheme.ink,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  children: [
                    _buildWalletPage(),
                    _buildRewardsPage(),
                    _buildNewCardPage(),
                    _buildMerchantsPage(),
                  ],
                ),
              ),
              // Dots indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final isSel = _currentPage == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSel ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSel ? BrondixTheme.accent : BrondixTheme.edge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletPage() {
    final activeCard = _cards[_selectedCardIndex];
    final punches = activeCard['punches'] as int;
    final total = activeCard['total'] as int;
    final isComplete = punches >= total;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stamp Card Custom Painter
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: StampPunchCardPainter(
                totalPunches: total,
                completedPunches: punches,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeCard['shop'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BrondixTheme.ink),
                    ),
                    Text(
                      activeCard['reward'] as String,
                      style: const TextStyle(fontSize: 12, color: BrondixTheme.muted),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$punches of $total punches', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: BrondixTheme.accent)),
                        Text(isComplete ? 'REWARD READY!' : '${total - punches} more to go',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isComplete ? Colors.green : BrondixTheme.muted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Action button
          ElevatedButton.icon(
            onPressed: isComplete ? null : _punchCurrentCard,
            icon: const Icon(Icons.local_cafe_rounded),
            label: Text(isComplete ? 'FREE REWARD UNLOCKED!' : 'PUNCH COFFEE STAMP (+1)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: BrondixTheme.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 24),
          // Card switch tabs
          const Text('Your Stamp Cards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          ..._cards.asMap().entries.map((entry) {
            final idx = entry.key;
            final c = entry.value;
            final isSel = idx == _selectedCardIndex;
            return Card(
              color: isSel ? BrondixTheme.edge.withValues(alpha: 0.4) : BrondixTheme.surface,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: BrondixTheme.edge,
                  child: Icon(Icons.loyalty_rounded, color: BrondixTheme.accent),
                ),
                title: Text(c['shop'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${c['punches']}/${c['total']} stamps • ${c['reward']}'),
                trailing: isSel ? const Icon(Icons.check_circle_rounded, color: BrondixTheme.accent) : null,
                onTap: () => setState(() => _selectedCardIndex = idx),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRewardsPage() {
    final vouchers = [
      {'title': 'Old Town Paperback Bookstore', 'reward': '\$10 In-Store Book Voucher', 'code': 'BOOK-9842', 'status': 'Claimable Now'},
      {'title': 'Artisan Roasters Co.', 'reward': 'Free Oat Milk Cortado', 'code': 'COFFEE-1029', 'status': '2 punches left'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final v = vouchers[i];
        final isReady = v['status'] == 'Claimable Now';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(v['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isReady ? Colors.green.withValues(alpha: 0.2) : BrondixTheme.edge,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(v['status']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isReady ? Colors.green : BrondixTheme.muted)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(v['reward']!, style: const TextStyle(fontSize: 13, color: BrondixTheme.ink, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Voucher Token: ${v['code']}', style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: BrondixTheme.accent, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewCardPage() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController rewardCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Add New Loyalty Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Merchant / Cafe Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rewardCtrl,
                decoration: const InputDecoration(
                  labelText: 'Reward (e.g. Free Pastry)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    setState(() {
                      _cards.add({
                        'shop': nameCtrl.text,
                        'reward': rewardCtrl.text.isNotEmpty ? rewardCtrl.text : 'Special Reward',
                        'total': 8,
                        'punches': 0,
                        'color': BrondixTheme.accent,
                      });
                      _selectedCardIndex = _cards.length - 1;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('New Loyalty Card Added!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrondixTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('CREATE CARD'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantsPage() {
    final merchants = [
      {'name': 'Artisan Roasters Co.', 'category': 'Specialty Coffee', 'dist': '0.3 mi away'},
      {'name': 'Sourdough & Cinnamon Bakery', 'category': 'Artisan Pastry', 'dist': '0.7 mi away'},
      {'name': 'Old Town Paperback Bookstore', 'category': 'Independent Books', 'dist': '1.1 mi away'},
      {'name': 'Matcha Green Tea Bar', 'category': 'Botanical Drinks', 'dist': '1.4 mi away'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: merchants.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final m = merchants[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: BrondixTheme.edge,
              child: Icon(Icons.storefront_rounded, color: BrondixTheme.accent),
            ),
            title: Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${m['category']} • ${m['dist']}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: BrondixTheme.muted),
          ),
        );
      },
    );
  }
}
