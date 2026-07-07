import '../models/academy_module.dart';
// ─── DATA KURIKULUM ACADEMY ──────────────────────────────────
class AppCurriculum {
  AppCurriculum._();

  static const List<AcademyModule> modules = [
    AcademyModule(
      id: 1,
      title: "WHAT IS BLOCKCHAIN",
      description: "Blockchain adalah teknologi pencatatan informasi yang terdesentralisasi dan aman, di mana data transaksi disimpan dalam blok yang terhubung secara berurutan. Setiap blok mengandung informasi transaksi, timestamp, dan hash dari blok sebelumnya, membentuk rantai yang tidak dapat diubah. Dengan pendekatan desentralisasi, tidak ada pihak tunggal yang mengendalikan jaringan, sehingga meningkatkan keamanan dan mengurangi risiko penipuan.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur1.png",
      duration: "2 Weeks",
      level: "Beginner",
    ),
    AcademyModule(
      id: 2,
      title: "CRYPTOGRAPHY SYSTEM",
      description: "Sistem node dalam kriptografi, terutama dalam konteks blockchain, terdiri dari berbagai jenis node seperti full node, yang menyimpan salinan lengkap dari seluruh blockchain dan memverifikasi transaksi; light node, yang hanya menyimpan sebagian data dan bergantung pada full node untuk validasi; dan mining node, yang terlibat dalam proses penambangan untuk menambahkan blok baru ke rantai yang bersama sama berperan dalam memastikan keamanan, transparansi, dan keandalan transaksi.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur2.png",
      duration: "3 Weeks",
      level: "Intermediate",
    ),
    AcademyModule(
      id: 3,
      title: "WHAT IS BITCOIN CURRENCY",
      description: "Bitcoin adalah mata uang digital yang diciptakan pada 2009 oleh Satoshi Nakamoto Menggunakan teknologi blockchain, Bitcoin memungkinkan transaksi aman dan transparan tanpa otoritas pusat. Proses penambangan memvalidasi transaksi, dan total pasokan Bitcoin dibatasi hingga 21 juta koin, menjadikannya menarik sebagai investasi dan penyimpan nilai.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur3.png",
      duration: "4 Weeks",
      level: "Advanced",
    ),
    AcademyModule(
      id: 4,
      title: "ETHEREUM THE ALTCOIN",
      description: "Ethereum dikenal sebagai master altcoin karena menjadi altcoin terbesar dan paling berpengaruh di pasar kripto setelah Bitcoin. Ethereum menawarkan inovasi utama berupa smart contract, yaitu program otomatis yang berjalan di blockchain, memungkinkan pengembangan aplikasi terdesentralisasi (DApps). Platform ini mendukung berbagai ekosistem seperti keuangan terdesentralisasi (DeFi), token non-fungible (NFT), dan banyak proyek blockchain lainnya.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur4.png",
      duration: "3 Weeks",
      level: "Advanced",
    ),
    AcademyModule(
      id: 5,
      title: "WHAT IS P-O-S AND P-O-W",
      description: "Dalam Proof of Work, seperti yang digunakan oleh Bitcoin, penambang harus menyelesaikan masalah matematika yang rumit dengan menggunakan daya komputasi tinggi untuk memvalidasi transaksi. Proof of Stake lebih efisien dalam hal energi, karena menggantikan kebutuhan daya komputasi dengan sistem di mana validator dipilih berdasarkan jumlah cryptocurrency yang mereka \"stake\" atau pertaruhkan dalam jaringan.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur5.png",
      duration: "2 Weeks",
      level: "Intermediate",
    ),
    AcademyModule(
      id: 6,
      title: "WALLET AND EXCHANGE",
      description: "Wallet digunakan untuk menyimpan dan mengelola aset kripto secara aman melalui kunci privat, terdiri dari hot wallet yang terhubung internet dan lebih praktis, serta cold wallet yang offline dan lebih aman. Sementara itu, exchange adalah platform untuk membeli, menjual, dan memperdagangkan cryptocurrency, terbagi menjadi centralized exchange (CEX) yang dikelola oleh perusahaan dan decentralized exchange (DEX) yang berbasis peer-to-peer",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur6.png",
      duration: "4 Weeks",
      level: "Advanced",
    ),
    AcademyModule(
      id: 7,
      title: "COINS OTHER THAN BITCOIN",
      description: "Altcoin adalah istilah yang digunakan untuk menggambarkan semua cryptocurrency selain Bitcoin. Nama ini berasal dari gabungan \"alternative\" dan \"coin\". Altcoin mencakup berbagai jenis aset digital, seperti Ethereum yang mendukung smart contract, Ripple untuk transaksi lintas batas, dan stablecoin seperti USDT. Altcoin sering menawarkan inovasi seperti efisiensi transaksi, skalabilitas",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur7.png",
      duration: "5 Weeks",
      level: "Advanced",
    ),
    AcademyModule(
      id: 8,
      title: "NARATIVE COIN",
      description: "Narrative coin adalah jenis koin yang pergerakan harganya sangat dipengaruhi oleh narasi atau tren yang sedang populer di pasar, seperti AI, DeFi, GameFi, atau meme coin, di mana kekuatan utamanya bukan hanya pada teknologi atau fundamental, melainkan pada cerita yang dipercaya dan diikuti banyak orang sehingga mampu mendorong minat, adopsi, dan spekulasi; karena sifatnya yang sangat bergantung pada hype.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur8.png",
      duration: "2 Weeks",
      level: "Intermediate",
    ),
    AcademyModule(
      id: 9,
      title: "METODE SPOT MARKET",
      description: "Metode spot market adalah cara jual beli aset kripto secara langsung dengan harga pasar saat itu juga, artinya transaksi terjadi “on the spot” tanpa kontrak berjangka atau leverage. Dalam spot market, pembeli langsung memiliki aset kripto setelah membeli, dan penjual langsung menerima pembayaran sesuai harga yang disepakati di pasar. Jadi, metode ini sederhana karena hanya melibatkan pertukaran aset dan uang secara nyata.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur9.png",
      duration: "3 Weeks",
      level: "Expert",
    ),
    AcademyModule(
      id: 10,
      title: "METODE FUTURES MARKET",
      description: "Futures market dalam cryptocurrency adalah sistem perdagangan kontrak yang merepresentasikan harga aset kripto di masa depan, di mana trader tidak benar-benar memiliki aset tersebut, melainkan berspekulasi apakah harga akan naik melalui posisi *long* atau turun melalui posisi *short*. Cara ini memungkinkan keuntungan bahkan saat pasar turun, lebih fleksibel dibanding spot market, namun berisiko tinggi karena penggunaan leverage yang dapat melipatgandakan keuntungan sekaligus kerugian.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur10.png",
      duration: "2 Weeks",
      level: "Intermediate",
    ),
    AcademyModule(
      id: 11,
      title: "METODE FUTURES MARKET",
      description: "Futures market dalam cryptocurrency adalah sistem perdagangan kontrak yang merepresentasikan harga aset kripto di masa depan, di mana trader tidak benar-benar memiliki aset tersebut, melainkan berspekulasi apakah harga akan naik melalui posisi *long* or turun melalui posisi *short*. Cara ini memungkinkan keuntungan bahkan saat pasar turun, lebih fleksibel dibanding spot market, namun berisiko tinggi karena penggunaan leverage yang dapat melipatgandakan keuntungan sekaligus kerugian.",
      imageUrl: "https://www.ricocapital.id/images/curriculum/cur11.png",
      duration: "4 Weeks",
      level: "Expert",
      isLocked: true,
    ),
  ];
}