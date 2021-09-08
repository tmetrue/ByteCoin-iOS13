
import Foundation

struct ExchangeRateData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
