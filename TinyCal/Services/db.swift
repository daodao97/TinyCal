//
//  db.swift
//  TinyCal
//
//  Created by sandao on 2022/9/8.
//

import FileKit
import Foundation
import SQLite

var dbFile = File().baseDIR().path + "/db.sqlite3"

func InitDB() {
    if Path(dbFile).exists {
        return
    }

    do {
        let db = try Connection(dbFile)

        let users = Table("todo_list")
        let id = Expression<Int64>("id")
        let date = Expression<String>("date")
        let startTime = Expression<String>("start_time")
        let endTime = Expression<String>("end_time")
        let title = Expression<String>("title")
        let desc = Expression<String>("desc")

        try db.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(date)
            t.column(startTime)
            t.column(endTime)
            t.column(title)
            t.column(desc)
        })

    } catch {
        print(error)
    }
}

class TODOList {
    var table = Table("todo_list")
    var db: Connection?

    var id = Expression<Int64>("id")
    var fields: [String: Expression<String>] = [
        "date": Expression<String>("date"),
        "startTime": Expression<String>("start_time"),
        "endTime": Expression<String>("end_time"),
        "title": Expression<String>("title"),
        "desc": Expression<String>("desc")
    ]
    init() {
        self.db = try! Connection(dbFile)
    }

    func add(td: TODO) -> Int64? {
        do {
            let insert = self.table.insert(
                self.fields["date"]! <- td.date,
                self.fields["startTime"]! <- td.startTime,
                self.fields["endTime"]! <- td.endTime,
                self.fields["title"]! <- td.title,
                self.fields["desc"]! <- td.desc
            )

            let rowid = try self.db?.run(insert)
            return rowid
        } catch {
            print(error)
            return nil
        }
    }

    func update(td: TODO) -> Bool {
        do {
            let data = self.table.filter(self.id == td.id).update(
                self.fields["date"]! <- td.date,
                self.fields["startTime"]! <- td.startTime,
                self.fields["endTime"]! <- td.endTime,
                self.fields["title"]! <- td.title,
                self.fields["desc"]! <- td.desc
            )

            try self.db?.run(data)
            return true
        } catch {
            print(error)
            return false
        }
    }

    func delete() {}
    func select(date: String) -> [TODO] {
        do {
            let list = self.table.filter(self.fields["date"]! == date)

            var res = [TODO]()
            for item in try self.db!.prepare(list) {
                let td = TODO(
                    id: item[self.id] as Int64,
                    title: item[self.fields["title"]!] as String,
                    desc: item[self.fields["desc"]!] as String,
                    date: item[self.fields["date"]!] as String,
                    startTime: item[self.fields["startTime"]!] as String,
                    endTime: item[self.fields["endTime"]!] as String
                )

                res.append(td)
            }

            return res

        } catch {
            print("db select err", error)
            return [TODO]()
        }
    }
}
