import AUnit
import AViewUI
import SwiftUI

#if os(iOS)

/// 一个用于输入数字并选择单位的视图，可以进行单位转换。
/// - 它绑定数字和单位的值，并在提供原始单位时进行单位间的转换。
/// - 应该把它放到HStack里，并放在右侧
@available(iOS 16, *)
public struct AUnitTextfieldContent: View {
    @Binding var number: Double?
    @Binding var unit: AUnit?
    var originalUnit: AUnit?
    var typeFilter: [AUnitType]?
    var allowSet: Bool
    var mathKeyboard: Bool
    var name: String
    var precision: FloatingPointFormatStyle<Double>.Configuration.Precision

    var numberInTextField: Double? {
        originalUnit?.convert(value: number, to: unit) ?? number
    }

    var bindTextfield: Binding<Double?> {
        Binding {
            numberInTextField
        } set: { newValue in
            number = unit?.convert(value: newValue, to: originalUnit) ?? newValue
        }
    }

    var bindUnit: Binding<AUnit?> {
        Binding {
            unit ?? originalUnit
        } set: { newVal in
            unit = newVal
        }
    }

    var actualOriginalUnit: AUnit? {
        guard let typeFilter = typeFilter else {
            // 如果没有过滤，则返回原unit
            return originalUnit
        }
        // 如果有过滤，则需要contain该originalUnit的type
        guard let unitType = originalUnit?.unitType,
            typeFilter.contains(unitType)
        else { return nil }
        return originalUnit
    }

    @ViewBuilder
    var textfieldView: some View {
        Group {
            if allowSet {
                if mathKeyboard {
                    AMathFormatTextfield(
                        number: bindTextfield,
                        precision: precision,
                        placeholder: name
                    )
                } else {
                    TextField(
                        name,
                        value: bindTextfield,
                        format: .number.precision(precision)
                    )
                    .keyboardType(.decimalPad)
                }
            } else {
                Spacer()
                if let numberInTextField = numberInTextField {
                    Text("= ") + Text(numberInTextField, format: .number.precision(precision))
                } else {
                    Text("-")
                }
            }
        }
        .multilineTextAlignment(.trailing)
        .textSelection(.enabled)
    }

    public var body: some View {
        if let actualOriginalUnit = actualOriginalUnit {  // 如果有原单位
            textfieldView
            AUnitEasySelectorView(unit: bindUnit, filter: actualOriginalUnit.unitType, showNone: false)
        } else {
            textfieldView
        }
    }

    /// 初始化 `AUnitInputContent` 视图，设置各种绑定和配置。
    ///
    /// - 参数：
    ///   - number: 绑定的数字输入值。
    ///   - unit: 绑定的单位选择器。
    ///   - originalUnit: 用于转换的原始单位（可选）。
    ///   - typeFilter: 过滤单位类型（可选）。
    ///   - allowSet: 是否允许设置自定义数字。
    ///   - mathKeyboard: 是否使用数学键盘输入。
    ///   - name: 输入框的名称或标签。
    ///   - precision: 显示数字的精度配置。
    public init(
        _ number: Binding<Double?>, _ unit: Binding<AUnit?>, original originalUnit: AUnit?,
        filter typeFilter: [AUnitType]?, allowSet: Bool, mathKeyboard: Bool, name: String,
        precision: FloatingPointFormatStyle<Double>.Configuration.Precision
    ) {
        self._number = number
        self._unit = unit
        self.originalUnit = originalUnit
        self.typeFilter = typeFilter
        self.allowSet = allowSet
        self.mathKeyboard = mathKeyboard
        self.name = name
        self.precision = precision
    }
}

@available(iOS 16, *)
private struct Example: View {
    @State var number: Double?
    @State var unit: AUnit?

    var body: some View {
        List {
            HStack {
                Text("Hello")
                AUnitTextfieldContent(
                    $number, $unit, original: .meters, filter: [.length], allowSet: true,
                    mathKeyboard: true, name: "Hello", precision: .fractionLength(0...10))
            }
            HStack {
                Text("Hello")
                AUnitTextfieldContent(
                    $number, $unit, original: nil, filter: [.length], allowSet: false, mathKeyboard: true,
                    name: "Hello", precision: .fractionLength(0...10))
            }
            HStack {
                Text("Hello")
                AUnitTextfieldContent(
                    $number, $unit, original: .meters, filter: [.length], allowSet: false,
                    mathKeyboard: true, name: "Hello", precision: .fractionLength(0...10))
            }
        }
    }
}

@available(iOS 16, *)
#Preview {
    Example()
}

#endif
