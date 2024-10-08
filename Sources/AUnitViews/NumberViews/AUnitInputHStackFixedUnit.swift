import AUnit
import AViewUI
import SwiftUI

@available(macOS 12.0, iOS 16, tvOS 15.0, watchOS 8.0, *)
@available(watchOS, unavailable)
public struct AUnitInputHStackFixedUnit: View {
    @Binding private var value: Double?
    private var unit: AUnit
    private var originalUnit: AUnit
    private var digits: Int
    private var placeholder: String

    private var actualUnit: AUnit {
        guard originalUnit.unitType == unit.unitType
        else { return originalUnit }
        return unit
    }

    private var convertedValue: Binding<Double?> {
        Binding<Double?>(
            get: {
                guard let value = value
                else { return value }
                return originalUnit.convert(value: value, to: actualUnit)
            },
            set: { newValue in
                DispatchQueue.main.async {
                    guard let newValue = newValue
                    else {
                        value = newValue
                        return
                    }
                    value = actualUnit.convert(value: newValue, to: originalUnit)
                }
            }
        )
    }

    private var format: AMathFormatStyle<Double> {
        .fractionLength(digits)
    }

    public var body: some View {
        HStack {
            TextField(
                placeholder,
                value: convertedValue,
                format: format
            )
            #if os(iOS)
            .aKeyboardView { uiTextfield in
                AMathExpressionKeyboard(uiTextfield, format)
                    .frame(height: 260)
            }
            #endif
            Menu(actualUnit.symbol) {
                Label(actualUnit.longName, systemImage: actualUnit.unitType.systemImage)
            }
        }
    }

    public init(value: Binding<Double?>, unit: AUnit, originalUnit: AUnit, digits: Int, placeholder: String) {
        _value = value
        self.unit = unit
        self.originalUnit = originalUnit
        self.digits = digits
        self.placeholder = placeholder
    }
}
