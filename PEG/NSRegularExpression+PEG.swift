extension NSRegularExpression {
    convenience init?(pattern: String, caseInsensitive: Bool = false) {
        var opts: NSRegularExpressionOptions = nil
        if caseInsensitive {
            opts = .CaseInsensitive
        }
        
        self.init(pattern: pattern, options: opts, error: nil)
    }
}