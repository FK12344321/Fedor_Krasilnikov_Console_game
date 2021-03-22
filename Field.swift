import Foundation

class Field {
    // класс описывающий игровое поле
    enum State {
        case FREE, TAKEN, NOT_AVAILABLE
    }
    
    struct Cell {
        // клетка на поле, сохраняющая информацию о состоянии точки, был ли произведен в нее выстрел и какой корабль на ней находится
        var state: State = State.FREE
        var shot = false
        var symbol: Character = " "
        var ship: Ship?
    }
    
    var field = [[Cell]]()
    var shipCount: Int
    
    init() {
        self.shipCount = 10
        for _ in 1...10 {
            var row = [Cell]()
            for _ in 1...10 {
                row.append(Cell())
            }
            self.field.append(row)
        }
        // расставление кораблей
        for i in 1...4 {
            let shipLength = 5 - i
            for _ in 1...(5-shipLength) {
                struct Points {
                    var x0: Int, y0: Int, x1: Int, y1: Int
                }
                var possiblePoints = [Points]()
                for y in 0...9 {
                    for x in 0...9 {
                        if self.field[x][y].state != State.FREE {
                            continue
                        }
                        for direction in 1...2 {
                            var nextX = x
                            var nextY = y
                            if direction == 1 && (x + shipLength - 1 > 9 || x + shipLength - 1 < 0) {
                                continue
                            }
                            if direction == 2 && (y + shipLength - 1 > 9 || y + shipLength - 1 < 0) {
                                continue
                            }
                            if direction == 2 && shipLength == 1 {
                                break
                            }
                            for cur in 1...shipLength {
                                if self.field[nextX][nextY].state != State.FREE {
                                    break
                                }
                                if cur == shipLength {
                                    let points = Points(x0: x, y0: y, x1: nextX, y1: nextY)
                                    possiblePoints.append(points)
                                }
                                if direction == 1 {
                                    nextX += 1
                                }
                                else {
                                    nextY += 1
                                }
                            }
                        }
                    }
                }
                if possiblePoints.count == 0 {
                    return
                }
                let points = possiblePoints[Int(arc4random_uniform(UInt32(possiblePoints.count)))]
                _ = Ship(beginPointX: points.x0, beginPointY: points.y0, endPointX: points.x1, endPointY: points.y1, field: self)
            }
        }
    }
    
    func map(x: Int, y: Int, ship: Ship) {
        // функция, отмечающая корабль на поле
        self.field[x][y].state = State.TAKEN
        self.field[x][y].ship = ship
        self.field[x][y].symbol = "#"
    }
    
    func markShot(x: Int, y: Int) {
        // функция, отмечающая попадание по кораблю
        if (x > 9 || x < 0 || y > 9 || y < 0) {
            return
        }
        self.field[x][y].shot = true
        if self.field[x][y].symbol != "@" {
            self.field[x][y].symbol = "X"
        }
    }
    
    func markNotAvailable(x: Int, y: Int) {
        // функция обозначает клетку как недоступную для стрельбы
        if (x > 9 || x < 0 || y > 9 || y < 0) {
            return
        }
        if self.field[x][y].state == State.FREE {
            self.field[x][y].state = State.NOT_AVAILABLE
        }
    }
    
    func fire(x: Int, y: Int) {
        // функция выстрела по полю 
        self.field[y][x].shot = true
        if self.field[y][x].state == State.TAKEN {
            self.field[y][x].symbol = "@"
            self.field[y][x].ship!.hit(x: x, y: y, field: self)
        }
        else {
            self.field[y][x].symbol = "*"
        }
    }
    
    func shoot(letter: Character, number: Int) {
        let dict : [Character:Int] = ["a": 0, "b": 1, "c": 2, "d": 3, "e": 4, "f": 5, "g": 6, "h": 7, "i": 8, "j": 9]
        let x = dict[letter]!
        let y = number - 1
        fire(x: x, y: y)
    }
    
    func shoot(x: Int, y: Int) {
        fire(x: x, y: y)
    }
    
    func drawField(showShips: Bool) {
        print("   a b c d e f g h i j")
        for y in 0...9 {
            var row = " "
            if y == 9 {
                row = ""
            } 
            row += "\(y + 1) "
            for x in 0...9 {
                var char: Character
                char = showShips || self.field[y][x].symbol != "#" ? self.field[y][x].symbol : " "
                row.append(char)
                row += " "
            }
            print(row)
        }
    }
    
    func reduceShipCount() {
        self.shipCount -= 1
    }
    
    func getSymbol(x: Int, y: Int) -> Character {
        if (x > 9 || x < 0 || y > 9 || y < 0) {
            return "-"
        }
        return self.field[y][x].symbol
    }
    
    func getShipCount() -> Int {
        return self.shipCount
    }
}
