import 'package:flutter/material.dart';

import '../services/custom_icons/custom_icons.dart';

var MAIN_COLOR = Colors.black;
var categories = [
  {
    "name": "ملابس نسائيه",
    "image": "assets/images/WLanding.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/woman-clothes.png"
  },
  {
    "name": "ملابس رجاليه",
    "image": "assets/images/Mencat.jpg",
    "main_category": "Men Apparel",
    "icon": "assets/categories_icons/men_clothes.png"
  },
  {
    "name": "ملابس نسائيه مقاس كبير",
    "image": "assets/images/Womenpluscat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/t-shirt_women.png"
  },
  {
    "name": "ملابس أطفال",
    "image": "assets/images/KLanding.jpg",
    "main_category": "Kids",
    "icon": "assets/categories_icons/baby.png"
  },
  {
    "name": "للرضيع و الأم",
    "image": "assets/images/Pregcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/mother.png"
  },
  {
    "name": "الأحذيه",
    "image": "assets/images/Shoescat.jpg",
    "main_category": "Shoes",
    "icon": "assets/categories_icons/shoes.png"
  },
  {
    "name": "ملابس داخليه",
    "image": "assets/images/Undercat.jpg",
    "main_category": "Underwear & Sleepwear",
    "icon": "assets/categories_icons/bikini.png"
  },
  {
    "name": "للمنزل",
    "image": "assets/images/Homecat.jpg",
    "main_category": "Home & Living",
    "icon": "assets/categories_icons/house.png"
  },
  {
    "name": "مجوهرات و ساعات",
    "image": "assets/images/Jwelerycat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/jewelry.png"
  },
  {
    "name": "اكسسوارات",
    "image": "assets/images/ALanding.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/bags.png"
  },
  {
    "name": "مستلزمات سيارات",
    "image": "assets/images/carcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/car.png"
  },
  {
    "name": "للحيوانات الاليفة",
    "image": "assets/images/Petcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/rabbit.png"
  },
  {
    "name": "مستلزمات مكاتب",
    "image": "assets/images/Officecat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/worker.png"
  },
  {
    "name": "مستحضرات تجميلية",
    "image": "assets/images/Beautycat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/cosmetics.png"
  },
  {
    "name": "الكترونيات",
    "image": "assets/images/ElectCat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/responsive.png"
  },
  {
    "name": "حقائب",
    "image": "assets/images/Bagcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/travel.png"
  },
  {
    "name": "مستلزمات اعراس",
    "image": "assets/images/Weddingcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/wedding-arch.png"
  },
  {
    "name": "مستلزمات رياضية",
    "image": "assets/images/Sportcat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/dumbbell.png"
  },
];
//the main cat will be "Men Apparel"
var sub_categories_Men__sizes = [
  {
    "name": "جميع الأقسام",
    "key": "all",
  },
  {
    "name": "بلايز",
    "key": "Men Tops",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Men Co-ords",
  },
  {
    "name": "هوديز",
    "key": "Men Hoodies & Sweatshirts",
  },
  {
    "name": "ملابس سفلية",
    "key": "Men Bottoms",
  },
  {
    "name": "ملابس خارجية",
    "key": "Men Outerwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Men Denim",
  },
  {
    "name": "منسوجات",
    "key": "Men Knitwear",
  },
  {
    "name": "بدلات",
    "key": "Men Suits & Separates",
  },
  {
    "name": "ملابس سباحة",
    "key": "Men Swimwear",
  },
];

var sub_categories_women_appearel = [
  {
    "name": "جميع الأقسام",
    "key": "Women Clothing",
  },
  {
    "name": "فساتين",
    "key": "Women Dresses",
  },
  {
    "name": "ملابس سفلية",
    "key": "Women Bottoms",
  },
  {
    "name": "ملابس منسوجات",
    "key": "Women Knitwear",
  },
  {
    "name": "ملابس خارجية",
    "key": "Women Outerwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Women Denim",
  },
  {
    "name": "بلايز نسائية",
    "key": "Women Sweatshirts",
  },
  {
    "name": "ملابس خليجية",
    "key": "Arabian Wear",
  },
  {
    "name": "تنسيقات",
    "key": "Women Co-ords",
  },
  {
    "name": "زفاف وسهرات",
    "key": "Women Wedding,Weddings,Women Party Wear",
  },
  {
    "name": "ملابس سباحة",
    "key": "Women Beachwear",
  },
  {
    "name": "بدلات",
    "key": "Women Suits",
  },
  {
    "name": "جمبسوت ",
    "key": "Women Jumpsuits & Bodysuits",
  },
  {
    "name": "ملابس علوية",
    "key": "Women Tops,Blouses & Tee",
  },
];

var sub_categories_women_plus_sizes = [
  {
    "name": "فساتين",
    "key": "Plus Size Dresses",
  },
  {
    "name": "ملابس علوية",
    "key": "Plus Size Tops",
  },
  {
    "name": "ملابس سفلية",
    "key": "Plus Size Bottoms",
  },
  {
    "name": "ملابس خارجية",
    "key": "Plus Size Outerwears",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Plus Size Co-Ords",
  },
  {
    "name": "منسوجات",
    "key": "Plus Size Knitwear",
  },
  {
    "name": "ملابس خليجية",
    "key": "Plus Size Arabian Wear",
  },
  {
    "name": "بلايز  نسائية",
    "key": "Plus Size Sweatshirts",
  },
  {
    "name": "بدلات",
    "key": "Plus Size Suits",
  },
  {
    "name": "جمبسوت ",
    "key": "Plus Size Jumpsuits & Bodysuits",
  },
  {
    "name": "ملابس سباحة",
    "key": "Women Plus Beachwear",
  },
  {
    "name": "ملابس زفاف وسهرات",
    "key": "Women Plus Wedding",
  },
];

var sub_categories_kids_sizes = [
  {
    "name": "جميع الأقسام",
    "key": "all",
  },
  {
    "name": "بلايز",
    "key": "Young Boys Tops, Tween Boys Denim Tops, Tween Boys Tops",
  },
  {
    "name": "ملابس خارجية",
    "key": "Young Boys Outerwear, Tween Boys Outerwear",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Young Boys Sets, Tween Boys Sets",
  },
  {
    "name": "هوديز",
    "key": "Young Boys Sweatshirts, Tween Boys Sweatshirts",
  },
  {
    "name": "منسوجات",
    "key": "Young Boys Knitwear, Tween Boys Knitwear",
  },
  {
    "name": "ملابس سفلية",
    "key":
        "Tween Boys Bottoms, Tween Boys Jeans, Tween Boys Denim Shorts, Young Boys Bottoms, Young Boys Jeans",
  },
  {
    "name": "اقمشة جينز",
    "key": "Tween Boys Denim, Young Boys Denim",
  },
  {
    "name": "بجامات",
    "key": "Tween Boys Pajamas",
  },
  {
    "name": "بدلات",
    "key": "Young Boys Suits",
  },
  {
    "name": "ملابس سباحة",
    "key": "Tween Boys Swimwear",
  },
];
List<String> Men_sizes = [
  "XS 👔",
  "S 👖",
  "M 👖",
  "L 👖",
  "XL 🧥",
  "XXL 👔",
  "XXXL 👔",
  "0XL 👖",
  "1XL 👖",
  "2XL 👕",
  "3XL 👖",
  "4XL 👕",
  "5XL 👖",
  "6XL 👕",
];
List<String> women__sizes = [
  "XXS 👚",
  "XS 👗",
  "S 🩱",
  "M 🩱",
  "L 🩱",
  "XL 🩱",
  "XXL 👘",
  "XXXL 🧥",
  "ONE SIZE 👘",
];

var women_Plus_sizes = ["0XL", "1XL", "2XL", "3XL", "4XL", "5XL"];

var sub_categories_Girls = [
  {
    "name": "فساتين",
    "key": "Tween Girls Dresses, Young Girls Dresses, Teen Girls Dresses",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Teen  Girls Sets, Tween Girls Sets, Young Girls Sets",
  },
  {
    "name": "منسوجات",
    "key": "Tween Girls Knitwear, Young Girls Knitwear",
  },
  {
    "name": "هوديز",
    "key":
        "Young Girls Sweatshirts, Tween Girls Sweatshirts, Teen Girls Sweatshirts",
  },
  {
    "name": "ملابس علوية",
    "key": "Teen Girls Tops, Tween Girls Tops, Young Girls Tops",
  },
  {
    "name": "ملابس خارجية",
    "key": "Young Girls Outerwear, Tween Girls Outerwear, Teen Girls Outerwear",
  },
  {
    "name": "تنانير",
    "key": "Young Girls Skirts, Tween Girls Denim Skirts, Tween Girls Skirts",
  },
  {
    "name": "ملابس سفلية",
    "key":
        "Young Girls Bottoms, Tween Girls Denim Shorts, Tween Girls Jeans, Tween Girls Bottoms, Teen Girls Bottoms",
  },
  {
    "name": "ملابس نوم وبجامات",
    "key": "Tween Girls Pajamas",
  },
  {
    "name": "جمبسوت ",
    "key":
        "Young Girls Jumpsuits, Tween Girls Denim Overalls & Jumpsuits, Tween Girls Jumpsuits",
  },
  {
    "name": "ملابس حفلات وسهرات",
    "key": "Young Girls Partywear, Tween Girls Partywear",
  },
  {
    "name": "ملابس سباحة",
    "key": "Young Girls Beachwear, Tween Girls Beachwear, Teen Girls Beachwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Young Girls Denim",
  },
];

var girls_kids_sizes = [
  "0-3 شهر",
  "3-6 شهر",
  "6-9 شهر",
  "9-12 شهر",
  "12-18 شهر",
  "2سنة",
  "2-3سنة",
  "3سنة",
  "4سنة",
  "5سنة",
  "5-6سنة",
  "6سنة",
  "7سنة",
  "8 سنة",
  "9 سنة",
  "9-10 سنة",
  "10 سنة",
  "11-12 سنة",
  "12 سنة",
  "12-13 سنة",
  "13-14 سنة",
  "L",
  "M",
  "XL",
  "4XL",
  "ONE SIZE"
];

var sub_categories_Boys = [
  {
    "name": "بلايز",
    "key": "Young Boys Tops, Tween Boys Denim Tops, Tween Boys Tops",
  },
  {
    "name": "ملابس خارجية",
    "key": "Young Boys Outerwear, Tween Boys Outerwear",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Young Boys Sets, Tween Boys Sets",
  },
  {
    "name": "هوديز",
    "key": "Young Boys Sweatshirts, Tween Boys Sweatshirts",
  },
  {
    "name": "منسوجات",
    "key": "Young Boys Knitwear, Tween Boys Knitwear",
  },
  {
    "name": "ملابس سفلية",
    "key":
        "Tween Boys Bottoms, Tween Boys Jeans, Tween Boys Denim Shorts, Young Boys Bottoms, Young Boys Jeans",
  },
  {
    "name": "اقمشة جينز",
    "key": "Tween Boys Denim, Young Boys Denim",
  },
  {
    "name": "بجامات",
    "key": "Tween Boys Pajamas",
  },
  {
    "name": "بدلات",
    "key": "Young Boys Suits",
  },
  {
    "name": "ملابس سباحة",
    "key": "Tween Boys Swimwear",
  },
];

var kids_boys_sizes = [
  "6-9 شهر",
  "9-12 شهر",
  "S"
      "2سنة",
  "2-3سنة",
  "3سنة",
  "4سنة",
  "5سنة",
  "5-6سنة",
  "6سنة",
  "7سنة",
  "8 سنة",
  "9 سنة",
  "10 سنة",
  "9-10 سنة",
  "11-12 سنة",
  "12 سنة",
  "12-13 سنة",
  "13-14 سنة",
];

var sub_categories_MaternityBaby = [
  {
    "name": "ملابس حجم كبير",
    "key": "Plus Size Tops",
  },
  {
    "name": "ملابس علوية",
    "key": "Maternity Tops, Maternity Sweaters, Nursing,Maternity Sweatshirts",
  },
  {
    "name": "ملابس سفلية",
    "key": "Maternity Bottoms",
  },
  {
    "name": "اقمشة جينز",
    "key": "Maternity Denim",
  },
  {
    "name": "أطقم  وتنسيقات",
    "key": "Maternity Two-piece Suits",
  },
  {
    "name": "جمبسوت ",
    "key": "Maternity Jumpsuits",
  },
  {
    "name": "ملابس سباحة ",
    "key": "Maternity Beachwear",
  },
  {
    "name": " جمبسوت وملابس للاطفال البنات",
    "key":
        "Baby Girls Jumpsuits, Baby Girls Onesies, Baby Girls Dresses,Baby Girls Denim, Baby Girls Photography Sets Baby Girls Tops",
  },
  {
    "name": " أطقم  وتنسيقات للاطفال البنات",
    "key": "Baby Girls Sets",
  },
  {
    "name": "معاطف وجاكيتات للاطفال البنات",
    "key": "Baby Girls Outerwear",
  },
  {
    "name": "ملابس سفلية للاطفال البنات",
    "key": "Baby Girls Bottoms",
  },
  {
    "name": "أطقم وتنسيقات للاطفال الاولاد",
    "key": "Baby Boys Sets, Baby Boys Pajamas, Baby Boys Onesies"
  },
  {"name": "احذية للاطفال", "key": "Baby Shoes"},
  {
    "name": "مستلزمات واكسسوارات الاطفال",
    "key": "Baby Supplies, Baby Accessories"
  },
];

var sub_categories_WomenShoes = [
  {
    "name": " Boots ",
    "key": "Women Boots",
  },
  {
    "name": "احذية كعب عالي",
    "key": "Pumps",
  },
  {
    "name": "احذية مسطحة و حفايات",
    "key": "Women Flats",
  },
  {
    "name": " شباشب واحذية منزل",
    "key": "Women Slippers, Women Clogs",
  },
  {
    "name": "احذية رياضة",
    "key": "Women Sneakers, Women Athletic Shoes",
  },
  {
    "name": "صنادل",
    "key": "Women Sandals, Women Clogs",
  },
  {
    "name": "احذية شتوية وجزمات",
    "key": "Women Fashion Boots, Women Outdoor Shoes",
  },
  {
    "name": "احذية مسطحة",
    "key": "Women Flats",
  },
  {
    "name": "احذية بنعل عالي",
    "key": "Women Wedges & Flatform",
  },
  {
    "name": "اكسسوارات للاحذية",
    "key": "Shoe Accessories",
  },
];

var Women_shoes_sizes = [
  "35",
  "36",
  "37",
  "38",
  "39",
  "39-40",
  "40",
  "41",
  "42",
  "43",
  "44"
];

var sub_categories_MenShoes = [
  {
    "name": "حفايات",
    "key": "Men Loafers",
  },
  {
    "name": " Boots ",
    "key": "Men Boots",
  },
  {
    "name": "احذية رسمية",
    "key": "Dress Shoes",
  },
  {
    "name": "احذية رياضة",
    "key": "Men Sneakers, Men Athletic Shoes",
  },
  {
    "name": "صنادل",
    "key": "Men Sandals, Men Clogs, Men Flip Flops & Slides",
  },
  {
    "name": " شباشب واحذية منزل",
    "key": "Men Clogs, Men Slippers, Men Work & Safety Shoes",
  },
  {
    "name": "احذية شتوية وجزمات",
    "key": "Men Outdoor Shoes",
  },
  {
    "name": "اكسسوارات للاحذية",
    "key": "Shoe Accessories",
  },
];

var Men_shoes_sizes = [
  "37",
  "39",
  "40",
  "41",
  "42",
  "43",
  "44",
  "45",
  "46",
  "47"
];

var sub_categories_KidsShoes = [
  {
    "name": "حفايات",
    "key": "Kids Flats",
  },
  {
    "name": "احذية رياضة",
    "key": "Kids Sneakers,Kids Athletic Shoes",
  },
  {
    "name": " Boots ",
    "key": "Kids Boots",
  },
  {
    "name": "صنادل",
    "key": "Kids Sandals",
  },
  {
    "name": " شباشب واحذية منزل",
    "key": "Kids Slippers",
  },
];

var Kids_shoes_sizes = [
  "21",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31",
  "32",
  "33",
  "34",
  "35",
  "36",
  "37",
  "38",
  "39",
  "41"
];

var sub_categories_ALLShoes = [
  {
    "name": "حفايات",
    "key": "Kids Flats,Women Flats,Men Loafers",
  },
  {
    "name": "احذية رياضة",
    "key":
        "Kids Sneakers,Kids Athletic Shoes,Men Sneakers, Men Athletic Shoes,Women Sneakers, Women Athletic Shoes",
  },
  {
    "name": " Boots ",
    "key": "Kids Boots,Men Boots,Women Boots",
  },
  {
    "name": "صنادل",
    "key":
        "Kids Sandals, Men Sandals, Men Clogs, Men Flip Flops & Slides,Women Sandals, Women Clogs ",
  },
  {
    "name": " شباشب واحذية منزل",
    "key":
        "Kids Slippers,Men Clogs, Men Slippers, Men Work & Safety Shoes,Women Slippers, Women Clogs",
  },
  {
    "name": "احذية شتوية وجزمات",
    "key": "Men Outdoor Shoes,Women Fashion Boots, Women Outdoor Shoes",
  },
  {
    "name": "اكسسوارات للاحذية",
    "key": "Shoe Accessories",
  },
];

var sub_categories_Underware = [
  {
    "name": "لانجري",
    "key":
        "Women Sexy Lingerie & Costumes,Women Lingerie Accessories,Women Plus Intimates",
  },
  {
    "name": "فساتين وقمصان نوم",
    "key":
        "Women Nightgowns & Sleepshirts, Maternity Sleepwear, Women Rompers, Women Sexy Lingerie & Costumes",
  },
  {
    "name": " بجامات و روبات",
    "key": "Women Pajama Sets,Women Robes,Women Loungewear",
  },
  {
    "name": "حمالات صدر",
    "key": "Women Bras,Plus Size Bra & Panty Sets",
  },
  {
    "name": "ملابس داخلية",
    "key": "Women Panties, Women Shapewear,Plus Size Panties",
  },
  {
    "name": "جوارب نسائية ",
    "key": "Women Socks & Hosiery",
  }
];

var Underwear_Sleepwear_sizes = [
  "XS",
  "S",
  "M",
  "L",
  "XL",
  "XXL"
      "0XL",
  "1XL",
  "2XL",
  "3XL",
  "4XL",
  "5XL",
  "ONE SIZE",
];

var sub_categories_HomeLiving = [
  {
    "name": "ادوات للمطبخ",
    "key": "Kitchen & Dining, Kitchen Fixtures, Plumbing",
  },
  {
    "name": "ديكور و زينة",
    "key": "Home Decor",
  },
  {
    "name": " لوازم الحفلات والمناسبات",
    "key": "Event & Party Supplies",
  },
  {
    "name": " رفوف وادوات تخزين",
    "key": "Storage & Organization",
  },
  {
    "name": "ادوات للحمامات",
    "key": "Bathroom, Bathroom Fixtures",
  },
  {
    "name": " اساسيات المنزل و الحديقة",
    "key":
        "Home Essentials, Outdoor & Garden, Household Merchandises, Garden Tools",
  },
  {
    "name": " اضائة ومصابيح",
    "key": "Lighting & Lamp",
  },
  {
    "name": " معدات وادوات",
    "key": "Hardware,Hand Tools",
  },
];
