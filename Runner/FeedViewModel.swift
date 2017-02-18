//
//  FeedViewModel.swift
//  Runner
//
//  Created by Thiago Heitling on 2017-02-17.
//  Copyright © 2017 Thiago Heitling. All rights reserved.
//

import Foundation

class FeedViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellID = "cellID"
    let layout = UICollectionViewFlowLayout()
    
    var collectionView: UICollectionView?

    var runItems = [Run]()
    
    override init() {
        super.init()
        
        collectionView = getCollectionView()
        bind()
    }
    
    func getCollectionView() -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedViewCell.self, forCellWithReuseIdentifier: self.cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }
    
    func bind() {
        
        for _ in 0..<10 {
            
            let run = Run(type: RunType.run, time: nil, duration: 10, totalRunDistance: 100, totalDistanceInPause: 0, pace: 5.0, pacesBySegment: [], calories: 0, feeling: nil)
            runItems.append(run)
        }        
    }
    
    //MARK: CollectionView Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return runItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! FeedViewCell
        
        cell.backgroundColor = UIColor.white
        
        let run = runItems[indexPath.item]
        let feeling = AfterRunFeeling()
        cell.emoji = feeling.getEmojiImage(with: String(indexPath.row))
        cell.runDistance.text = "\(run.totalRunDistance)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
//            selectedEmoji = indexPath
//            cell.emojiView.alpha = 1
//            animateView(view: cell.emojiView)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        
//        if let cell = collectionView.cellForItem(at: selectedEmoji) as? EmojiCell {
//            cell.emojiView.alpha = 0.3
//        }
//    }
}

class FeedViewCell: UICollectionViewCell {
    
    var emoji: UIImage? {
        didSet {
            if let image = emoji {
                emojiView.image = image
            }
        }
    }
    
    let emojiView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var runDistance: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(emojiView)
        
        // x, y, width, height constraints
        emojiView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        emojiView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        emojiView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        emojiView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        
        addSubview(runDistance)
        // x, y, width, height constraints
        runDistance.leftAnchor.constraint(equalTo: emojiView.rightAnchor, constant: 10).isActive = true
        runDistance.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        runDistance.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runDistance.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
}
