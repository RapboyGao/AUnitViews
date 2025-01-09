import AUnit
import SwiftUI

/// A view for viewing a value and selecting a unit.
/// 提供显示值和选择单位的视图。
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@available(watchOS, unavailable)
public struct AUnitValueViews: View {
    @Binding private var unit: AUnit?
    private var value: Double?
    private var originalUnit: AUnit
    private var precision: FloatingPointFormatStyle.Configuration.Precision

    private var bindUnit: Binding<AUnit> {
        Binding {
            guard originalUnit.unitType == unit?.unitType
            else { return originalUnit }
            return unit ?? originalUnit
        } set: {
            unit = $0
        }
    }

    private var convertedValue: Double? {
        guard let value = value
        else { return value }
        return originalUnit.convert(value: value, to: bindUnit.wrappedValue)
    }

    public var body: some View {
        Spacer()
        if let convertedValue = convertedValue {
            Text("=")
            Menu {
                AUnitForeachView(typeFilter: originalUnit.unitType) { someUnit in
                    Button {
                        unit = someUnit
                    } label: {
                        Label(someUnit.nameInMenu, systemImage: someUnit.unitType.systemImage)
                    }
                }
            } label: {
                Text(convertedValue, format: .number.precision(precision))
                    +
                    Text(" " + bindUnit.wrappedValue.symbol)
            }
        } else {
            Text("-")
        }
    }

    public init(unit: Binding<AUnit?>, value: Double?, originalUnit: AUnit, digits: Int) {
        self._unit = unit
        self.value = value
        self.originalUnit = originalUnit
        self.precision = .fractionLength(0 ... digits)
    }

    public init(unit: Binding<AUnit?>, value: Double?, originalUnit: AUnit, precision: FloatingPointFormatStyle.Configuration.Precision) {
        self._unit = unit
        self.value = value
        self.originalUnit = originalUnit
        self.precision = precision
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@available(watchOS, unavailable)
private struct Example: View {
    @State private var unit: AUnit?
    private var value: Double? = 5
    private var originalUnit: AUnit = .meters
    private var digits: Int = 5
    var body: some View {
        List {
            HStack {
                Text("Value")
                AUnitValueViews(unit: $unit, value: value, originalUnit: originalUnit, digits: digits)
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
@available(watchOS, unavailable)
#Preview {
    Example()
}
