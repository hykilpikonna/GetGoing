//
//  MathExpressions.swift
//  ProjectClock
//
// Class that will generate a simple math expression

import Foundation

enum MathElement : CustomStringConvertible {
    case Integer(value: Int)
    case Percentage(value: Int)
    case Expression(expression: MathExpression)

    var description: String {
        switch self {
        case .Integer(let value): return "\(value)"
        case .Percentage(let percentage): return "\(percentage)%"
        case .Expression(let expr): return expr.description
        }
    }

    var nsExpressionFormatString : String {
        switch self {
        case .Integer(let value): return "\(value).0"
        case .Percentage(let percentage): return "\(Double(percentage) / 100)"
        case .Expression(let expr): return "(\(expr.description))"
        }
    }
}

enum MathOperator : String {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divide = "/"
    case power = "**"

    static func random() -> MathOperator {
        let allMathOperators: [MathOperator] = [.plus, .minus, .multiply, .divide, .power]
        let index = Int(arc4random_uniform(UInt32(allMathOperators.count)))

        return allMathOperators[index]
    }
}

class MathExpression : CustomStringConvertible {
    var lhs: MathElement
    var rhs: MathElement
    var `operator`: MathOperator

    init(lhs: MathElement, rhs: MathElement, operator: MathOperator) {
        self.lhs = lhs
        self.rhs = rhs
        self.operator = `operator`
    }

    var description: String {
        var leftString = ""
        var rightString = ""

        if case .Expression(_) = lhs {
            leftString = "(\(lhs))"
        } else {
            leftString = lhs.description
        }
        if case .Expression(_) = rhs {
            rightString = "(\(rhs))"
        } else {
            rightString = rhs.description
        }

        return "\(leftString) \(self.operator.rawValue) \(rightString)"
    }

    var result : Int? {
        let format = "\(lhs.nsExpressionFormatString) \(`operator`.rawValue) \(rhs.nsExpressionFormatString)"
        let expr = NSExpression(format: format)
        return expr.expressionValue(with: nil, context: nil) as? Int
    }

    static func random() -> MathExpression {
        let lhs = MathElement.Integer(value: Int(arc4random_uniform(10)))
        let rhs = MathElement.Integer(value: Int(arc4random_uniform(10)))

        return MathExpression(lhs: lhs, rhs: rhs, operator: .random())
    }
}

//WARNING: This code is ugly, and probably out of place...but it works!
// Simple Problem - 2 expressions
class AlgProb2  : MathExpression{
let a = MathExpression.random()
let b = MathExpression.random()


    func getProblem() -> String {
        let problem = ("\(a) + \(b)")
        return problem
    }
    func getAnswer() -> String {
        let answer = "\(a.result! + b.result!)"
        return answer
    }
}
// Simple Problem - 3 expressions
class AlgProb3  : MathExpression{
let a = MathExpression.random()
let b = MathExpression.random()
let c = MathExpression.random()

    func getProblem() -> String {
        let problem = ("\(a) + \(b) + \(c)")
        return problem
    }
    func getAnswer() -> String {
        let answer = "\(a.result! + b.result! + c.result!)"
        return answer
    }
}


class quadraticProb{
    
    let a = Int.random(in: 1...10)//ax^2
    let b = Int.random(in: 1...10)//bx
    let c = Int.random(in: 1...10)//c
    var roots = [Int]()

    
    func getProblem() -> String{
         return "\(a)x^2 + \(b)x + \(c)"
    }

    //finds the roots of the quadratic **NOTE**: the return type is [Int], not a String
    func  getAnswer() -> [Int]{
        let d = Int(pow(Double(b), 2) - 4 * Double(a) * Double(c)) // discriminant
       
        // if d>0 , equation has two distinct real roots exist.
        if d > 0 {
            let x1 = Int((-Double(b) + sqrt(Double(d)))/(2*Double(a)))
            let x2 = Int((-Double(b) - sqrt(Double(d)))/(2*Double(a)))
            roots = [x1, x2]
        }
        //if d=0, equation has two repeated real roots.
        else if d == 0 {
            let x = Int(-Double(b)/(2*Double(a)))
            roots = [x]
        }
        //    if d<0 equation has two complex roots, but idk how to calculate that by hand, so we'll return nothing
        else if d < 0 {
            roots = []
        }
        return roots
    }
}
