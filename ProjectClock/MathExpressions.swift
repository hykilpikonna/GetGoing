//
//  MathExpressions.swift
//  ProjectClock
//
// Puzzles to complete for task (math or RPS)
//
//CREDITS: user:2538939 ("Code Different) on Stack Exchange for MathElement enum and MathExpression class on Mar 31 '17

import Foundation

// CREDITS: user:2538939 on Stack Exchange
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

// CREDITS: user:2538939 on Stack Exchange
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
    
    var result : Int? {
        let format = "\(lhs.nsExpressionFormatString) \(op.rawValue) \(rhs.nsExpressionFormatString)"
        let expr = NSExpression(format: format)
        return expr.expressionValue(with: nil, context: nil) as? Int
    }
    
    static func random() -> MathExpression {
        let lhs = MathElement.Integer(value: Int(arc4random_uniform(10)))
        let rhs = MathElement.Integer(value: Int(arc4random_uniform(10)))
        
        return MathExpression(lhs: lhs, rhs: rhs, op: .random())
    }
}

/**
 Generate simple problem - 2 expressions
 */
class AlgProb2  : MathExpression {
    let a = MathExpression.random()
    let b = MathExpression.random()
    
    func getProblem() -> String {
        return "\(a) + \(b)"
    }
    
    func getAnswer() -> String {
        return "\(a.result! + b.result!)"
    }
}

/**
 Generate simple problem - 3 expressions
 */
class AlgProb3  : MathExpression {
    let a = MathExpression.random()
    let b = MathExpression.random()
    let c = MathExpression.random()
    
    func getProblem() -> String {
        return "\(a) + \(b) + \(c)"
    }
    
    func getAnswer() -> String {
        return "\(a.result! + b.result! + c.result!)"
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
        
        return "x^2 + \(b) + \(c)"
    }
    
    /**
     Finds the roots of the quadratic **NOTE**: the return type is [Int], not a String
     */
    func  getAnswer() -> [Int] {
        return [root1, root2]
    }
}

class RPS {
    //@IBOutlet weak var resultsLabel: UILabel!
    
    enum Choice: String {
        case rock = "ROCK"
        case paper = "PAPER"
        case scissors = "SCISSORS"
        
        static func randomComputerChoice() -> Choice {
            let choices: [Choice] = [.rock, .paper, .scissors]
            return choices[Int.random(in: 0...2)]
        }
    }
    
    /*
    @IBAction func rock(_ sender: UIButton) {
        let computerChoice = Choice.randomComputerChoice()
        resultsLabel.text = playRPS(you: .rock, computer: computerChoice)
    }

    @IBAction func paper(_ sender: UIButton) {
        let computerChoice = Choice.randomComputerChoice()
        resultsLabel.text = playRPS(you: .paper, computer: computerChoice)
    }

    @IBAction func scissors(_ sender: UIButton) {
        let computerChoice = Choice.randomComputerChoice()
        resultsLabel.text = playRPS(you: .scissors, computer: computerChoice)
    }
     */
    
    func playRPS(you: Choice, computer: Choice) -> String {
        if you == computer { return "It's a tie... GO AGAIN!" }
        else if you == .rock && computer == .scissors { return "You smashed it!" }
        else if you == .paper && computer == .rock { return "We still don't know how you won..." }
        else if you == .scissors && computer == .paper { return "You are Dwayne 'The Scissors' Johnson!" }
        else {
            let randomNum = Int.random(in: 0...2)
            if randomNum == 0 { return "Machines win again." }
            else if randomNum == 1 { return "Go back to robotics!" }
            else { return "Are you even taking this seriously???" }
        }
    }
}
