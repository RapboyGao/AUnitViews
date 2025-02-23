import AUnit
import AViewUI
import SwiftUI

@available(macOS 12.0, iOS 16, tvOS 15.0, watchOS 8.0, *)
/// A view for inputting a value and selecting a unit.
/// 提供输入值和选择单位的视图。
public struct AUnitInputViews: View {
    @Binding private var value: Double?
    @Binding private var unit: AUnit?
    private var originalUnit: AUnit
    private var precision: FloatingPointFormatStyle.Configuration.Precision
    private var placeholder: String

    private var format: AMathFormatStyle<Double> {
        .precision(precision)
    }

    private var bindUnit: Binding<AUnit?> {
        Binding {
            guard originalUnit.unitType == unit?.unitType
            else { return originalUnit }
            return unit
        } set: {
            unit = $0
        }
    }

    private var convertedValue: Binding<Double?> {
        Binding<Double?>(
            get: {
                guard let value = value,
                    let unit = bindUnit.wrappedValue
                else { return value }
                return originalUnit.convert(value: value, to: unit)
            },
            set: { newValue in
                DispatchQueue.main.async {
                    guard let newValue = newValue,
                        let unit = bindUnit.wrappedValue
                    else {
                        value = newValue
                        return
                    }
                    value = unit.convert(value: newValue, to: originalUnit)
                }
            }
        )
    }

    public var body: some View {
        TextField(placeholder, value: convertedValue, format: format)
            #if os(iOS)
        .aKeyboardView { uiTextfield in
            AMathExpressionKeyboard(uiTextfield, format)
            .frame(height: 260)
        }
            #endif
            .multilineTextAlignment(.trailing)
        AUnitEasySelectorView(unit: bindUnit, filter: originalUnit.unitType, showNone: false)
    }

    /// Initializes a new instance of `UnitInputView`.
    /// 初始化 `UnitInputView` 的新实例。
    /// - Parameters:
    ///   - value: A binding to the value to be input.
    ///   - unit: A binding to the selected unit.
    ///   - originalUnit: The original unit.
    ///   - digits: The number of decimal places to retain.
    ///   - placeholder: The placeholder text for the text field.
    ///   - label: A view builder for the label to be displayed before the text field.
    public init(value: Binding<Double?>, unit: Binding<AUnit?>, _ originalUnit: AUnit, digits: Int, placeholder: String) {
        _value = value
        _unit = unit
        self.originalUnit = originalUnit
        self.precision = .fractionLength(0...digits)
        self.placeholder = placeholder
    }

    public init(value: Binding<Double?>, unit: Binding<AUnit?>, _ originalUnit: AUnit, placeholder: String, precision: FloatingPointFormatStyle.Configuration.Precision) {
        _value = value
        _unit = unit
        self.originalUnit = originalUnit
        self.precision = precision
        self.placeholder = placeholder
    }
}

@available(macOS 12.0, iOS 16, tvOS 15.0, watchOS 8.0, *)
private struct UnitInputViewExample: View {
    @State private var value: Double? = 1500
    @State private var unit1: AUnit? = .fahrenheit
    @State private var unit2: AUnit? = .feet

    var body: some View {
        List {
            HStack {
                AUnitInputViews(
                    value: $value,
                    unit: $unit1,
                    .meters,
                    digits: 5,
                    placeholder: "1"
                )
            }

            HStack {
                AUnitInputViews(
                    value: $value,
                    unit: $unit2,
                    .meters,
                    digits: 5,
                    placeholder: "2"
                )
            }
        }
    }
}

@available(macOS 12.0, iOS 16, tvOS 15.0, watchOS 8.0, *)#Preview{
    UnitInputViewExample()
}
