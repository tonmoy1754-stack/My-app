import 'package:flutter/material.dart';

void main() => runApp(const GStyleApp());

const gold = Color(0xFFC9A227);
const ink = Color(0xFF171717);

class Product {
  final String name, category, description;
  final int price;
  final IconData icon;
  const Product(this.name, this.category, this.price, this.icon, this.description);
}

const products = <Product>[
  Product('Classic Cotton Shirt', 'Fashion', 850, Icons.checkroom, 'Comfortable everyday cotton shirt.'),
  Product('Premium Casual T-Shirt', 'Fashion', 550, Icons.dry_cleaning, 'Soft fabric for daily wear.'),
  Product('Women’s Everyday Kurti', 'Fashion', 990, Icons.woman, 'Simple and elegant everyday style.'),
  Product('Denim Jeans', 'Fashion', 1250, Icons.checkroom, 'Versatile denim for casual outfits.'),
  Product('Kids Cotton Set', 'Fashion', 700, Icons.child_friendly, 'Comfortable kids clothing set.'),
  Product('Wireless Earbuds', 'Gadgets', 1450, Icons.headphones, 'Compact wireless audio companion.'),
  Product('20W Fast Charger', 'Gadgets', 650, Icons.electrical_services, 'Fast charging adapter.'),
  Product('Power Bank 10000mAh', 'Gadgets', 1850, Icons.battery_charging_full, 'Portable backup power.'),
  Product('Smart Watch', 'Gadgets', 2200, Icons.watch, 'Everyday smart watch.'),
  Product('Bluetooth Speaker', 'Gadgets', 1350, Icons.speaker, 'Portable music speaker.'),
  Product('Premium Miniket Rice 5kg', 'Grocery', 420, Icons.rice_bowl, 'Daily household rice pack.'),
  Product('Soybean Oil 2L', 'Grocery', 340, Icons.local_drink, 'Cooking oil for everyday use.'),
  Product('Lentils 1kg', 'Grocery', 135, Icons.grain, 'Quality everyday lentils.'),
  Product('Mixed Snacks Pack', 'Grocery', 180, Icons.cookie, 'A selection of tasty snacks.'),
  Product('Tea  mirar 500g', 'Grocery', 260, Icons.emoji_food_beverage, 'Aromatic tea for your break.'),
];

class GStyleApp extends StatefulWidget {
  const GStyleApp({super.key});
  @override
  State<GStyleApp> createState() => _GStyleAppState();
}

class _GStyleAppState extends State<GStyleApp> {
  bool bangla = false;
  final Map<Product, int> cart = {};
  int tab = 0;
  String category = 'All';
  String search = '';

  String tr(String en, String bn) => bangla ? bn : en;
  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (a, e) => a + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'G Style',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
        appBarTheme: const AppBarTheme(backgroundColor: ink, foregroundColor: Colors.white),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('G STYLE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
          actions: [
            TextButton(onPressed: () => setState(() => bangla = !bangla),
              child: Text(bangla ? 'EN' : 'বাংলা', style: const TextStyle(color: gold, fontWeight: FontWeight.bold))),
            IconButton(onPressed: () => setState(() => tab = 1), icon: Badge(label: Text('$cartCount'), child: const Icon(Icons.shopping_bag_outlined))),
          ],
        ),
        body: IndexedStack(index: tab, children: [
          _home(),
          _cartPage(),
          _ordersPage(),
          _profilePage(),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined), label: tr('Home', 'হোম')),
            NavigationDestination(icon: const Icon(Icons.shopping_cart_outlined), label: tr('Cart', 'কার্ট')),
            NavigationDestination(icon: const Icon(Icons.receipt_long), label: tr('Orders', 'অর্ডার')),
            NavigationDestination(icon: const Icon(Icons.person_outline), label: tr('Profile', 'প্রোফাইল')),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    final visible = products.where((p) =>
      (category == 'All' || p.category == category) &&
      p.name.toLowerCase().contains(search.toLowerCase())).toList();
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('YOUR EVERYDAY SHOPPING DESTINATION', style: TextStyle(color: gold, fontSize: 11, letterSpacing: 1.1)),
            const SizedBox(height: 8),
            Text(tr('Shop Smart. Live Better.', 'স্মার্ট কেনাকাটা, সুন্দর জীবন।'),
              style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(tr('Fashion • Gadgets • Foods & Grocery', 'ফ্যাশন • গ্যাজেটস • খাবার ও মুদি'),
              style: const TextStyle(color: Colors.white70)),
          ]),
        ),
      )),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: tr('Search products...', 'পণ্য খুঁজুন...'),
            prefixIcon: const Icon(Icons.search),
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
          onChanged: (v) => setState(() => search = v),
        ),
      )),
      SliverToBoxAdapter(child: SizedBox(height: 52, child: ListView(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12),
        children: ['All', 'Fashion', 'Gadgets', 'Grocery'].map((c) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(label: Text(c == 'All' ? tr('All', 'সব') : c),
            selected: category == c, onSelected: (_) => setState(() => category = c)),
        )).toList(),
      ))),
      SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((context, i) {
            final p = visible[i];
            return Card(
              color: Colors.white, clipBehavior: Clip.antiAlias,
              child: InkWell(onTap: () => _showProduct(p), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Container(width: double.infinity, color: const Color(0xFFF1EEE5),
                  child: Icon(p.icon, size: 58, color: ink))),
                Padding(padding: const EdgeInsets.fromLTRB(10, 8, 10, 0), child: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
                Padding(padding: const EdgeInsets.fromLTRB(10, 4, 10, 8), child: Row(children: [
                  Expanded(child: Text('৳${p.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: ink))),
                  InkWell(onTap: () => setState(() => cart[p] = (cart[p] ?? 0) + 1),
                    child: const CircleAvatar(radius: 16, backgroundColor: gold, child: Icon(Icons.add, size: 19, color: ink))),
                ])),
              ])),
            );
          }, childCount: visible.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: .73),
        ),
      ),
    ]);
  }

  void _showProduct(Product p) {
    showModalBottomSheet(context: context, builder: (_) => Padding(
      padding: const EdgeInsets.all(22), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Icon(p.icon, size: 70, color: gold)),
        Text(p.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6), Text(p.description),
        const SizedBox(height: 10), Text('৳${p.price}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14), SizedBox(width: double.infinity, child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: ink),
          onPressed: () { setState(() => cart[p] = (cart[p] ?? 0) + 1); Navigator.pop(context); },
          child: Text(tr('Add to Cart', 'কার্টে যোগ করুন')),
        )),
      ]),
    ));
  }

  Widget _cartPage() => cart.isEmpty
    ? Center(child: Text(tr('Your cart is empty', 'আপনার কার্ট খালি')))
    : Column(children: [
        Expanded(child: ListView(children: cart.entries.map((e) => ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFF1EEE5), child: Icon(Icons.shopping_bag, color: ink)),
          title: Text(e.key.name), subtitle: Text('৳${e.key.price} × ${e.value}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(onPressed: () => setState(() { if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; } }), icon: const Icon(Icons.remove_circle_outline)),
            Text('${e.value}'),
            IconButton(onPressed: () => setState(() => cart[e.key] = e.value + 1), icon: const Icon(Icons.add_circle_outline)),
          ]),
        )).toList())),
        SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('৳$total', style: const TextStyle(fontWeight: FontWeight.bold))]),
          const SizedBox(height: 10), SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ink),
            onPressed: _checkout, child: Text(tr('Proceed to Checkout', 'চেকআউট করুন')),
          )),
        ]))),
      ]);

  void _checkout() {
    final name = TextEditingController();
    final phone = TextEditingController();
    final address = TextEditingController();
    String payment = 'Cash on Delivery';
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => StatefulBuilder(builder: (ctx, refresh) =>
      Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(tr('Checkout', 'চেকআউট'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          TextField(controller: name, decoration: InputDecoration(labelText: tr('Full name', 'পুরো নাম'))),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: tr('Mobile number', 'মোবাইল নম্বর'))),
          TextField(controller: address, decoration: InputDecoration(labelText: tr('Delivery address', 'ডেলিভারি ঠিকানা'))),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: payment, decoration: InputDecoration(labelText: tr('Payment method', 'পেমেন্ট পদ্ধতি')),
            items: const [DropdownMenuItem(value: 'Cash on Delivery', child: Text('Cash on Delivery')), DropdownMenuItem(value: 'Online Payment (Demo)', child: Text('Online Payment (Demo)'))],
            onChanged: (v) => refresh(() => payment = v ?? payment)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ink),
            onPressed: () {
              if (name.text.trim().isEmpty || phone.text.trim().isEmpty || address.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields')));
                return;
              }
              Navigator.pop(ctx);
              setState(() { cart.clear(); tab = 2; });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo order placed. Connect backend for real orders.')));
            },
            child: Text(tr('Place Demo Order', 'ডেমো অর্ডার নিশ্চিত করুন')),
          )),
        ])),
      )));
  }

  Widget _ordersPage() => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.receipt_long, size: 60, color: gold),
      const SizedBox(height: 12),
      Text(tr('Your orders will appear here after checkout.', 'চেকআউটের পর আপনার অর্ডার এখানে দেখা যাবে।'), textAlign: TextAlign.center),
      const SizedBox(height: 8),
      const Text('Demo mode — order history requires a connected backend.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
    ]),
  ));

  Widget _profilePage() => ListView(padding: const EdgeInsets.all(16), children: [
    const CircleAvatar(radius: 38, backgroundColor: ink, child: Icon(Icons.person, color: gold, size: 40)),
    const SizedBox(height: 12),
    const Center(child: Text('G Style Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
    const SizedBox(height: 18),
    ListTile(leading: const Icon(Icons.language), title: Text(tr('Language', 'ভাষা')), trailing: Text(bangla ? 'বাংলা' : 'English'), onTap: () => setState(() => bangla = !bangla)),
    const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('Saved Addresses')),
    const ListTile(leading: Icon(Icons.support_agent), title: Text('Help & Support')),
    const ListTile(leading: Icon(Icons.info_outline), title: Text('About G Style')),
  ]);
}
