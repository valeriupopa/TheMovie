//
//  User.swift
//  TheMovie
//
//  Created by Valeriu POPA on 3/24/17.
//  Copyright © 2017 Valeriu POPA. All rights reserved.
//

import Photos
import RxSwift
import RealmSwift

class User {

    static var shared: User!
    var name: Variable<String>
    var email: Variable<String>
    var password: Variable<String>
    var birthdate: Variable<Date>
    var profile: Variable<URL?>
    var photo = PublishSubject<UIImage?>()

    private let disposeBag = DisposeBag()

    init(userData: UserData) {
        self.name = Variable(userData.name)
        self.email = Variable(userData.email)
        self.password = Variable(userData.password)
        self.birthdate = Variable(userData.birthday)
        self.profile = Variable(URL(string: userData.profile ?? ""))

        _ = self.profile.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [weak self] (url) in
                guard let `self` = self else { return }
                self.renewPhoto(url: url)
            })
    }

    func renewPhoto(url: URL?) {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in

            guard let `url` = url else {
                return
            }

            if let fetchAsset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject {

                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isSynchronous = true

                let imageManager = PHCachingImageManager()
                imageManager.requestImageData(for: fetchAsset, options: options, resultHandler: { (data, string, orientation, info) in
                    if let `data` = data {
                        let image = UIImage(data: data)
                        self.photo.onNext(image)
                    }
                })
            }
        }
    }

    func update() {
        let realm = try! Realm()
        // create a new instance of UserData
        let userData = UserData()
        userData.name = self.name.value
        userData.email = self.email.value
        userData.password = self.password.value
        userData.birthday = self.birthdate.value
        userData.profile = self.profile.value?.absoluteString

        try! realm.write {
            realm.add(userData, update: true)
        }
    }
}
