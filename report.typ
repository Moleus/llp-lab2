#import "@local/itmo-report:1.0.0": *
#import "@local/typst-boxes:1.0.0": stickybox

#show: project.with(
  subject: "Низкоуровневое программирование",
  title: "Лабораторная работа №2",
  student: "Соловьев П.А.",
  group: "P33302",
  teacher: "Кореньков Ю.Д.",
)

#set heading(numbering: none)
#let img = (path, caption) => figure(
  image(path),
  caption: caption,
  )

= Цель
Реализовать модуль для разбора некоторого достаточного подмножества языка запросов
по выбору в соответствии с вариантом формы данных.

= Задачи
+ Изучить выбранное средство синтаксического анализа.
+ Изучить синтаксис языка запросов и записать спецификацию для средства синтаксического анализа.
+ Реализовать модуль, использующий средство синтаксического анализа для разбора языка запросов.
+ Реализовать тестовую программу для демонстрации работоспособности созданного модуля, принимающую на стандартный ввод текст запроса и выводящую на стандартный вывод результирующее дерево разбора или сообщение об ошибке.

= Исходный код проекта
#link("https://github.com/Moleus/llp-lab2")

= Описание работы
Программа реализована на языке C и представляет собой cli приложение, которое принимает в стандартных вход запрос и выводит его дерево разбора.

Программа состоит из следующих модулей:
- parser.y - описание грамматики языка запросов на языке Bison
- lexer.l - описание лексического анализатора на языке Flex
- main.c - точка входа в программу
- types - описание типов данных, используемых в программе и вспомогательных функций для работы с ними

Примеры запуска программы:
#img("images/filter-by-attribute.png", "Вывод элемента, у которого значение атрибута x = 1")

#stodo("Добавить примеры запуска программы")

= Аспекты реализации
Для реализации в синтаксис XPath были добавлены указания операций добавления и удаления, чтобы была возможность изменять элементы в документном дереве. Поддерживаемые функции: `create()` - создание элемента, `delete()` - удаление элемента, `update()` - обновление элемента.

== Описание структур данных:
Основной структурой является `Element`, она хранит в себе значение и тип элемента, и представляет собой элемент дерева. Тип элемента может быть одним из следующих: `int`, `bool`, `string`, `double`.
#img("images/structs-element.png", "Структура Element")

За хранение информации о фильтрах отвечают структуры `Filter`, `FilterExpr`, `FilterTarget`. Есть несколько вариаций фильтрующих выражений, они заданы в перечислении `FilterExprType`. Таким образом поддерживается фильтрация через сравнение, по конкретному значению или по названию поля в узле.
#img("images/structs-filters.png", "Структуры для хранения информации о фильтрах")

Сама древовидная структура представлена структурой `Node`, которая реализует связный список из элементов и применяемых к ним фильтров.


== Анализ использования памяти
все аллокации на куче осуществляются через ф-ию `my_malloc`, которая считает суммарное кол-во аллоцируемой памяти.
#img("images/mem-usage-func.png", "Функция my_malloc")

#img("images/mem-usage.png", "Анализ использования памяти")
Программа использует оперативную память только для хранения структуры, и под каждое название переменной выделяется фиксированное кол-во байт.

== Токены и Грамматика
#img("images/tokens-flex.png", "Пример токенов в лексическом анализаторе")

#img("images/grammar-bison-example.png", "Пример грамматики на Bison")


== Выводы
В ходе выполнения лабораторной работы изучены Bison и Flex, а также был реализован модуль для разбора запросов XPath.
