import AUnits
import AViewUI
import SwiftUI

#if os(iOS)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct AQuantityInputContent<Quantity: AQuantityProtocol, Unit: AUnitProtocol>: View where Quantity.UnitType == Unit, Unit.AllCases: RandomAccessCollection {
    @Binding var quantity: Quantity?
    @Binding var selectedUnit: Unit
    
    var originalUnit: Unit
    var allowInput: Bool
    var placeholder: String
    var precision: FloatingPointFormatStyle.Configuration.Precision
    
    var number: Double? {
        quantity?.converted(to: selectedUnit).value
    }
    
    func setNumber(_ newNumber: Double?) {
        guard let newNumber = newNumber else {
            quantity = nil
            return
        }
        quantity = Quantity(value: newNumber, unit: selectedUnit).converted(to: originalUnit)
    }
    
    var bindInput: Binding<Double?> {
        Binding {
            number
        } set: {
            setNumber($0)
        }
    }
    
    private func unitSelector() -> some View {
        Menu(selectedUnit.symbol) {
            ForEach(Unit.allCases, id: \.id) { unit in
                Button(unit.nameInMenu) {
                    selectedUnit = unit
                }
            }
        }
    }
    
    public var body: some View {
        if allowInput {
            TextField(placeholder, value: bindInput, format: AMathFormatStyle<Double>.precision(precision))
                .multilineTextAlignment(.trailing)
            unitSelector()
        } else {
            if let number = number {
                Spacer()
                Text("= ") + Text(number, format: .number.precision(precision))
                unitSelector()
            } else {
                Spacer()
                Text("-")
            }
        }
    }
    
    public init(_ quantity: Binding<Quantity?>, selectedUnit: Binding<Quantity.UnitType>, originalUnit: Quantity.UnitType, allowInput: Bool, placeholder: String, precision: FloatingPointFormatStyle.Configuration.Precision) {
        _quantity = quantity
        _selectedUnit = selectedUnit
        self.originalUnit = originalUnit
        self.allowInput = allowInput
        self.placeholder = placeholder
        self.precision = precision
    }
    
    public init(_ quantity: Binding<Quantity?>, originalUnit: Quantity.UnitType, allowInput: Bool, placeholder: String, precision: FloatingPointFormatStyle.Configuration.Precision) {
        _quantity = quantity
        _selectedUnit = State(initialValue: originalUnit).projectedValue
        self.originalUnit = originalUnit
        self.allowInput = allowInput
        self.placeholder = placeholder
        self.precision = precision
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
private struct Example: View {
    @State private var quantity: AAngle?
    @State private var selectedUnit: AUAngle = .degrees
    
    var body: some View {
        HStack {
            AQuantityInputContent($quantity, selectedUnit: $selectedUnit, originalUnit: .degrees, allowInput: true, placeholder: "0.0", precision: .fractionLength(0 ... 3))
        }
        HStack {
            AQuantityInputContent($quantity, selectedUnit: $selectedUnit, originalUnit: .degrees, allowInput: false, placeholder: "0.0", precision: .fractionLength(0 ... 3))
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    List {
        Example()
    }
}
#endif
