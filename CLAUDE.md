# PROTOZEA ALPHA

2D-игра про клетку: ешь планктон, побеждай хищников в автобою, эволюционируй.
Победа — съесть `EnemyManager.predators_to_win` хищников (15), поражение — смерть игрока.

## Движок и проверки

- Godot **4.6**, рендер GL Compatibility, статически типизированный GDScript.
  Работаем по скиллу `godot-4-gdscript`.
- Исполняемый файл Godot здесь называется `godot`; если в системе он другой, подставьте свой путь.
- Перед коммитом:
  ```bash
  godot --headless --path . --editor --quit                      # импорт (новые class_name, CSV)
  godot --headless --path . --fixed-fps 60 -s res://tests/regression_test.gd   # тесты
  godot --headless --path . res://Assets/Scenes/Main/MainScene.tscn --fixed-fps 60 --quit-after 3600
  ```
  Тесты зелёные — это `RESULT: 0 failed` **и** ни одного `SCRIPT ERROR` в выводе.
- Скриншоты экранов (нужен рендер, в контейнере — Xvfb):
  `SHOTS_DIR=/tmp/shots xvfb-run -a -s "-screen 0 1280x720x24" godot --path . --rendering-driver opengl3 --fixed-fps 60 -s res://tests/screenshots.gd`
- В `project.godot` нетипизированные объявления и `:=` — ошибки разбора, unsafe-доступ — предупреждения.
- Подключение сигнала в `.tscn` к несуществующему методу Godot 4.6 молча игнорирует.
  После переименования методов проверяйте, что каждый `method="..."` из сцен есть в скриптах.

## Где что

- `MainScene` — корень композиции: раздаёт зависимости (`setup(...)`), ставит паузу (`get_tree().paused`, Esc).
- `EventBus` (автолоад) — сигналы между системами: бой, деньги, эволюция, победа.
- Клетки: `CellBody` (движение + спрайт) → `BaseCell` (статы, здоровье, автобой) → `PlayerCell`, `EnemyCell`.
  Планктон `SimpleEnemyCell` — сразу `CellBody`, без статов.
- Компоненты в `Assets/Scripts/Template`: `BaseCell*Component`, `WanderMovementComponent` (блуждание врагов).
- `EnemyManager` — спавн (статы хищников не выше среднего стата игрока, безопасный радиус), счёт съеденных, победа.
- `AutoBattleHandler` — начало и конец боя; `BattleAreaContact` у игрока запускает бой при касании.
- `PlayerEvolveComponent` — можно ли эволюционировать (`can_evolve_changed`), оплата по E, конец эволюции после финальной карточки.
- Баланс: `Assets/Resources/CellResources/CellBalance.tres` (`CellBalanceConfig`) — формулы урона, здоровья, защиты,
  скорости, выносливости, диапазон статов, размер. Числа баланса в скрипты не пишем.
- Настройки игрока: `GameSettings` → `user://settings.cfg` (громкость шин, язык).
- Переводы: `Assets/Translation/TEST_TRANSLATION.csv` (разделитель `;`, UTF-8 с BOM).
  Файлы `.translation` генерирует импорт Godot — после правки CSV их тоже коммитим.
  Подсказки с клавишами берут имена из Input Map через `InputHints`.

## Нельзя / осторожно

- Файлы `.import` и папку `.godot/` руками не правим. При переименовании ассета переносим его вместе с `.import`
  и запускаем импорт — Godot сам перепишет пути, uid сохранится.
- Не выдумываем `uid` в сценах и ресурсах: новые узлы и ресурсы без `uid`, Godot проставит при сохранении.
- Тест настроек пишет в `user://settings.cfg` и в конце возвращает файл и язык как было.

## Что требует редактора или арта

- Спрайты клеток уменьшены в 5–10 раз без mipmaps — при движении мерцают. В Import dock для
  `Assets/Sprites/Entities/**` включить Mipmaps → Generate и Reimport (руками `.import` не трогаем).
- Звука в проекте нет: шины Master/Music/SFX и ползунки есть, аудиофайлов и плееров нет.
- Иконка денег в HUD (`PlayerMoneyUI` → `TextureRect`) пустая — нужна картинка.
- Нарисован, но ещё не подключён арт: `score_bar_icon.png` (полоса HUD), `trash_1/2.png`, кнопки `menu_butt_1/2/4_*`,
  иконки карточек `*_click.png`, `particle_1–4.png`, `arrow_icon.png`, `sound_icon_off.png`.
- Нет `export_presets.cfg` — платформы экспорта не выбраны.
