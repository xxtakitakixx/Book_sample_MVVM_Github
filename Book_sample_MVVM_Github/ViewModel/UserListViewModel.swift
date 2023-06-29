//
//  UserListViewModel.swift
//  Book_sample_MVVM_Github
//
//  Created by Taki on 2023/06/29.
//

import Foundation
import UIKit

/*
 現在通信中か通信が成功したのか、失敗したのかの状態をenumで定義
 */
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {

    /*
     ViewModelStateをClosureとしてpropertyで保持
     この変数がViewControllerに対して通知を送る役割を果たす
     */
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    /*
     userの配列
     */
    private var users = [User]()
    
    /*
     UserCellViewModelの配列
     */
    private var cellViewModels = [UserCellViewModel]()
    
    /*
     Model層で定義したAPIクラスを変数として保持
     */
    let api = API()
    
    /*
     Userの配列を取得する
     */
    func getUsers() {
        /*
         loading通知を送る
         */
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUsers(success: { (users) in
            self.users.append(contentsOf: users)
            for user in users {
                /*
                 UserCellViewModelの配列を作成
                 */
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                
                /*
                 通信が成功したので .finish通知を送る
                 */
                self.stateDidUpdate?(.finish)
            }
        }) {(error) in
            /*
             通信が失敗したので .error通知を送る
             */
            self.stateDidUpdate?(.error(error))
        }
    }
    
    /*
     tableViewを表示させるために必要なアウトプット
     UserListViewModelはtableView全体に対するアウトプットなので、
     tableViewのcountに必要なuser.countがアウトプット
     tableViewCellに対するアウトプットは、UserCellViewModelが担当
     */
    func userCount() -> Int {
        return users.count
    }
}
