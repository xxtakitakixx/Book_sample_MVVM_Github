//
//  UserCellViewModel.swift
//  Book_sample_MVVM_Github
//
//  Created by Taki on 2023/06/29.
//

import Foundation
import UIKit

/*
 現在通信中か通信が成功したのか、失敗したのかの状態をenumで定義
 */
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

final class UserCellViewModel {
    
    /*
     userを変数として保持
     */
    private var user: User
    
    /*
     ImageDownloaderを変数として保持
     */
    private let imageDonwloader = ImageDownloader()
    
    /*
     ImageDownloaderでダウンロード中かどうかのBool変数として保持
     */
    private var isLoading = false
    
    /*
     Cellに反映させるアウトプット
     */
    var nickName: String {
        return user.name
    }
    
    /*
     userを引数にinit
     */
    init(user: User) {
        self.user = user
    }
    
    /*
     imageDownloaderを使ってダウンロードし、結果をImageDownloadProgressとしてClosureで返す
     */
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        /*
         isLoadingがTrueの時：return
         このメソッドはcellForRowメソッドで呼ばれることを想定しているため、
         何回もダウンロードしないためにisLoadingを使用している
         */
        if isLoading == true {
            return
        }
        
        isLoading = true
        
        /*
         grayのUIImageを作成
         */
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        /*
         .loadingをClosureで返す
         */
        progress(.loading(loadingImage))
        
        /*
         imageDownloaderを用いて画像をダウンロードする
         引数にuser.iconUrlを使う
         ダウンロードが終了したら.finishをClosureで返す
         Errorの時は.errorをClosureで返す
         */
        imageDonwloader.downloadImage(imageURL: user.iconUrl, success: { (image) in
            progress(.finish(image))
            self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
    }
}
