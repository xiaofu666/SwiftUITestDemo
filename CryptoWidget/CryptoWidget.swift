//
//  CryptoWidget.swift
//  CryptoWidget
//
//  Created by Lurich on 2023/2/28.
//

import WidgetKit
import SwiftUI
import Intents
import Charts

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Crypto {
        Crypto(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Crypto) -> ()) {
        let entry = Crypto(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        Task {
            if var cryptoData = try? await feachData() {
                cryptoData.date = currentDate
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 150, to: currentDate)!
                let timeline = Timeline(entries: [cryptoData], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
    
    func feachData() async throws -> Crypto {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return .init() }
        let data = try Data(contentsOf: URL(filePath: path))
//        let response = try JSONSerialization.jsonObject(with: data) as! Array<Any>
        let cryptoData = try JSONDecoder().decode([Crypto].self, from: data)
        if let crypto = cryptoData.first {
            return crypto
        }
        return .init()
    }
}

struct Crypto: TimelineEntry,Codable {
    var date: Date = .init()
    var priceChange: Double = 0.0
    var currentPrice: Double = 0.0
    var last7Days: SparklineData = .init()
    
    enum CodingKeys: String, CodingKey {
        case priceChange =  "price_change_percentage_7d_in_currency"
        case currentPrice = "current_price"
        case last7Days = "sparkline_in_7d"
    }
}
struct SparklineData: Codable {
    var price: [Double] = []
    
    enum CodingKeys: String, CodingKey {
        case price = "price"
    }
}
struct CryptoWidgetEntryView : View {
    var crypto: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if family == .systemMedium {
            MediumSizedWidget()
        }
        else {
            LockScreenWidget()
        }
    }
    
    @ViewBuilder
    func LockScreenWidget() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("BitCoin")
                        .font(.callout)
                    
                    Text("BTC")
                        .font(.caption2)
                }
                
                Spacer()
                
                Image(systemName: "chart.xyaxis.line")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
            }
            
            HStack {
                Text(crypto.currentPrice.toCurrency())
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                    .font(.caption2)
            }
        }
    }
    
    @ViewBuilder
    func MediumSizedWidget() -> some View {
        ZStack {
            Rectangle()
                .fill(Color("Gray"))
            
            VStack {
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.orange)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("BitCoin")
                            .foregroundColor(.white)
                        
                        Text("BTC")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(crypto.currentPrice.toCurrency())
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 15) {
                    VStack(spacing: 8) {
                        Text("This week")
                            .font(.caption)
                            .foregroundColor(.gray)
                       
                        Text(crypto.priceChange.toString(floatingPoint: 1) + "%")
                            .fontWeight(.semibold)
                            .foregroundColor(crypto.priceChange < 0 ? .red : .green)
                    }
                    
                    // MARK: Swift UI Charts
                    Chart {
                        let grapColor: Color = crypto.priceChange < 0 ? .red : .green
                        ForEach(crypto.last7Days.price.indices, id: \.self) { index in
                            LineMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - mainValue()))
                                .foregroundStyle(grapColor)
                            
                            AreaMark(x: .value("Hour", index), y: .value("Price", crypto.last7Days.price[index] - mainValue()))
                                .foregroundStyle(.linearGradient(colors:[
                                    grapColor.opacity(0.2),
                                    grapColor.opacity(0.1),
                                    .clear
                                ], startPoint: .top, endPoint: .bottom))
                            
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                }
                
            }
            .padding(.all)
        }
    }
    
    func mainValue() -> Double {
        if let min = crypto.last7Days.price.min() {
            return min
        }
        return 0.0
    }
}

extension Double {
    func toCurrency() -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: .init(value: self)) ?? "$0.00"
    }
    
    func toString(floatingPoint: Int) -> String {
        return String(format: "%.\(floatingPoint)f", self)
    }
}

struct CryptoWidget: Widget {
    let kind: String = "CryptoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CryptoWidgetEntryView(crypto: entry)
        }
        .supportedFamilies([.systemMedium, .accessoryRectangular])
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CryptoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWidgetEntryView(crypto: Crypto(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
