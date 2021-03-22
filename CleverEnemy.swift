import Foundation

class CleverEnemy : Enemy {
    var c: Int
    
    init(a: Int, b: Int, c: Int) {
        var map = [[Int]]()
        for y in 0...9 {
            var row = [Int]()
            for x in 0...9 {
                row.append((a * x + b * y) % c)
            }
            map.append(row)
        }
        super.points = map
        self.c = c
    }
    
    override func increasePointPriority(x: Int, y: Int, field: Field) {
        if x <= 9 && x >= 0 && y <= 9 && y >= 0 && (field.getSymbol(x: x, y: y) == " " || field.getSymbol(x: x, y: y) == "#") {
            super.points[y][x] += self.c + 1
        }
    }
}
