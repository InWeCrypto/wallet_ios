//
//  DBHMarketDetailViewController.swift
//  FBG
//
//  Created by 邓毕华 on 2017/11/24.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

import UIKit

import SnapKit

class DBHMarketDetailViewController: UIViewController {
    
    lazy var marketDetailView: DBHMarketDetailView = {
        let marketDetailView = DBHMarketDetailView()
        return marketDetailView
    }()
    lazy var style: CHKLineChartStyle = {
        let style: CHKLineChartStyle = .base
        // 文字颜色
        style.textColor = UIColor(white: 0.5, alpha: 1)
        
        // 背景颜色
        style.backgroundColor = UIColor.white
        
        // 边线颜色
        style.lineColor = UIColor(white: 0.8, alpha: 1)
        
        // 虚线颜色
        style.dashColor = UIColor(white: 0.8, alpha: 1)
        
        // 选中点的显示的文字颜色
        style.selectedTextColor = UIColor(white: 0.8, alpha: 1)
        
        // 删除最后一个分区
        style.sections.removeLast();
        
        // 不显示坐标轴
        style.showYLabel = CHYAxisShowPosition.none
        
        // 边距
        style.padding = UIEdgeInsetsMake(0, 3, 0, 3)
        
        style.showXAxisOnSection = 0
        
//        style.enableTap = false
        
        // 关闭数据显示
        for section in style.sections {
            section.showTitle = false
            
            if section.isEqual(style.sections.last) {
                section.series.remove(at: style.sections.count - 1)
            }
        }
        
        _ = style.sections.map {
            $0.backgroundColor = style.backgroundColor
        }
        
        return style
    }()
    lazy var chartView: CHKLineChartView = {
        let chartView = CHKLineChartView(frame: self.view.frame)
        
        chartView.delegate = self
        chartView.style = self.style
        
        return chartView
    }()
    var klineDatas = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Market Detail", comment: "")
        self.view.backgroundColor = UIColor.white;
        
        self.getDataByFile()
        
        self.view.addSubview(self.marketDetailView)
        self.view.addSubview(self.chartView)
        
        self.marketDetailView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(self.autolayousize(size: 110))
            make.top.centerX.equalToSuperview()
        }
        self.chartView.snp_remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(self.marketDetailView.snp_bottom)
            make.bottom.centerX.equalToSuperview()
        }
    }
    
    /// 获取本地数据
    func getDataByFile() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!))
        let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]
        
        let isSuc = dict["isSuc"] as? Bool ?? false
        if isSuc {
            let datas = dict["datas"] as! [AnyObject]
            NSLog("chart.datas = \(datas.count)")
            self.klineDatas = datas
            self.chartView.reloadData()
        }
    }
    
    func autolayousize(size: CGFloat) -> CGFloat {
        return 375.0 / UIScreen.main.bounds.size.width * size;
    }
}

// MARK: - 实现K线图表的委托方法
extension DBHMarketDetailViewController: CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return self.klineDatas.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let data = self.klineDatas[index] as! [Double]
        let item = CHChartItem()
        item.time = Int(data[0] / 1000)
        item.openPrice = CGFloat(data[1])
        item.highPrice = CGFloat(data[2])
        item.lowPrice = CGFloat(data[3])
        item.closePrice = CGFloat(data[4])
        item.vol = CGFloat(data[5])
        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, section: CHSection) -> String {
        var strValue = ""
        if value / 10000 > 1 {
            strValue = (value / 10000).ch_toString(maxF: section.decimal) + "万"
        } else {
            strValue = value.ch_toString(maxF: section.decimal)
        }
        return strValue
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        let data = self.klineDatas[index] as! [Double]
        let timestamp = Int(data[0])
        return Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
    }
    
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        return 2
    }
    
    
    /// 调整Y轴标签宽度
    ///
    /// - parameter chart:
    ///
    /// - returns:
    func widthForYAxisLabel(in chart: CHKLineChartView) -> CGFloat {
        return chart.kYAxisLabelWidth
    }
    
    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        let longGR : UILongPressGestureRecognizer = chart.gestureRecognizers![1] as! UILongPressGestureRecognizer;
        
        if longGR.state ==  .cancelled || longGR.state == .ended  {
            print(11111);
        } else {
            print(2222);
        }
    }
}

