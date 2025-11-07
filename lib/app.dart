import 'package:fl_prac_5/features/login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'features/discounts/models/discount.dart';
import 'features/discounts/state/discounts_container.dart';
import 'features/profile/models/user.dart';
import 'features/profile/screens/profile_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const LoginScreen(),
    );
  }
}

class PageContainer extends StatefulWidget {
  final int currentIndex;
  const PageContainer({super.key, required this.currentIndex});

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  late int _currentIndex;

  final users = [
    User(
      id: 'u2',
      name: 'ВладиМир',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    User(
      id: 'u3',
      name: 'Кто-то-Некто',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    currentUser
  ];
  late final demoDiscounts = [
    Discount(
      id: 'd1',
      title: 'Кроссовки Nike Air Max',
      newPrice: '8 999 ₽',
      oldPrice: '12 999 ₽',
      imageUrl: 'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcSAneAbfbWM-kCT2pn15IWwo5acFfGnCbcMIqjWgexi_9IOOm_N4WxmusT_qv5FCIpz__QgXunWft6ig9aCMRGlcEFiVsilj2oherNyAuiRddAdMTB5aK5lTz0',
      storeName: 'SportMaster',
      author: users[0],
      description: 'Скидка только в МОСКВЕ!\nМужские повседневные кроссовки Nike AIR MAX 90 — это икона 90-х, сочетающая стиль и удобство. Созданные с видимой амортизацией Air и вафельной подошвой, они предлагают легендарный комфорт и долговечность. Изготовлены из 17% искусственной кожи, 38% синтетики и 45% текстиля. Яркие цветовые решения и уникальный дизайн делают их идеальными для тех, кто хочет сделать стильное заявление.'
  '\n- Видимая воздушная амортизация обеспечивает исключительный комфорт и поддержку, идеальны для повседневного использования.'
  '\n- Резиновая вафельная подошва гарантирует надежное сцепление и долговечность, придавая традиционный стиль.'
  '\n- Мягкий воротник с низким вырезом не только повышает комфорт, но и подчеркивает элегантный и современный вид.'
  '\n- Легендарная модель из 90-х идеально дополняет любой гардероб, отражая культуру и стиль эпохи.'
  '\n- Высококачественные материалы обеспечивают устойчивость и долговечность, выдерживая ежедневные нагрузки. Наша компания импортирует и дистрибутирует исключительно opигинальные товары, о чем свидетельствуют договоры и сертификаты на продукцию. Мы специализируемся на оптовой и розничной продаже товаров всемирно известных брендов. Весь товар поставляется с opигинальными ярлыками, бирками и этикетками, на упаковке присутствует наклейка со штрих кодом и артикулом товара, который совпадает с артикулом на внутренних ярлыках товара. Все товары, подлежащие обязательной маркировке, занесены в систему Честный знак',
      isInFavourites: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Discount(
      id: 'd2',
      title: 'Наушники Sony WH-1000XM5',
      newPrice: '24 990',
      oldPrice: '29 990',
      imageUrl: 'https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcT-1Dz4Xxtxen4KpkkNzhzisKOByJbguizhTOukbtJ5e92-n4lqgbyMGZdPzAS_qxP-ahqpWNkGnramVw6kLOEt_I37o-cs61z_FiQMCdygg8RuIyYrRDL8aQ',
      storeName: 'M.Video',
      author: users[1],
      description: 'Флагманские наушники с шумоподавлением. Отличная цена по акции!',
      isInFavourites: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    Discount(
      id: 'd3',
      title: 'Кофемашина DeLonghi Magnifica',
      newPrice: '36 499',
      oldPrice: '44 999',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcTzZD1CE-CZ2I3oXzPHGfFh14UwhuLreU8FAIFTJ2AmIEDsIV3-qZ-ghxraXwT1671VaoGuK55jxoXVLpB9_pnagZCHDBVq7i3aLS1zUBmyMQ96eY09wxBR',
      storeName: 'Эльдорадо',
      author: users[2],
      description: 'Автоматическая кофемашина с капучинатором и регулировкой помола.',
      isInFavourites: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }


  void _onTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PageContainer(currentIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DiscountsContainer(discounts: demoDiscounts),
      ProfileScreen(
        discounts: demoDiscounts,
        onToggleFavourite: (String value) {},
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Скидки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Мой профиль',
          ),
        ],
      ),
    );
  }
}

User currentUser = User(
  id: 'u1',
  name: 'Minuano',
  avatarUrl: 'https://i.pravatar.cc/150?img=4',
);