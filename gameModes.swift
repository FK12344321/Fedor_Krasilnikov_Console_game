import Foundation

func drawFields(field1: Field, field2: Field, message1: String, message2: String, showField1: Bool, showField2: Bool) {
    print("----------------------------")
    print(message1)
    field1.drawField(showShips: showField1)
    print("\r" + message2)
    field2.drawField(showShips: showField2)
    print("----------------------------")
}

func standartMode(coef1: Int?, coef2: Int?, coef3: Int?) {
    // стандартный режим, в котором бот играет с пользователем
    let playerField = Field()
    let enemyField = Field()
    let enemy: Enemy
    if coef1 == nil && coef2 == nil && coef3 == nil {
        enemy = Enemy()
    }
    else {
        enemy = Enemy(a: coef1!, b: coef2!, c: coef3!)
    }
    drawFields(field1: playerField, field2: enemyField, message1: "Ваше поле:", message2: "Поле противника:", showField1: true, showField2: false)
    
    repeat {
        print("Координаты вашего выстрела: ")
        let coordinates = readLine()
        let template = try? NSRegularExpression(pattern: "[a-j] [0-9]0?");
        let additionalTemplate = try? NSRegularExpression(pattern: "[a-j] 10"); // для строк длины 4
        let range = NSRange(location: 0, length: coordinates!.utf16.count)
        // проверка на коректность входных данных
        if (template!.matches(in: coordinates!, options: [], range: range).isEmpty || (coordinates!.count != 3 && coordinates!.count != 4) || (coordinates!.count == 4 && additionalTemplate!.matches(in: coordinates!, options: [], range: range).isEmpty)) {
            print("Некоректные координаты. Попробуйте еще раз")
            continue
        }
        let inputArray = Array(coordinates!)
        let letter = inputArray[0]
        var number : Int
        if coordinates!.count == 4 {
            number = 10
        }
        else {
            number = Int(String(inputArray[2]))!
        }
        let dict: [Character:Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9]
        if enemyField.getSymbol(x: dict[letter]!, y: number - 1) != " " && enemyField.getSymbol(x: dict[letter]!, y: number - 1) != "#" {
            print("Вы не можете выстрелить в эту точку")
            print("Введите другие координаты")
            continue
        }
        enemyField.shoot(letter: letter, number: number)
        enemy.makeMove(opponentField: playerField)
        drawFields(field1: playerField, field2: enemyField, message1: "Ваше поле:", message2: "Поле противника:", showField1: true, showField2: false)
        switch (playerField.getShipCount() == 0, enemyField.getShipCount() == 0) {
        case (true, true):
            print("Ничья")
        case (true, false):
            print("Вы проиграли...")
        case (false, true):
            print("Вы победили!!!")
        default :
            break
        }
    } while playerField.getShipCount() != 0 && enemyField.getShipCount() != 0
}

func computerVScomputerMode() {
    print("В этом режиме вы можете наблюдать за сражением двух ботов")
    print("Чтобы боты сделали ход просто введите любой символ или нажмите 'enter'")
    let bot1 = Enemy()
    let bot2 = Enemy()
    let field1 = Field()
    let field2 = Field()
    drawFields(field1: field1, field2: field2, message1: "Бот1:", message2: "Бот2:", showField1: true, showField2: true)
    repeat {
        _ = readLine()
        bot1.makeMove(opponentField: field2)
        bot2.makeMove(opponentField: field1)
        drawFields(field1: field1, field2: field2, message1: "Бот1:", message2: "Бот2:", showField1: true, showField2: true)
        switch (field1.getShipCount() == 0, field2.getShipCount() == 0) {
        case (true, true):
            print("Ничья")
        case (true, false):
            print("Бот2 победил")
        case (false, true):
            print("Бот1 победил")
        default :
            break
        }
    } while field1.getShipCount() != 0 && field2.getShipCount() != 0
}
