import Foundation

func writeWarning() {
    print("Некоректные входные данные\rПопробуйте еще раз")
    print("Введите '1' или '2'")
}

print("Добро пожаловать в 'Морской бой'\rВыберите режим:")
print("1 - Игрок против бота\r2 - Бот против бота")

func beginGame() {
    let gameMode = readLine()
    switch (gameMode) {
    case "1":
        print("Выберите соперника")
        print("1 - стандартный бот\r2 - продвинутый бот")
        func chooseBotType() {
            let botType = readLine()
            switch (botType) {
            case "1":
                standartMode(coef1: nil, coef2: nil, coef3: nil)
            case "2":
                standartMode(coef1: 7, coef2: 10, coef3: 3) // 7, 10, 3 - коэффициенты для подсчета приоритета точек на поле
            default:
                writeWarning()
                chooseBotType()
            }
        }
        chooseBotType()
    case "2":
        computerVScomputerMode()
    default:
        writeWarning()
        beginGame()
    }
}

beginGame()


