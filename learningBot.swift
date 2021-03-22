import Foundation
/*
 я использовал даннуб функцию, чтобы обучить продвинутого бота
 для выполнения программы она не нужна, но я решил оставить ее здесь
 В конечном итоге она подобрала коэффициенты, которые позволили побеждать стандартного бота 55,7% случаях и в 4,1% выходить в ничью
 (при повторной проверке на 100000 случаях), в то время как стандартный бот, играющий со стандартным ботом побеждает примерно в 47,7% случаях
 и в 4,5% выходит в ничью
*/

func findCoefficients() {
    // данная функция позволяет подобрать наилучшие коеффициенты для вычисления приоритета точек на поле
    var bestCoefficients: [Int]?
    var bestResult = 0
    var victoryRate: Double = 0
    var numVictory: Int = 0
    var numDraw: Int = 0
    // для каждого a, b и c от 1 до 10 продвинутый бот использующий фунуцию подсчета приоритетов играет со стандартным ботом 100 игр,
    // после чего определяет успешность таких коэффициентов путем анализа количество выйгранный, проигранных игр и ничьих
    for a in 1...10 {
        for b in 1...10 {
            for c in 1...10 {
                var draw = 0
                var victory = 0
                for _ in 1...100 {
                    let bot1 = Enemy(a: a, b: b, c: c)
                    let bot2 = Enemy()
                    let field1 = Field()
                    let field2 = Field()
                    repeat {
                        bot1.makeMove(opponentField: field2)
                        bot2.makeMove(opponentField: field1)
                        switch (field1.getShipCount() == 0, field2.getShipCount() == 0) {
                        case (true, true):
                            draw += 1
                        case (false, true):
                            victory += 1
                        default :
                            break
                        }
                    } while field1.getShipCount() != 0 && field2.getShipCount() != 0
                }
                if bestResult < victory * 3 + draw {
                    bestResult = 3 * victory + draw
                    bestCoefficients = [a, b, c]
                    numVictory = victory
                    numDraw = draw
                    victoryRate = Double(numVictory) / 100.0
                }
            }
        }
    }
    print(bestCoefficients!)
    print(bestResult)
    print(victoryRate)
    print(numVictory)
    print(numDraw)
}
