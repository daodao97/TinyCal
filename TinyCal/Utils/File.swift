
import Foundation
import SwiftUI

class File {
    var fm = FileManager.default

    func baseDIR() -> URL {
        let dir = self.fm.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return dir
    }

    func dir(fileName: String) -> URL {
        let path = self.baseDIR().appendingPathComponent(fileName)
        let parentDir = path.deletingLastPathComponent()

        if !self.fm.fileExists(atPath: parentDir.path) {
            do {
                try self.fm.createDirectory(atPath: parentDir.path, withIntermediateDirectories: true)
            } catch {
                print("createDirectory err", error)
            }
        }

        return path
    }

    // 创建文件
    public func createFile(fileName: String, data: String) {
        let path = self.dir(fileName: fileName)
        print("path", path)
        if let stringData = data.data(using: .utf8) {
            do {
                try stringData.write(to: path)
            } catch {
                print("save err", error)
            }
        }
    }

    public func readField(fileName: String) -> Data? {
        let path = self.dir(fileName: fileName)

        do {
            let data = try Data(contentsOf: path, options: .mappedIfSafe)
            return data
        } catch {
            // handle error
            return nil
        }
    }
}
