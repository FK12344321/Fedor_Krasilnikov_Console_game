import Foundation

class Enemy {
    var points = [[Int]]() // переменная, сохраняющая приоритет точек на поле
    var maxFieldPriority: Int
    
    init() {
        // инициализация стандартного бота
        self.maxFieldPriority = 1
        for _ in 0...9 {
            var row = [Int]()
            for _ in 0...9 {
                row.append(1)
            }
            points.append(row)
        }
    }
    
    init(a: Int, b: Int, c: Int) {
        // инициализация продвинутого бота
        self.maxFieldPriority = c + 1
        for y in 0...9 {
            var row = [Int]()
            for x in 0...9 {
                row.append((a * x + b * y) % c)
            }
            points.append(row)
        }
    }
    
    func increasePointPriority(x: Int, y: Int, field: Field) {
        if x <= 9 && x >= 0 && y <= 9 && y >= 0 && (field.getSymbol(x: x, y: y) == " " || field.getSymbol(x: x, y: y) == "#") {
            points[y][x] += maxFieldPriority
        }
    }
    
    func decreasePointPriority(x: Int, y: Int) {
        if x <= 9 && x >= 0 && y <= 9 && y >= 0 {
            points[y][x] = -1
        }
    }
    
    func makeMove(opponentField: Field) {
        var max = 0
        struct Point {
            var x: Int
            var y: Int
            var priority: Int
        }
        var maxPriorityPoints = [Point]()
        for y in 0...9 {
            for x in 0...9 {
                let point = Point(x: x, y: y, priority: points[y][x])
                if points[y][x] > max {
                    max = points[y][x]
                    maxPriorityPoints = [Point]()
                    maxPriorityPoints.append(point)
                }
                else if points[y][x] == max {
                    maxPriorityPoints.append(point)
                }
            }
        }
        
        if maxPriorityPoints.count == 0 {
            return
        }
        let target = maxPriorityPoints[Int(arc4random_uniform(UInt32(maxPriorityPoints.count)))]
        opponentField.shoot(x: target.x, y: target.y)
        for y in 0...9 {
            for x in 0...9 {
                if opponentField.getSymbol(x: x, y: y) != " " && opponentField.getSymbol(x: x, y: y) != "#" {
                    points[y][x] = -1
                }
                if opponentField.getSymbol(x: x, y: y) == "@" {
                    // первые 4 опции отвечают за случаи, когда рядом с попаданием уже было одно попадание
                    if opponentField.getSymbol(x: x + 1, y: y) == "@" {
                        decreasePointPriority(x: x + 1, y: y + 1)
                        decreasePointPriority(x: x + 1, y: y - 1)
                        increasePointPriority(x: x - 1, y: y, field: opponentField)
                    }
                    else if opponentField.getSymbol(x: x - 1, y: y) == "@" {
                        decreasePointPriority(x: x - 1, y: y + 1)
                        decreasePointPriority(x: x - 1, y: y - 1)
                        increasePointPriority(x: x + 1, y: y, field: opponentField)
                    }
                    else if opponentField.getSymbol(x: x, y: y + 1) == "@" {
                        decreasePointPriority(x: x + 1, y: y + 1)
                        decreasePointPriority(x: x - 1, y: y + 1)
                        increasePointPriority(x: x, y: y - 1, field: opponentField)
                    }
                    else if opponentField.getSymbol(x: x, y: y - 1) == "@" {
                        decreasePointPriority(x: x + 1, y: y - 1)
                        decreasePointPriority(x: x - 1, y: y - 1)
                        increasePointPriority(x: x, y: y + 1, field: opponentField)
                    }
                    else {
                        increasePointPriority(x: x + 1, y: y, field: opponentField)
                        increasePointPriority(x: x, y: y + 1, field: opponentField)
                        increasePointPriority(x: x - 1, y: y, field: opponentField)
                        increasePointPriority(x: x, y: y - 1, field: opponentField)
                    }
                }
            }
        }
    }
}
