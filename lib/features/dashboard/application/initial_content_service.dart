import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../domain/category_item.dart';
import '../domain/symbol_item.dart';

class InitialContentService {
  static const String catGeneral = 'cat_general';
  static const String catFood = 'cat_food';
  static const String catDrink = 'cat_drink';
  static const String catEmotions = 'cat_emotions';
  static const String catPronouns = 'cat_pronouns';
  static const String catAdjectives = 'cat_adjectives';
  static const String catPlaces = 'cat_places';
  static const String catTime = 'cat_time';
  static const String catActions = 'cat_actions';

  static List<CategoryItem> getInitialCategories() {
    return [
      CategoryItem(id: catGeneral, name: 'Genel', colorValue: Colors.blue.toARGB32()),
      CategoryItem(id: catFood, name: 'Yiyecek', colorValue: Colors.orange.toARGB32()),
      CategoryItem(id: catDrink, name: 'İçecek', colorValue: Colors.teal.toARGB32()),
      CategoryItem(id: catEmotions, name: 'Duygular', colorValue: Colors.purple.toARGB32()),
      CategoryItem(id: catPronouns, name: 'Kişiler', colorValue: Colors.indigo.toARGB32()),
      CategoryItem(id: catAdjectives, name: 'Sıfatlar', colorValue: Colors.amber.toARGB32()),
      CategoryItem(id: catPlaces, name: 'Mekanlar', colorValue: Colors.green.toARGB32()),
      CategoryItem(id: catTime, name: 'Zaman', colorValue: Colors.grey.toARGB32()),
      CategoryItem(id: catActions, name: 'Eylemler', colorValue: Colors.red.toARGB32()),
    ];
  }

  static List<SymbolItem> getInitialSymbols() {
    return [
      // --- BASIC LEVEL ---
      _create('Anne', Icons.face_2, Colors.pink, level: 'basic', catId: catGeneral),
      _create('Baba', Icons.face, Colors.blue, level: 'basic', catId: catGeneral),
      _create('Acıktım', Icons.restaurant, Colors.orange, level: 'basic', catId: catFood),
      _create('Susadım', Icons.local_drink, Colors.teal, level: 'basic', catId: catDrink),
      _create('İstiyorum', Icons.check_circle, Colors.green, level: 'basic', catId: catActions),
      _create('İstemiyorum', Icons.cancel, Colors.red, level: 'basic', catId: catActions),
      _create('Ver', Icons.handshake, Colors.cyan, level: 'basic', catId: catActions),
      _create('Al', Icons.download, Colors.cyan, level: 'basic', catId: catActions),
      _create('Evet', Icons.thumb_up, Colors.green, level: 'basic', catId: catGeneral),
      _create('Hayır', Icons.thumb_down, Colors.red, level: 'basic', catId: catGeneral),
      _create('Merhaba', Icons.waving_hand, Colors.yellow, level: 'basic', catId: catGeneral),
      _create('Teşekkürler', Icons.favorite, Colors.pink, level: 'basic', catId: catGeneral),

      // --- INTERMEDIATE LEVEL ---
      _create('Mutlu', Icons.sentiment_satisfied_alt, Colors.yellow, level: 'intermediate', catId: catEmotions),
      _create('Üzgün', Icons.sentiment_dissatisfied, Colors.blueGrey, level: 'intermediate', catId: catEmotions),
      _create('Kızgın', Icons.sentiment_very_dissatisfied, Colors.redAccent, level: 'intermediate', catId: catEmotions),
      _create('Korkmuş', Icons.bug_report, Colors.purple, level: 'intermediate', catId: catEmotions),
      
      _create('Ben', Icons.person, Colors.indigo, level: 'intermediate', catId: catPronouns),
      _create('Sen', Icons.person_outline, Colors.indigo, level: 'intermediate', catId: catPronouns),
      _create('O', Icons.person_off, Colors.indigo, level: 'intermediate', catId: catPronouns),
      _create('Biz', Icons.groups, Colors.indigo, level: 'intermediate', catId: catPronouns),
      _create('Siz', Icons.group, Colors.indigo, level: 'intermediate', catId: catPronouns),
      _create('Onlar', Icons.group_add, Colors.indigo, level: 'intermediate', catId: catPronouns),

      _create('Büyük', Icons.expand, Colors.amber, level: 'intermediate', catId: catAdjectives),
      _create('Küçük', Icons.compress, Colors.amber, level: 'intermediate', catId: catAdjectives),
      _create('Sıcak', Icons.wb_sunny, Colors.orange, level: 'intermediate', catId: catAdjectives),
      _create('Soğuk', Icons.ac_unit, Colors.cyan, level: 'intermediate', catId: catAdjectives),

      _create('Ev', Icons.home, Colors.green, level: 'intermediate', catId: catPlaces),
      _create('Okul', Icons.school, Colors.green, level: 'intermediate', catId: catPlaces),
      _create('Park', Icons.park, Colors.green, level: 'intermediate', catId: catPlaces),
      _create('Hastane', Icons.local_hospital, Colors.red, level: 'intermediate', catId: catPlaces),

      // --- ADVANCED LEVEL ---
      _create('Elma', Icons.api, Colors.red, level: 'advanced', catId: catFood), // Using api as placeholder apple
      _create('Muz', Icons.bedtime, Colors.yellow, level: 'advanced', catId: catFood), // Banana shape?
      _create('Ekmek', Icons.breakfast_dining, Colors.brown, level: 'advanced', catId: catFood),
      
      _create('Süt', Icons.local_cafe, Colors.white, level: 'advanced', catId: catDrink),
      _create('Su', Icons.water_drop, Colors.blue, level: 'advanced', catId: catDrink),
      _create('Meyve Suyu', Icons.local_bar, Colors.orange, level: 'advanced', catId: catDrink),

      _create('Şimdi', Icons.access_time_filled, Colors.grey, level: 'advanced', catId: catTime),
      _create('Sonra', Icons.update, Colors.grey, level: 'advanced', catId: catTime),
      _create('Sabah', Icons.wb_twilight, Colors.orangeAccent, level: 'advanced', catId: catTime),
      _create('Akşam', Icons.nights_stay, Colors.indigoAccent, level: 'advanced', catId: catTime),

      _create('Ne?', Icons.question_mark, Colors.deepPurple, level: 'advanced', catId: catGeneral),
      _create('Nerede?', Icons.map, Colors.deepPurple, level: 'advanced', catId: catGeneral),
      _create('Kim?', Icons.person_search, Colors.deepPurple, level: 'advanced', catId: catGeneral),
      _create('Neden?', Icons.psychology_alt, Colors.deepPurple, level: 'advanced', catId: catGeneral),

      _create('Oynamak', Icons.sports_esports, Colors.red, level: 'advanced', catId: catActions),
      _create('Yardım', Icons.support, Colors.red, level: 'advanced', catId: catActions),
      _create('Tuvalet', Icons.wc, Colors.blue, level: 'advanced', catId: catPlaces),
    ];
  }

  static SymbolItem _create(String label, IconData icon, Color color, {required String level, String? catId}) {
    return SymbolItem(
      id: const Uuid().v4(),
      label: label,
      iconCode: icon.codePoint,
      colorValue: color.toARGB32(),
      level: level,
      categoryId: catId,
    );
  }
}
