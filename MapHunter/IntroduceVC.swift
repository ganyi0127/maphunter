//
//  IntroduceVC.swift
//  MapHunter
//
//  Created by ganyi on 2016/12/29.
//  Copyright © 2016年 ganyi. All rights reserved.
//

import Foundation
class IntroduceVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var type: DataCubeType?
    
    private var text = ""{
        didSet{
            label.text = text
        }
    }
    
    override func viewDidLoad() {
        text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        config()
        createContents()
    }
    
    private func config(){
        
        navigationItem.hidesBackButton = true
        
    }
    
    private func createContents(){
        
        guard let cubeType = type else {
            return
        }
        
        switch cubeType {
        case .sport:
            text = "运动介绍"
        case .sleep:
            text = "了解浅睡眠与深睡眠\n浅睡眠：一般指入睡后20〜60分钟，这期间入睡者是比较容易被吵醒的\n深睡眠：是人的大脑皮质细胞处于充分休息状态，对稳定情绪、平衡心态、恢复精力极为重要。深睡眠一般出现在进入睡眠半个小时后。同时，此时人体内可以产生许多抗体，增强抗病能力。\n芝加哥大学的研究人员发现，对年龄不到25岁的男性来说，其深度睡眠的时间几乎占夜晚睡眠时间的20%，而过了 35岁，这一比例下降到5%以下。到45岁时，很少有男子花费更多的时间在深度睡眠上。到了老年，深睡眠更少\n\n\n\n" + "了解静息心率\n静息心率是在您起床之间进行量测,用以记录不受活动或思考等因素影响的心率。静止心率是心脏整体健康的最佳指标之一。\n静止心率没有<正常值>.您的心率对于您来说是独一无二的,它取决于年龄,健康状况和遗传基因等因素。\n\n美国心脏协会称,这是成年人的典型范围"
        default:
            text = ""
        }
    }
    
}

extension IntroduceVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = navigationController?.popViewController(animated: true)
    }
}
