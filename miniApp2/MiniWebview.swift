//
//  MiniWebview.swift
//  miniApp2
//
//  Created by 宋航 on 2018/2/19.
//  Copyright © 2018年 宋航. All rights reserved.
//

import Foundation
import WebKit
class MiniWebview: WKWebView {
    var UAFLAG = "/com.haodan123.miniApp"
    var SOURCEFLAG = "@miniAPP"
    init(html:String,url:URL) {
        let webConfiguation = WKWebViewConfiguration()
        // 1. 设置内嵌播放视频
        webConfiguation.allowsInlineMediaPlayback = true
        // 2. 创建WKWebView: 修改UA
        super.init(frame: .zero, configuration: webConfiguation)
        self.evaluateJavaScript("navigator.userAgent") { (res,err) in
            guard let res = res else { return }
            let ua = res as! String
            self.customUserAgent = ua + self.UAFLAG
        }
        // 替换资源路径
        let htmlString = html.replacingOccurrences(of: SOURCEFLAG, with: url.absoluteString)
//        print(htmlString)
        // 3. 创建URL
        self.loadHTMLString(htmlString, baseURL: url)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

