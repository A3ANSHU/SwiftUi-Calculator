//
//  ContentView.swift
//  calculator
//
//  Created by ABHINANDAN AMBEKAR on 20/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var firstNumber: Double?
    @State private var currentOperation: String?

    var body: some View {
        VStack {
            Spacer()
            Text(display)
                .font(.system(size: 50))
                .padding(.horizontal , 30)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.white)  // Text color set to white

            VStack(spacing: 12) {
                HStack {
                    CalculatorButton(title: "C", color: .orange, action: clear)
                    CalculatorButton(icon: "delete.left", color: .orange, action: back)// Back/Delete Icon
                    CalculatorButton(icon: "percent", color: .orange, action: percent)// Back/Delete Icon
                    CalculatorButton(icon: "divide", color: .orange, action: { self.setOperation("/") })  // Division Icon percent
                }
                HStack {
                    CalculatorButton(title: "7", action: { self.inputDigit("7") })
                    CalculatorButton(title: "8", action: { self.inputDigit("8") })
                    CalculatorButton(title: "9", action: { self.inputDigit("9") })
                    CalculatorButton(icon: "multiply", color: .orange, action: { self.setOperation("*") })  // Multiplication Icon
                }
                HStack {
                    CalculatorButton(title: "4", action: { self.inputDigit("4") })
                    CalculatorButton(title: "5", action: { self.inputDigit("5") })
                    CalculatorButton(title: "6", action: { self.inputDigit("6") })
                    CalculatorButton(title: "-", color: .orange, action: { self.setOperation("-") })
                }
                HStack {
                    CalculatorButton(title: "1", action: { self.inputDigit("1") })
                    CalculatorButton(title: "2", action: { self.inputDigit("2") })
                    CalculatorButton(title: "3", action: { self.inputDigit("3") })
                    CalculatorButton(title: "+", color: .orange, action: { self.setOperation("+") })
                }
                HStack {
                    CalculatorButton(title: "0", size:2 , action: { self.inputDigit("0") })
                    CalculatorButton(title: ".", action: { self.inputDigit(".") })
                    CalculatorButton(title: "=", color: .green, action: calculateResult)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.black)
    }

    // MARK: - Functions

    private func inputDigit(_ digit: String) {
        // If the display is currently "0" and the digit is not ".", replace it
        if display == "0" {
            if digit == "." {
                display += digit  // Allow a decimal point
            } else {
                display = digit  // Replace "0" with the digit
            }
        } else if digit == "." {
            if !display.contains(".") {
                display += digit
            }
        } else {
            display += digit
        }
    }


    private func setOperation(_ operation: String) {
        firstNumber = Double(display)
        currentOperation = operation
        display = "0"
    }

    private func calculateResult() {
        guard let firstNum = firstNumber, let operation = currentOperation,
              let secondNum = Double(display) else { return }

        var result: Double?

        switch operation {
        case "+":
            result = firstNum + secondNum
        case "-":
            result = firstNum - secondNum
        case "*":
            result = firstNum * secondNum
        case "/":
            result = secondNum != 0 ? firstNum / secondNum : nil
        default:
            break
        }

        if let result = result {
            // Check if the result is a whole number
            if result.truncatingRemainder(dividingBy: 1) == 0 {
                display = String(Int(result))  // Show as an integer
            } else {
                display = String(result)  // Show as a double
            }
        } else {
            display = "Error"  // Handle division by zero or other errors
        }

        firstNumber = nil
        currentOperation = nil
    }

    private func clear() {
        display = "0"
        firstNumber = nil
        currentOperation = nil
    }
    
    private func percent() {
        guard let number = Double(display) else { return }

        let percentageValue = number / 100
        if percentageValue.truncatingRemainder(dividingBy: 1) == 0 {
            display = String(Int(percentageValue))  // Show as an integer if it's a whole number
        } else {
            display = String(percentageValue)  // Show as a double
        }

        firstNumber = nil  // Reset the first number
        currentOperation = nil  // Reset the operation
    }
    
    private func back() {
        if !display.isEmpty {
            display.removeLast()  // Remove the last character

            if display.isEmpty {  // If the display becomes empty, set it back to "0"
                display = "0"
            }
        }
    }

}

// MARK: - Button View

struct CalculatorButton: View {
    let title: String?
    let icon: String?
    let size: Int?
    let color: Color?
    let action: () -> Void

    init(title: String? = nil, icon: String? = nil, color: Color? = .gray,size: Int? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            if let icon = icon {
                Image(systemName: icon)  // Use SF Symbol Icon
                    .font(.title)
                    .frame(width: 80, height: 80)
                    .background(color ?? Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(35)
                    .shadow(radius: 5)
            } else if let title = title {
                Text(title)
                    .font(.title)
                    .frame(width: size != 2 ? 80 : 165 , height: 80)
                    .background(color ?? Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(35)
                    .shadow(radius: 5)
            }
        }
    }
}
#Preview {
    ContentView()
}
