# <h1 align="center">СПИСОК ПОКУПОК</h1>

# Стек

- UI фреймворк - SwiftUI;
- Архитектура приложения: IVO;
- Swift Version - 6.0
- Работа с асинхронным кодом - async / await
- Локально хранение - SwiftData
- Минимальная версия операционной системы: iOS 17.0.
- SwiftLint 

> [!IMPORTANT]
> Для работы с проектом используется релизный **Xcode v26.0.**

# Merge requests & commits
## Ветки
Есть две ветки:

- main
- develop

> [!IMPORTANT]
> Основная работа ведется с веткой develop. От нее отводим свои ветки, в нее же и вливаем.

Префиксы при создании веток: 

- feature/
- bugfix/
- patch/
- refactor/

**Пример создания ветки фичи:** <br>
feature/фамилияИмя_что-сделал-кратко

**Пример создания ветки фикса бага:** <br>
bugfix/фамилияИмя_что-сделал-кратко

> [!IMPORTANT]
> Перед вливанием в ветку **develop**, необходимо подтянуть её в свою ветку, чтобы проверить наличие конфликтов перед слиянием. 
> При наличии конфликтов - решить их в своей ветке, проверить работу проекта и **после этого вливать в develop**.

После мерджа, ветка в которой велась работа удаляется. 
## Коммиты

Сообщения пишутся на английском языке, кратко (<120 символов), описывая изменения сделанные в коммите.

Префиксы при написании коммит сообщения: 

- [Feature] Description of the feature - NEW FEATURE
- [Patch] Description of patch - BUG IN PRODUCTION
- [Bug] Description of the bug - BUG NOT IN PRODUCTION
- [Refactor] Description of changes - DAILY TASKS AND CLEAN CODE
- [Release] Description of release - RELEASE

**Пример коммит сообщения:** <br>

- [Feature] Add sort function for the `MainView`
- [Bug] Fix crash when navigating from `MainView` to `DetailView`
- [Refactor] Move logic from `MainView` to `MainViewModel` 

# Организация файлов в проекте
Основные папки проекта: 
- `App` - Корневая структура проекта `@main` 
- `Screens` - Папки с экранами 
- `Models` - Модели объектов (Identifiable)
- `Services` - Сервисы
- `Helpers` - Хелперы 
- `Extensions` - Расширения
- `Resources` - Ассеты и прочие ресурсы проекта
- `UIElements` - UI элементы используемые по всему проекту 


Организация папки экрана:
- `экранView` - Верстка экрана
- `экранView+Observed` - Логика работы экрана (аналог ViewModel в MVVM)
- папка `Components` - элементы UI которые используются на этом экране 

Если элемент UI планируется или уже используется на других экранах - выносится в папку `UIElements`

# CodeStyle

## Перенос параметров

> [!NOTE]
> Функция, имеющая больше двух параметров переносится на новую строку

**Пример функции/модификатора с двумя параметрами :** <br>

```
func set(str: String, str: String) -> Int
```

**Пример функции с тремя и более параметрами :** <br>
```
func set(
    str: String,
    str: String,
    str: String
) -> Int
```

Модификаторы **не** нужно переносить, если они легко умещаются в одну строку и легко читаются, например `.frame()`: <br>
```
someView
    .frame(width: 250, height: 150, alignment: .leading)
```
## Перенос скобок

**Пример:** <br>
```
let model = Model(
set1,
set2
)
```

## Нейминг функций / свойств

- func get*Название*() / func fetch*Название* - Получение запроса

- func handle*Название*() - Обработка

- func map*Название*() - Маппинг из одного в другое

- func is*Название*() -> Bool - Функция, возвращающая bool

## Отступы

## Вынос констант
> [!NOTE]
> Константы выносятся в отдельный enum, кроме размерностей при верстке. 

**Пример использования перечисления:** <br>

```
enum Limits {
    static let minNameLength = 3 // Выносим минимальную длину имени. В коде используем константу
}

if name.count < Limits.minNameLength {
    ....            
}   
```
```
someView
    .frame(width: 250, height: 150) // Тут выносить размерность в константу не нужно 

```

## Inline Документация

Документацию пишем по возможности на классы / функции, но если нейминг и логика и так понятна, то документацию можно не писать.

**Пример:** <br>
```
/// Проверяет, является ли строка корректным e-mail.
/// - Parameter email: Строка для проверки.
/// - Returns: `true`, если строка соответствует формату e-mail, иначе `false`.
func isValidEmail(_ email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
}
```
> [!NOTE]
> Для добавление скелета документации -> ПКМ на классе/функции - Add documentation

## Дополнительные сведения

Использование **self** без необходимости стараемся избегать.

По возможности придерживаемся SOLID, DRY, KISS и YAGNI.	
