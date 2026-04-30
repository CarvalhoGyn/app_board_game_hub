import 'package:flutter_test/flutter_test.dart';
import 'package:app_board_game_hub/utils/game_data_localizer.dart';

void main() {
  group('GameDataLocalizer - Localization logic', () {
    test('Deve localizar corretamente para Português (PT)', () {
      expect(GameDataLocalizer.localize('Medieval', 'pt'), 'Medieval');
      expect(GameDataLocalizer.localize('Territory Building', 'pt'), 'Construção de Território');
      expect(GameDataLocalizer.localize('Tile Placement', 'pt'), 'Alocação de Peças');
      expect(GameDataLocalizer.localize('Worker Placement', 'pt'), 'Alocação de Trabalhadores');
    });

    test('Deve localizar corretamente para Alemão (DE)', () {
      expect(GameDataLocalizer.localize('Medieval', 'de'), 'Mittelalter');
      expect(GameDataLocalizer.localize('Economic', 'de'), 'Wirtschaft');
      expect(GameDataLocalizer.localize('Dice Rolling', 'de'), 'Würfeln');
    });

    test('Deve localizar corretamente para Francês (FR)', () {
      expect(GameDataLocalizer.localize('Medieval', 'fr'), 'Médiéval');
      expect(GameDataLocalizer.localize('Fantasy', 'fr'), 'Fantaisie');
      expect(GameDataLocalizer.localize('Party Games', 'fr'), 'Jeux d\'Ambiance');
    });

    test('Deve retornar o original se a tradução não existir (locale desconhecido)', () {
      expect(GameDataLocalizer.localize('Medieval', 'it'), 'Medieval');
    });

    test('Deve retornar o original se o termo não existir no dicionário', () {
      expect(GameDataLocalizer.localize('Sci-Fi', 'pt'), 'Sci-Fi');
    });
  });
}
