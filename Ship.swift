import Foundation

class Ship {
    let size: Int
    struct Point {
        let x: Int, y: Int
    }
    var location = [Point]()
    var aliveCells: Int
    
    init(beginPointX: Int, beginPointY: Int, endPointX: Int, endPointY: Int, field: Field) {
        if beginPointX == endPointX {
            let x = beginPointX
            self.size = endPointY - beginPointY + 1
            for i in beginPointY...endPointY {
                let point = Point(x: x, y: i)
                self.location.append(point)
                
            }
        }
        else {
            let y = beginPointY
            self.size = endPointX - beginPointX + 1
            for i in beginPointX...endPointX {
                let point = Point(x: i, y: y)
                self.location.append(point)
            }
        }
        self.aliveCells = self.size
        for i in location {
            for i1 in -1...1 {
                for i2 in -1...1 {
                    field.markNotAvailable(x: i.x + i1, y: i.y + i2)
                }
            }
            field.map(x: i.x, y: i.y, ship: self)
        }
    }
    
    func hit(x: Int, y: Int, field: Field) {
        // функция попадания по кораблю 
        self.aliveCells -= 1
        if self.aliveCells == 0 {
            for i in self.location {
                for i1 in -1...1 {
                    for i2 in -1...1 {
                        field.markShot(x: i.x + i1, y: i.y + i2)
                    }
                }
            }
            field.reduceShipCount()
        }
    }
}

