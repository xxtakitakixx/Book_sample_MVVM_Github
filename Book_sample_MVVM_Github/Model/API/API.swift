//
//  API.swift
//  Book_sample_MVVM_Github
//
//  Created by Taki on 2023/06/28.
//

// APIにリクエストを送る
// 受け取ったJSONからUserの配列を作成してClosureで返す
// Errorが起こった時にErrorをClosureで返す

/*
 @escaping：Closureをエスケープする
 非同期処理で使う
 Closureは関数に引数として渡された時に「関数をエスケープ」できる
 エスケープしたClosureは関数に戻った後でも呼び出し可能
 */

import Foundation

class API {
    
    // success-failure型で処理を実装する
    // 成功：結果の値、失敗：エラーの詳細で表す
    // 非同期処理の結果やネットワーク通信などの外部リソースを扱う場合
    func getUsers(success: @escaping ([User]) -> Void,
                  failure: @escaping (Error) -> Void) {
        let requestURL = URL(string: "https://api.github.com/users")
        guard let url = requestURL else {
            failure(APIError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        // URLにアクセスしてレスポンスを取得する
        let task = URLSession.shared.dataTask(with: request)
        { (data, response, error) in
            /*
             ErrorがあったらErrorをClosureで返す
             */
            if let error = error {
                
                // GCDを理解する -> マルチコアハードウェアにおいて配列でタスクを実行させるための技術
                // DispatchQueue
                // プログラムの処理をスレッドに分けて実行・管理できるクラス
                // QueueなのでFIFOで実行
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            /*
             dataがなかったら、API Error.unknown ErrorをClosureで返す
             */
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            /*
             レスポンスのデータ型が不正だったら、
             APIError.invalidResponse ErrorをClosureで返す
             */
            guard
                let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonOptional as? [[String: Any]]
            else {
                DispatchQueue.main.async {
                    failure(APIError.invalidResponse)
                }
                return
            }
            
            /*
             for文でJSONからUserを作成し、[User]に追加する。
             その後、[User]をClosureで返す
             */
            var users = [User]()
            for j in json {
                let user = User(attributes: j)
                users.append(user)
            }
            DispatchQueue.main.async {
                success(users)
            }
        }
        task.resume()
    }
}
