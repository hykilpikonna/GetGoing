//
//  MathExpressions.swift
//  ProjectClock
//
//  Puzzles to complete for task (math or RPS)
//

import Foundation
import CoreMotion

/**
 Math element for problem generation (Credit: https://stackoverflow.com/a/43132311/7346633)
 */
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

/**
 Math operator for problem generation (Credit: https://stackoverflow.com/a/43132311/7346633)
 */
enum MathOperator : String {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case power = "**"
    
    static func random() -> MathOperator {
        let allMathOperators: [MathOperator] = [.plus, .minus, .multiply, .power]
        let index = Int(arc4random_uniform(UInt32(allMathOperators.count)))
        
        return allMathOperators[index]
    }
}

/**
 Math expressions for problem generation (Credit: https://stackoverflow.com/a/43132311/7346633)
 */
class MathExpression : CustomStringConvertible {
    var lhs: MathElement
    var rhs: MathElement
    var op: MathOperator
    
    init(lhs: MathElement, rhs: MathElement, op: MathOperator) {
        self.lhs = lhs
        self.rhs = rhs
        self.op = op
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
        
        return "\(leftString) \(self.op.rawValue) \(rightString)"
    }
    
    var result: Int {
        let format = "\(lhs.nsExpressionFormatString) \(op.rawValue) \(rhs.nsExpressionFormatString)"
        let expr = NSExpression(format: format)
        let result = expr.expressionValue(with: nil, context: nil)
        return Int(round(result as! Double))
    }
    
    static func random() -> MathExpression {
        let op: MathOperator = .random()
        let lhs = MathElement.Integer(value: Int(arc4random_uniform(10)))
        let rhs = MathElement.Integer(value: Int(arc4random_uniform(op == .power ? 3 : 10)))
        
        return MathExpression(lhs: lhs, rhs: rhs, op: op)
    }
}

/**
 Generate simple problem - 2 expressions
 */
class MathExpProblem
{
    let prob: String
    let ans: Int
    
    init(size: Int)
    {
        var expressions: [String] = []
        var answer = 0
        for _ in 1...size
        {
            let exp = MathExpression.random()
            expressions.append(exp.description)
            answer += exp.result
        }
        prob = expressions.joined(separator: " + ")
        ans = answer
    }
}

/**
 Generate quadratic factorization problem
 */
class QuadraticProb {
    // Generates the roots
    let root1 = Int.random(in: 1...10)
    let root2 = Int.random(in: 1...10)
    
    /**
     Generate problem description
     */
    func getProblem() -> String {
        //a is 1
        let b = root1 + root2 //bx
        let c = root1 * root2 //x
        
        return "x^2 + \(b)x + \(c)"
    }
    
    /**
     Finds the roots of the quadratic **NOTE**: the return type is [Int], not a String
     */
    func  getAnswer() -> [Int] {
        return [root1, root2]
    }
}

/**
 Rock paper scissors
 */
class RPS
{
    static let choices: [Choice] = [.rock, .paper, .scissors]
    
    enum Choice: String
    {
        case rock = "Rock"
        case paper = "Paper"
        case scissors = "Scissors"
    }
    
    static func playRPS(you: Choice, computer: Choice) -> Bool
    {
        return you == .rock && computer == .scissors ||
            you == .paper && computer == .rock ||
            you == .scissors && computer == .paper
    }
}

/**
//Reference: https://youtu.be/XDuchXYiWuE
class Shake {
    var motionManager = CMMotionManager()
    
    func viewDidAppear(_ animated: Bool) {
        motionManager.accelerometerUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data,error) in
            if let myData = data {
                if myData.acceleration.x > 5 {
                    print("DO SOMETHING SPECIAL")
                }
            }
        }
    }
}
*/
