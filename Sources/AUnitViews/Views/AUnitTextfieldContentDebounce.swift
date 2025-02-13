import AUnit
import AViewUI
import RealModule
import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct AUnitTextfieldContentDebounce: View {
	@Binding var number: Double?
	@Binding var unit: AUnit?
	var originalUnit: AUnit?
	var placeholder: String
	var format: AMathFormatStyle<Double>
	var allowSet: Bool

	@State var text: String = ""
	@FocusState private var isFocused: Bool


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

	private var bindText: Binding<String> {
		Binding {
			actualText
		} set: { newValue in
			update(string: newValue)
		}

	}

	private var actualSelectedUnit: AUnit? {
		guard unit?.unitType == originalUnit?.unitType else {
			return originalUnit
		}
		return unit ?? originalUnit
	}


	private func update(string newString: String) {
		text = newString
		guard let newNumber = try? format.parseStrategy.parse(newString)
		else { return }
		update(num: newNumber)
	}

	private func update(num newNumber: Double?) {
		guard let updatedNumber = actualSelectedUnit?.convert(value: newNumber, to: originalUnit) ?? newNumber
		else { return }
		number = updatedNumber
	}
	private func onSelect(unit newUnit: AUnit) {
		if let previousNumber = try? format.parseStrategy.parse(text),
			let newNumber = actualSelectedUnit?.convert(value: previousNumber, to: newUnit)
		{
			text = format.format(newNumber)
		}
		self.unit = newUnit
	}

	public var body: some View {
		if allowSet {
			TextField(placeholder, text: bindText)
				.aKeyboardView {
					AMathExpressionKeyboard(
						$0, bindText, format: format.displayedFormat
					)
					.frame(height: 250)
				}
				.multilineTextAlignment(.trailing)
				.focused($isFocused)
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


	public init(
		_ number: Binding<Double?>, _ unit: Binding<AUnit?>, originalUnit: AUnit?,
		placeholder: String,
		allowSet: Bool,
		format: AMathFormatStyle<Double>
	) {
		self._number = number
		self._unit = unit
		self.originalUnit = originalUnit
		self.placeholder = placeholder
		self.format = format
		self.allowSet = allowSet
	}

	public init(
		_ number: Binding<Double?>, _ unit: Binding<AUnit?>, originalUnit: AUnit?,
		placeholder: String, allowSet: Bool,
		precision: NumberFormatStyleConfiguration.Precision
	) {
		self._number = number
		self._unit = unit
		self.originalUnit = originalUnit
		self.placeholder = placeholder
		self.format = AMathFormatStyle.precision(precision)
		self.allowSet = allowSet
	}

}


@available(iOS 16, *)
private struct Example: View {
	@State var number: Double? = 10.0
	@State var unit: AUnit?
	let someUnit: AUnit = .celsius

	var body: some View {
		HStack {
			AUnitTextfieldContentDebounce(
				$number, $unit, originalUnit: .meters, placeholder: "Hello",
				allowSet: false,
				precision: .fractionLength(0...3)
			)
		}
		HStack {
			Text("Hello")
		}
	}
}

@available(iOS 16, *)#Preview{
	List {
		Example()
	}

}

#endif
