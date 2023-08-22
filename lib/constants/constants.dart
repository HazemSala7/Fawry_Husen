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
    "icon": "assets/categories_icons/women_big_size.png"
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
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/shoes.png"
  },
  {
    "name": "ملابس داخليه",
    "image": "assets/images/Undercat.jpg",
    "main_category": "Women Apparel",
    "icon": "assets/categories_icons/bikini.png"
  },
  {
    "name": "للمنزل",
    "image": "assets/images/Homecat.jpg",
    "main_category": "Women Apparel",
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
var sub_categories_women_appearel = [
  {
    "name": "فساتين نسائية",
    "key": "Women Dresses",
  },
  {
    "name": "قيعان النساء",
    "key": "Women Bottoms",
  },
  {
    "name": "ملابس نسائيه",
    "key": "تريكو النساء",
  },
  {
    "name": "ملابس نسائيه",
    "key": "Women Outerwear",
  },
  {
    "name": "المرأة الدينيم",
    "key": "Women Denim",
  },
  {
    "name": "بلوزات نسائية",
    "key": "Women Sweatshirts",
  },
  {
    "name": "ملابس عربية",
    "key": "Arabian Wear",
  },
  {
    "name": "المنسقات النسائية",
    "key": "Women Co-ords",
  },
  {
    "name": "زفاف النساء",
    "key": "Women Wedding",
  },
  {
    "name": "النساء بحر",
    "key": "Women Beachwear",
  },
  {
    "name": "بدلات نسائية",
    "key": "Women Suits",
  },
  {
    "name": "جمبسوت نسائية",
    "key": "Women Jumpsuits & Bodysuits",
  },
  {
    "name": "بلايز وبلوزات وقمصان نسائية",
    "key": "Women Tops,Blouses & Tee",
  },
];
