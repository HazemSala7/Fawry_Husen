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
List<String> kids_boys_sizes = [
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
