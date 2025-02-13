import AUnit
import AViewUI
import RealModule
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
// AUnitTextfieldContentDebounce 视图结构体
public struct AUnitTextfieldContentDebounce: View {
	@Binding var number: Double? // 绑定的数字
	@Binding var unit: AUnit? // 绑定的单位
	var originalUnit: AUnit? // 原始单位
	var placeholder: String // 占位符
	var format: AMathFormatStyle<Double> // 数字格式
	var allowSet: Bool // 是否允许设置
	var useMath: Bool // 是否使用数学键盘
	var typeFilter: [AUnitType]? // 单位类型过滤器

	@State var text: String = "" // 文本状态
	@FocusState private var isFocused: Bool // 焦点状态

	// 实际显示的文本
	private var actualText: String {
		if isFocused {
			return text
		} else {
			guard
				let convertedNumber = originalUnit?.convert(
					value: number, to: unit) ?? number
			else {
				return ""
			}
			return format.format(convertedNumber)
		}
	}

	// 绑定的文本
	private var bindText: Binding<String> {
		Binding {
			actualText
		} set: { newValue in
			update(string: newValue)
		}
	}

	// 实际选择的单位
	private var actualSelectedUnit: AUnit? {
		if let typeFilter = typeFilter, let originalUnit = originalUnit {
			guard typeFilter.contains(originalUnit.unitType)
			else {
				return nil
			}
			guard unit?.unitType == originalUnit.unitType else {
				return originalUnit
			}
			return unit ?? originalUnit
		} else {
			guard unit?.unitType == originalUnit?.unitType else {
				return originalUnit
			}
			return unit ?? originalUnit
		}
	}

	// 更新文本
	private func update(string newString: String) {
		text = newString
		guard let newNumber = try? format.parseStrategy.parse(newString)
		else { return }
		update(num: newNumber)
	}

	// 更新数字
	private func update(num newNumber: Double?) {
		guard let updatedNumber = actualSelectedUnit?.convert(value: newNumber, to: originalUnit) ?? newNumber
		else { return }
		number = updatedNumber
	}

	// 选择单位时的操作
	private func onSelect(unit newUnit: AUnit) {
		if let previousNumber = try? format.parseStrategy.parse(text),
			let newNumber = actualSelectedUnit?.convert(value: previousNumber, to: newUnit)
		{
			text = format.format(newNumber)
		}
		self.unit = newUnit
	}

	// 创建文本框视图
	@ViewBuilder
	func makeTextfield() -> some View {
		Group {
			if useMath {
				TextField(placeholder, text: bindText)
					.aKeyboardView {
						AMathExpressionKeyboard(
							$0, bindText, format: format.displayedFormat
						)
						.frame(height: 250)
					}
			} else {
				TextField(placeholder, text: bindText)
					.keyboardType(.decimalPad)
			}
		}
		.multilineTextAlignment(.trailing)
		.focused($isFocused)
	}

	// 视图主体
	public var body: some View {
		if allowSet {
			makeTextfield()
		} else {
			Spacer()
			Text("= ") + Text(actualText)
		}

		if let actualSelectedUnit = actualSelectedUnit {
			Menu {
				ForEach(actualSelectedUnit.unitType.allUnits) { thisKindOfUnit in
					Button {
						onSelect(unit: thisKindOfUnit)
					} label: {
						Label(thisKindOfUnit.nameInMenu, systemImage: thisKindOfUnit.unitType.systemImage)
					}
				}
			} label: {
				Text(actualSelectedUnit.symbol)
			}
		}
	}

	// 初始化方法
	public init(
		_ number: Binding<Double?>, _ unit: Binding<AUnit?>, originalUnit: AUnit?,
		placeholder: String,
		allowSet: Bool,
		format: AMathFormatStyle<Double>,
		useMath: Bool = true, filter typeFilter: [AUnitType]? = nil
	) {
		self._number = number
		self._unit = unit
		self.originalUnit = originalUnit
		self.placeholder = placeholder
		self.format = format
		self.allowSet = allowSet
		self.useMath = useMath
		self.typeFilter = typeFilter
	}

	// 初始化方法
	public init(
		_ number: Binding<Double?>, _ unit: Binding<AUnit?>, originalUnit: AUnit?,
		placeholder: String, allowSet: Bool,
		precision: NumberFormatStyleConfiguration.Precision,
		useMath: Bool = true, filter typeFilter: [AUnitType]? = nil
	) {
		self._number = number
		self._unit = unit
		self.originalUnit = originalUnit
		self.placeholder = placeholder
		self.format = AMathFormatStyle.precision(precision)
		self.allowSet = allowSet
		self.useMath = useMath
		self.typeFilter = typeFilter
	}

}

// 示例视图结构体
@available(iOS 16, *)
private struct Example: View {
	@State var number: Double? = 10.0
	@State var unit: AUnit?
	let someUnit: AUnit = .celsius

	var body: some View {
		HStack {
			Text("Value")
			AUnitTextfieldContentDebounce(
				$number, $unit, originalUnit: .meters, placeholder: "Hello",
				allowSet: false,
				precision: .fractionLength(0...3)
			)
		}
		HStack {
			Text("Value")
			AUnitTextfieldContentDebounce(
				$number, $unit, originalUnit: .meters, placeholder: "Hello",
				allowSet: true,
				precision: .fractionLength(0...3)
			)
		}
		HStack {
			TextField("Hello", value: $number, format: .number)
		}
	}
}

// 预览
@available(iOS 16, *)#Preview{
	List {
		Example()
	}
}

#endif
