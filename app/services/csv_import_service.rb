require "csv"

class CsvImportService
  def initialize(user, file)
    @user = user
    @file = file
  end

  def import
    results = { success: 0, failed: 0, errors: [] }

    CSV.foreach(@file.path, headers: true, encoding: "UTF-8") do |row|
      record = build_record(row)

      if record&.save
        results[:success] += 1
      else
        results[:failed] += 1
        results[:errors] << record&.errors&.full_messages || [ "Invalid row" ]
      end
    rescue StandardError => e
      results[:failed] += 1
      results[:errors] << [ e.message ]
    end

    results
  end

  private

  def build_record(row)
    # CSV 컬럼: 거래일, 종목코드, 종목명, 구분, 수량, 단가
    stock = find_stock(row)
    return nil unless stock

    @user.investment_records.build(
      stock: stock,
      action: parse_action(row["구분"] || row["action"]),
      quantity: parse_integer(row["수량"] || row["quantity"]),
      price: parse_decimal(row["단가"] || row["price"]),
      traded_at: parse_date(row["거래일"] || row["traded_at"])
    )
  end

  def find_stock(row)
    symbol = row["종목코드"] || row["symbol"]
    name = row["종목명"] || row["name"]

    Stock.find_by(symbol: symbol) || Stock.find_by(name: name)
  end

  def parse_action(value)
    return nil unless value
    case value.to_s.strip
    when "매수", "buy", "BUY" then "buy"
    when "매도", "sell", "SELL" then "sell"
    else value.to_s.downcase
    end
  end

  def parse_integer(value)
    return nil unless value
    value.to_s.gsub(/[^\d]/, "").to_i
  end

  def parse_decimal(value)
    return nil unless value
    value.to_s.gsub(/[^\d.]/, "").to_d
  end

  def parse_date(value)
    return nil unless value
    Date.parse(value.to_s)
  rescue ArgumentError
    nil
  end
end
