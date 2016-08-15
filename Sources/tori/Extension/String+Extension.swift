import MD5

extension String {
    var md5: String {
        return MD5.calculate(self).hexString
    }
}