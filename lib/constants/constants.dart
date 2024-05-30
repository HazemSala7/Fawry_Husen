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
    "main_category": "Women Apparel, Baby",
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
    "main_category": "Underwear & Sleepwear, Underwear Sleepwear",
    "icon": "assets/categories_icons/bikini.png"
  },
  {
    "name": "للمنزل",
    "image": "assets/images/Homecat.jpg",
    "main_category":
        "Home & Living, Home Living, Home Textile,Tools & Home Improvement",
    "icon": "assets/categories_icons/house.png"
  },
  {
    "name": "مجوهرات و ساعات",
    "image": "assets/images/Jwelerycat.jpg",
    "main_category": "Jewelry %26 Watches, Jewelry  Watches",
    "icon": "assets/categories_icons/jewelry.png"
  },
  {
    "name": "اكسسوارات",
    "image": "assets/images/ALanding.jpg",
    "main_category": "Apparel Accessories",
    "icon": "assets/categories_icons/bags.png"
  },
  {
    "name": "مستلزمات سيارات",
    "image": "assets/images/carcat.jpg",
    "main_category": "Automotive",
    "icon": "assets/categories_icons/car.png"
  },
  {
    "name": "للحيوانات الاليفة",
    "image": "assets/images/Petcat.jpg",
    "main_category": "Pet Supplies",
    "icon": "assets/categories_icons/rabbit.png"
  },
  {
    "name": "مستلزمات مكاتب",
    "image": "assets/images/Officecat.jpg",
    "main_category": "Office School Supplies, Office %26 School Supplies",
    "icon": "assets/categories_icons/worker.png"
  },
  {
    "name": "مستحضرات تجميلية",
    "image": "assets/images/Beautycat.jpg",
    "main_category": "Beauty %26 Health, Jewelry %26 Watches",
    "icon": "assets/categories_icons/cosmetics.png"
  },
  {
    "name": "الكترونيات",
    "image": "assets/images/ElectCat.jpg",
    "main_category": "Electronics",
    "icon": "assets/categories_icons/responsive.png"
  },
  {
    "name": "حقائب",
    "image": "assets/images/Bagcat.jpg",
    "main_category": "Bags %26 Luggage, Bags %26 Luggage",
    "icon": "assets/categories_icons/travel.png"
  },
  {
    "name": "مستلزمات اعراس",
    "image": "assets/images/Weddingcat.jpg",
    "main_category": "Weddings %26 Events, Weddings %26 Events",
    "icon": "assets/categories_icons/wedding-arch.png"
  },
  {
    "name": "مستلزمات رياضية",
    "image": "assets/images/Sportcat.jpg",
    "main_category": "Sports %26 Outdoor, Sports  Outdoor",
    "icon": "assets/categories_icons/dumbbell.png"
  },
];
//the main cat will be "Men Apparel"
var sub_categories_Men__sizes = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "بلايز",
    "key": "Men Tops, Men Plus Size Tops, Men Active Tops, Men Outdoor Apparel",
  },
  {
    "name": "تنسيقات واطقم",
    "key":
        "Men Co-ords, Men Co ords, Men Plus Size Co-ords, Men Plus Size Co ords,Men Active Sets, Men Outdoor Apparel",
  },
  {
    "name": "هوديز",
    "key":
        "Men Hoodies %26 Sweatshirts, Men Hoodies Sweatshirts, Men Plus Size Hoodies & Sweatshirts, Men Plus Size Hoodies Sweatshirts",
  },
  {
    "name": "ملابس سفلية",
    "key":
        "Men Bottoms, Men Plus Size Bottoms, Men Active Bottoms, Plus Size Sports Bottoms",
  },
  {
    "name": "ملابس خارجية",
    "key":
        "Men Outerwear, Men Plus Size Outerwear,Men Knitwear, Men Plus Size Knitwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Men Denim, Men Plus Size Denim",
  },
  {
    "name": "بدلات",
    "key":
        "Men Suits %26 Separates, Men Suits  Separates, Men Plus Size Suits %26 Separates",
  },
  {
    "name": "ملابس سباحة",
    "key": "Men Swimwear",
  },
  {
    "name": "ملابس رياضية",
    "key": "Sports %26 Outdoor, Sports  Outdoor",
  },
  {
    "name": "اكسسوارات",
    "key": "Apparel Accessories",
  },
  {
    "name": "مجوهرات وساعات",
    "key": "Jewelry %26 Watches, Jewelry  Watches",
  },
  {
    "name": "احذية",
    "key": "Men Shoes",
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
    "name": "ملابس خارجية",
    "key": "Women Outerwear,Women Knitwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Women Denim",
  },
  {
    "name": "بلايز نسائية",
    "key": "Women Sweatshirts,Women Knitwear",
  },
  {
    "name": "ملابس خليجية",
    "key": "Arabian Wear",
  },
  {
    "name": "تنسيقات",
    "key": "Women Co-ords, Women Co ords",
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
    "key": "Women Jumpsuits %26 Bodysuits, Women Jumpsuits Bodysuits",
  },
  {
    "name": "ملابس علوية",
    "key":
        "Women Tops, Blouses %26 Tee,  Blouses  Tee, Women Blouses, Women T Shirts, Women Tank Tops Camis",
  },
  {
    "name": "ملابس علوية",
    "key": "Women Tops,Blouses & Tee",
  },
  {
    "name": "ملابس داخلية",
    "key": "Underwear & Sleepwear, Underwear Sleepwear",
  },
  {
    "name": "اكسسوارات",
    "key": "Apparel Accessories",
  },
  {
    "name": "مجوهرات وساعات",
    "key": "Jewelry %26 Watches, Jewelry  Watches",
  },
  {
    "name": "الموضة والجمال",
    "key": "Beauty %26 Health, Jewelry %26 Watches",
  },
  {
    "name": "احذية",
    "key": "Women Shoes",
  },
  {
    "name": "ملتزمات اعراس",
    "key": "Weddings %26 Events, Weddings %26 Events",
  },
];

var sub_categories_women_plus_sizes = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "فساتين",
    "key": "Plus Size Dresses",
  },
  {
    "name": "ملابس علوية",
    "key": "Plus Size Tops،Plus Size Knitwear",
  },
  {
    "name": "ملابس سفلية",
    "key": "Plus Size Bottoms",
  },
  {
    "name": "ملابس خارجية",
    "key": "Plus Size Outerwears،Plus Size Knitwear",
  },
  {
    "name": "تنسيقات واطقم",
    "key": "Plus Size Co-Ords, Plus Size Co Ords",
  },
  {
    "name": "ملابس خليجية",
    "key": "Plus Size Arabian Wear",
  },
  {
    "name": "بلايز  نسائية",
    "key": "Plus Size Sweatshirts،Plus Size Knitwear",
  },
  {
    "name": "بدلات",
    "key": "Plus Size Suits",
  },
  {
    "name": "جمبسوت ",
    "key": "Plus Size Jumpsuits %26 Bodysuits, Plus Size Jumpsuits  Bodysuits",
  },
  {
    "name": "ملابس سباحة",
    "key": "Women Plus Beachwear",
  },
  {
    "name": "ملابس زفاف وسهرات",
    "key": "Women Plus Wedding, Women Plus Party Wear",
  },
];

var sub_categories_kids_sizes = [
  {
    "name": "جميع الأقسام",
    "key":
        "Young Boys Clothing,Tween Boys Clothing,Teen Boys Clothing,Kids Accessories, Kids Jewelry & Watches",
  },
  {
    "name": "بلايز",
    "key":
        "Young Boys Tops, Tween Boys Denim Tops, Tween Boys Tops،Young Boys Knitwear, Tween Boys Knitwear",
  },
  {
    "name": "ملابس خارجية",
    "key":
        "Young Boys Outerwear, Tween Boys Outerwear،Young Boys Knitwear, Tween Boys Knitwear",
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
    "key": "Young Boys Pajamas,Tween Boys Pajamas",
  },
  {
    "name": "بدلات",
    "key": "Young Boys Suits,Tween Boys Suits",
  },
  {
    "name": "ملابس سباحة",
    "key": "Young Boys Swimwear,Tween Boys Swimwear",
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
    "name": "جميع الأقسام",
    "key":
        "Young Girls Clothing,Tween Girls Clothing,Teen Girls Clothing,Kids Accessories, Kids Jewelry & Watches",
  },
  {
    "name": "فساتين",
    "key":
        "Young Girls Dresses, Tween Girls Dresses, Tween Girls Partywear, Young Girls Partywear,Teen Girls Dresses",
  },
  {
    "name": "تنسيقات واطقم",
    "key":
        "Young Girls Sets,Young Girls Pajamas, Tween Girls Sets, Teen Girls Sets",
  },
  {
    "name": "هوديز",
    "key":
        "Young Girls Sweatshirts, Tween Girls Sweatshirts, Teen Girls Sweatshirts",
  },
  {
    "name": "ملابس علوية",
    "key":
        "Young Girls Tops, Tween Girls Tops, Teen Girls Tops،Tween Girls Knitwear, Young Girls Knitwear",
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
        "Young Girls Bottoms, Tween Girls Denim Shorts, Tween Girls Jeans, Tween Girls Bottoms, Teen Girls Bottoms, Baby %26 Kids' Socks & Tights",
  },
  {
    "name": "ملابس نوم وبجامات",
    "key": "Tween Girls Pajamas",
  },
  {
    "name": "جمبسوت ",
    "key":
        "Young Girls Jumpsuits,Young Girls Bodysuits Jumpsuits, Tween Girls Jumpsuits, Tween Girls Bodysuits Jumpsuits, Teen Girls Jumpsuits",
  },
  {
    "name": "بجامات",
    "key": "Young Girls Pajamas, Tween Girls Pajamas",
  },
  {
    "name": "ملابس سباحة",
    "key": "Young Girls Beachwear, Tween Girls Beachwear, Teen Girls Beachwear",
  },
  {
    "name": "اقمشة جينز",
    "key": "Young Girls Denim, Tween Girls Denim",
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
    "name": "جميع الأقسام",
    "key":
        "Young Boys Clothing,Tween Boys Clothing,Teen Boys Clothing,Kids Accessories, Kids Jewelry %26 Watches",
  },
  {
    "name": "بلايز",
    "key": "Young Boys Tops, Tween Boys Denim Tops, Tween Boys Tops",
  },
  {
    "name": "ملابس خارجية",
    "key": "Young Boys Outerwear,Tween Boys Outerwear",
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
    "key": "Young Boys Pajamas,Tween Boys Pajamas",
  },
  {
    "name": "بدلات",
    "key": "Young Boys Suits,Tween Boys Suits",
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
    "name": "جميع الأقسام",
    "key": "Maternity Clothing, Baby, Maternity Plus Clothing",
  },
  {
    "name": "ملابس حجم كبير",
    "key": "Plus Size Tops",
  },
  {
    "name": "ملابس علوية",
    "key":
        "Maternity Tops, Sweaters, Nursing, Sweatshirts, Maternity Plus Clothing, Maternity Activewear, Maternity Sweatshirts, Maternity Sweaters",
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
    "key": "Maternity Suits, Maternity Two-piece Suits",
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
        "Baby Girls Jumpsuits, Baby Girls Onesies, Baby Girls Dresses,Baby Girls Denim, Baby Girls Photography Sets,  Baby Girls Tops, Baby Girls Partywear",
  },
  {
    "name": " أطقم  وتنسيقات للاطفال البنات",
    "key":
        "Baby Girls Sets, Baby Girls Knitwear, Baby Girls Pajamas, Baby Girls Photography Sets,Baby Girls Tops, Baby Girls Costumes",
  },
  {
    "name": "معاطف وجاكيتات للاطفال البنات",
    "key": "Baby Girls Outerwear",
  },
  {
    "name": "ملابس سفلية للاطفال البنات",
    "key": "Baby Girls Bottoms, Baby Girls Denim",
  },
  {
    "name": "أطقم وتنسيقات للاطفال الاولاد",
    "key":
        "Baby Boys Sets, Baby Boys Pajamas, Baby Boys Onesies,Baby Boys Clothing"
  },
  {"name": "احذية للاطفال", "key": "Baby Shoes"},
  {
    "name": "مستلزمات واكسسوارات الاطفال",
    "key": "Baby Supplies, Baby Accessories"
  },
];

var sub_categories_WomenShoes = [
  {
    "name": "جميع الأقسام",
    "key": "Women Shoes",
  },
  {
    "name": " Boots ",
    "key": "Women Boots, Women Fashion Boots",
  },
  {
    "name": "احذية كعب عالي",
    "key": "Women Pumps",
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
    "name": "احذية بنعل عالي",
    "key": "Women Wedges %26 Flatform, Women Wedges Flatform",
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
    "name": "جميع الأقسام",
    "key": "Men Shoes",
  },
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
    "key":
        "Men Sandals, Men Clogs, Men Flip Flops %26 Slides, Men Flip Flops  Slides",
  },
  {
    "name": " شباشب واحذية منزل",
    "key":
        "Men Clogs, Men Slippers, Men Work %26 Safety Shoes, Men Work Safety Shoes",
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
    "name": "جميع الأقسام",
    "key": "Kids Shoes",
  },
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
    "name": "جميع الأقسام",
    "key": "Kids Shoes, Men Shoes, Women Shoes",
  },
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
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "لانجري",
    "key":
        "Women Sexy Lingerie %26 Costumes, Lingerie Accessories, Women Plus Intimates, Women Sexy Lingerie  Costumes, Women Sexy Lingerie, Women Lingerie Accessories, Women Sexy Lingerie Costumes",
  },
  {
    "name": "فساتين وقمصان نوم",
    "key":
        "Women Nightgowns %26 Sleepshirts, Maternity Sleepwear, Rompers, Sexy Lingerie %26 Costumes, Women Nightgowns  Sleepshirts, Sexy Lingerie  Costumes, Women Plus Sleep %26Lounge, Women Sleep %26 Lounge, Women Sleep Lounge, Women Plus Sleep Lounge",
  },
  {
    "name": " بجامات و روبات",
    "key": "Women Pajama Sets,Women Robes,Women Loungewear ",
  },
  {
    "name": "حمالات صدر",
    "key": "Women Bras,Plus Size Bra %26 Panty Sets",
  },
  {
    "name": "ملابس داخلية",
    "key": "Women Panties, Shapewear, Plus Size Panties, Women Shapewear",
  },
  {
    "name": "جوارب نسائية ",
    "key": "Women Socks & Hosiery, Women Socks Hosiery",
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
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "ادوات للمطبخ",
    "key":
        "Kitchen %26 Dining, Kitchen Fixtures, Plumbing, Kitchen Dining,Household Cleaning, Household Merchandises, Kitchen Linen Sets, Tablecloths, Table Runners",
  },
  {
    "name": "ديكور و زينة",
    "key":
        "Home Decor,Arts,Crafts %26 Sewing, Bedding, Home Textile,  Table %26 Sofa Linens, Rugs %26 Carpets, Cushion Cover, Tapestry, Sofa Covers Table Linens, Sofa Covers %26 Table Linens, Decorative Pillows, Inserts, %26 Covers, Rugs Carpets, Decorative Pillows, Sofa Covers &amp; Table Linens, Tablecloths, Sheer Panels, Rugs, Table Runners, Curtains, Chair Covers, Sofa Covers, Mat, Door Curtains, Bedspread, Pillow Cases, Window Valance,Area Rugs Sets, Duvet Covers Sets, Mattress Covers %26 Grippers, Pillowcases Shams",
  },
  {
    "name": " لوازم الحفلات والمناسبات",
    "key": "Event %26 Party Supplies, Event Party Supplies",
  },
  {
    "name": " رفوف وادوات تخزين",
    "key": "Storage %26 Organization, Storage Organization, Furniture",
  },
  {
    "name": "ادوات للحمامات",
    "key": "Bathroom, Bathroom Fixtures,Household Cleaning, Rugs %26 Carpets",
  },
  {
    "name": " اساسيات المنزل و الحديقة",
    "key":
        "Home Essentials, Outdoor %26 Garden, Household Merchandises, Garden Tools, Outdoor  Garden, Household Merchandises",
  },
  {
    "name": " اضائة ومصابيح",
    "key": "Lighting %26 Lamp, Lighting  Lamp",
  },
  {
    "name": " معدات وادوات",
    "key": "Hardware, Hand Tools",
  },
];

var sub_categories_SportsOutdoor = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "بلايز رياضية للرجال",
    "key": "Men Active Tops, Men Outdoor Apparel",
  },
  {
    "name": "أطقم رياضة رجالية",
    "key": "Men Active Sets, Men Outdoor Apparel",
  },
  {
    "name": "سراويل رياضية للرجال",
    "key": "Men Active Bottoms, Plus Size Sports Bottoms",
  },
  {
    "name": "أطقم رياضة نسائية",
    "key": "Women Active Sets, Plus Size Sports Sets",
  },
  {
    "name": "ملابس علوية رياضية نسائية",
    "key": "Women Active Tops",
  },
  {
    "name": "سراويل رياضية نسائية",
    "key": "Women Active Bottoms",
  },
  {
    "name": "بوديسوت & جمبسوت رياضية نسائية",
    "key":
        "Women Sports Bodysuits %26 Jumpsuits, Women Sports Bodysuits  Jumpsuits, Sports %26 Outdoor Accessories",
  },
  {
    "name": "لانجري رياضية نسائية",
    "key":
        "Women Sports Bras & Intimates, Women Sports Bras  Intimates, Plus Size Sports Bra, Sports & Outdoor Accessories"
  },
];

var sub_categories_JewelryWatches = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": "أقراط واحلق نسائية",
    "key": "Women's Earrings, Women Earrings",
  },
  {
    "name": "قلادات وسناسيل نسائية",
    "key":
        "Women's Necklaces, Women's Brooches, Women Necklaces, Women Brooches",
  },
  {
    "name": "أساور نسائية",
    "key": "Women's Bracelets, Women Bracelets",
  },
  {
    "name": "خواتم نسائية",
    "key": "Women's Rings, Women Rings",
  },
  {
    "name": "مجوهرات قدم نسائية",
    "key": "Women's Foot Jewelry, Women Foot Jewelry",
  },
  {
    "name": "أطقم مجوهرات نسائية",
    "key":
        "Women's Jewelry Sets, Women's Body Jewelry, Body Chain, Women's Body Chains, Women Jewelry Sets, Women Body Jewelry,  Women Body Chains",
  },
  {
    "name": "ساعات نسائية",
    "key":
        "Women's Watches, Women's Watch Sets, Women's Quartz Watches, Jewelry Findings & Components, Women Watches, Women Watch Sets, Women Quartz Watches",
  },
  {
    "name": "أساور وخواتم رجالية",
    "key":
        "Men's Bracelets, Men's Rings, Men's Body Jewelry, Men's Watch Sets, Men's Quartz Watches",
  },
  {
    "name": "قلادات وسناسيل رجالية",
    "key": "Men's Necklaces, Men's Body Jewelry,Jewelry Findings & Components",
  },
];

var sub_categories_Accessories = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": " أوشحة وشالات نسائي",
    "key":
        "Women Scarves %26 Scarf Accessories, Women Scarves Scarf Accessories, Women Collar %26 Accessories,Wedding Accessories,Wedding Fashion Jewelry,Face Coverings %26 Accs, Women Collar Accessories",
  },
  {
    "name": "قبعات و قفازات نسائية",
    "key":
        "Women Hats %26 Gloves, Women Hats  Gloves, Women Hats, Women Gloves",
  },
  {
    "name": "أحزمة نسائية",
    "key":
        "Women Belts %26 Belts Accessories, Women Belts  Belts Accessories, Women Keychains & Accessories",
  },
  {
    "name": "إكسسوارات شعر نسائية   ",
    "key": "Women Hair Accessories",
  },
  {
    "name": "نظارات نسائية وإكسسوارات نظارات",
    "key":
        "Women Glasses %26 Eyewear Accessories, Women Glasses  Eyewear Accessories",
  },
  {
    "name": "احزمة واوشحة رجالية ",
    "key":
        "Men Scarves %26 Scarf Accessories,Men Keychains %26 Accessories,Men Belts %26 Belts Accessories, Men s Wallets Card Cases",
  },
  {
    "name": "نظارات شمسية رجالية ",
    "key":
        "Men Sunglasses %26 Accessories, Men Sunglasses  Accessories, Men Glasses %26 Eyewear Accessories",
  },
  {
    "name": "قبعات وقفازات رجالية",
    "key": "Men Hats %26 Gloves, Men Hats Gloves, Men Hats, Men Gloves",
  },
];

var sub_categories_BeautyHealth = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": " شعر مستعار وبواريك",
    "key":
        "Wigs %26 Accessories, Wigs  Accessories, Synthetic Hair Wigs, Hair Tools, Human Hair Wigs, Wig Caps %26 Tools, Wigs Accs, Wigs %26 Accs",
  },
  {
    "name": "إكسسوارات الاظافر ",
    "key": "Nail Art %26 Tools, Nail Art  Tools, Press On Nails",
  },
  {
    "name": "أدوات المكياج",
    "key":
        "Makeup Tools, Makeup Brushes, Makeup Bags, Body Care Tools, Face Make Up, Eye Make Up, Makeup Bag Storage",
  },
  {
    "name": "وشم وفنون الجسم",
    "key": "Tattoos %26 Body Art, Tattoos  Body Art, Body Care Tools",
  },
  {
    "name": " أدوات العناية بالجسم وبالبشرة",
    "key":
        "Body %26 Skin Care Tools, Body  Skin Care Tools, Skin Care Tools, Face Care Devices, Shaving Electric, Beauty Tools",
  },
  {
    "name": " أدوات العناية بالشعر",
    "key": "Hair Tools",
  },
  {
    "name": " أدوات العناية بالرموش",
    "key": "Eyelashes Tools, Eyelashes",
  },
];

var sub_categories_Electronics = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": " اغلفة وإكسسوارات الهاتف",
    "key":
        "Cases,Cell Phones  %26 Accessories, Phone Mounts Holders, Cable Cable Accessories, Phone Accessories",
  },
  {
    "name": "سماعات رأس وأذن",
    "key":
        "Consumer Electronic,Earphone Cases,Headphone  %26 Earphone, Portable Audio  %26 Video",
  },
  {
    "name": "أدوات كومبيوتر والمكتب",
    "key": "Computer  %26 Office",
  },
];

var sub_categories_BagsLuggage = [
  {
    "name": "جميع الأقسام",
    "key": "",
  },
  {
    "name": " حقائب يد وكتف نسائية",
    "key":
        "Women Shoulder Bags, Women Crossbody, Women Satchels, Women Tote Bags, Women Evening Bags, Women Bag Sets, Women Wristlet Bags, Women Waist Bags, Women Clutches, Women Top Handle Bags",
  },
  {
    "name": " حقائب ظهر نسائية",
    "key": "Women Backpacks",
  },
  {
    "name": "حقائب وإكسسوارات سفر ",
    "key":
        "Luggage %26 Travel Accessories, Luggage  Travel Accessories, Luggage & Travel Bags,Bag Accessories",
  },
  {
    "name": "محافظ وحاملات بطاقات",
    "key":
        "Wallets %26 Card Holders, Wallets  Card Holders, Women Evening Bags, Wallets %26 Cardholders",
  },
  {
    "name": "حقائب رجالية",
    "key": "Men Bags, Men's Bags",
  },
];
