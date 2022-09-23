import SwiftUI

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)!

        return date
    }
}
