//
//  ViewController.swift
//  DesignCode 2次练习
//
//  Created by 孙红艳 on 2019/08/12.
//  Copyright © 2019 孙红艳. All rights reserved.
//
/*
 点击按钮时播放视频
 现在我们已经连接好播放按钮了，就可以编写播放先导视频的代码。以下的代码稍微比较进阶一点，如果你有点跟不上，我建议你回到 Swift Playground 的章节复习一下。
 首先我们必须导入 AVKit 框架；在 import UIKit 正下方输入这行代码。*/
import UIKit
import AVKit
/*这是我们正在使用的框架，可以把它想成是 React 或者 Bootstrap（不过它更加复杂）。Swift 本身并非框架，而是一种语言，UIKit 则在框架之下，让我们能够编写只针对 iOS UI 对象的代码和使用一些很酷的特性，像是 Storyboard 或者背景模糊这样的小功能。
 我们的 View Controller 类是 UIViewController 的子类，意思是说他们可以使用相同的属性与方法，像是 viewDidLoad() 。这些东西是由 Apple 设置好的，让你能专心构建 app 交互上，而不用构建框架。如果你还不明白所有事情也没关系，因为时间久了就会越来越熟悉。*/
class ViewController: UIViewController {
    //IBOutlet 用来声明对象
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var playVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heroView: UIView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    
    /*
     我们命名它的方式为 play + type（类型） + action（行为） ，因此命名为 playButtonTapped ，这是 Apple 建议的命名规范。该 IBAction 会创建一个函数，你可以在小括弧里面编写代码。
     */
    @IBAction func playButtonTapend(_ sender: Any) {
        //在 playButtonTapped 的小括弧里，我们要放置本视频文件的 URL。
        let urlString = "https://player.vimeo.com/external/235468301.hd.mp4?s=e852004d6a46ce569fcf6ef02a7d291ea581358e&profile_id=175"
        /*
         然后，我们必须将 String 转换成 URL 类型，这样 AVPlayer 类才有办法读取。 AVPlayer 是一个 UI 对象，其中有播放视频的默认控件，如播放、暂停和快进。
         */
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        /*
         我们来创建一个显示视频播放器的 View Controller，接着把 播放器 放到 View Controller 上。
         */
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        /*
         最后，我们可以对任何 View Controller 使用 present（呈现） 函数，让它像模态一样产生动画。动画完成后，马上接着播放视频。
         */
        present(playerController, animated: true) {
            player.play()
        }
    }
    //顾名思义，viewDidLoad 指的就是画面何时会载入，小括弧里的代码会被执行。
    override func viewDidLoad() {
        super.viewDidLoad()
   /*使用 Delegate（代理）协议时，需要将它附加到你的 Object（对象）上；在这个例子里，我们要将它附加到 scrollView 上。在 viewDidLoad 里、 super.viewDidLoad 的下方加入这行代码。
         */
       scrollView.delegate = self
       chapterCollectionView.delegate = self
       chapterCollectionView.dataSource = self
        
        
        /*
         我们已经完成声明对象了，接下来可以在 viewDidLoad 里操作这些对象。例如，我们可以设置 alpha 不透明度为 0 。
         */
        titleLabel.alpha = 0
        deviceImageView.alpha = 0
        playVisualEffectView.alpha = 0
        
        //使用 UIView.animate ，可以制作基本的淡入动画。
        UIView.animate(withDuration: 1) {
            self.titleLabel.alpha = 1
            self.deviceImageView.alpha = 1
            self.playVisualEffectView.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToSection"{
            let toViewController = segue.destination as! SectionViewController
            let indexPath = sender as! IndexPath
            let section = sections[indexPath.row]
            toViewController.section = section
            toViewController.sections = sections
            toViewController.indexPath = indexPath
            
            
            
        }
    }
}


extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)as! SectionCollectionViewCell
        
        let section = sections[indexPath.row]
        cell.titleLable.text = section["title"]
        cell.capationLable.text = section["caption"]
        cell.coverImageView.image = UIImage(named: section["image"]!)
        cell.layer.transform = animateCell(cellFrame: cell.frame)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       performSegue(withIdentifier: "HomeToSection", sender: indexPath)
    }
}
/*
 Swift 扩展 UIScrollViewDelegate
 
 Extensions（扩展）可以为现有的类提供更多功能。在这个例子里，我们要让 ViewController 扩展 UIScrollViewDelegate 类。另外，我也喜欢利用 Extensions 来区分 Class 文件里的不同区域。在 ViewController 类下方最尾端加入这行代码。
 */
extension ViewController: UIScrollViewDelegate {
   /*滚动视图监控滚动
     我们需要捕捉滚动事件，这样才能使标题、设备图片、播放按钮和背景图根据垂直滚动的位置，产生动画。 UIScrollViewDelegate 提供了额外的函数，我们需要用这些函数来取得有用的信息。在 Extension 的小括弧里，我们使用 scrollViewDidScroll 函数取得 scrollView 信息。
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*捕捉 Content Offset Y 信息
         我们主要需要的就是取得滚动的 Y 位置。将这行代码输入到新的 scrollViewDidScroll 函数中。
         */
        let offsetY = scrollView.contentOffset.y
        /*Y 位置为 0 以上视差
         我们希望用户滚动超过起始位置时，动画才会启动，也就是位置 Y 为 0 处。将这行加入到条件中。
         */
        if offsetY < 0 {
            /*
             取消全版面视图
             滚动发生时，我们希望 Hero View 停止移动，因此我们要使用一点小技巧，将 Hero View 的 Y 位置移动到与 offsetY 相同处。 Transform 属性最适合用来转换、旋转或缩放对象。在这个例子里，我们要使用 translation 。
             */
            heroView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            /*
             以不同速度移动
             视差就是以不同速度移动多个对象，创建出 3D 效果，仿佛你正在车子里观看外面景物的感觉，前方的对象移动速度会比后方对象快，这就是我们要重现的效果。
             我们要将位置 Y 除以一个负数，得到速度；数值绝对值越大，对象移动速度越慢。因为位置 Y 是负的，负负就可以得正。
             举例来说，如果位置 Y 是-10 ，就可以把数字除以 -5 （速度）得到对象每次向下移动 2pt；如果将 -10 除 -2 ，就会得到对象每次向下移动 5pt 。再说一次，速度的数值绝对值越大，对象移动速度越慢。
             */
            playVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetY/3)
            deviceImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
            backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
        }
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                print(cellFrame)
         let translationX = cellFrame.origin.x / 5
         cell.coverImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
         
         cell.layer.transform = animateCell(cellFrame: cellFrame)
            }
        }
    
}
    func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
        
        return CATransform3DConcat(rotation, scale)
        
    }
}
