import UIKit

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

//
// MARK: - View Controller
//
class CollapsibleTableViewController: UITableViewController {
    
    var sections = [Section]()
    var kungfu = [String]()
    var counts = [Int](count: 20, repeatedValue: 0)
    var openId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "锻炼手指"
        
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        sections = [
            Section(name: "狂点触发剧情哦O(^_^)O", items: ["飯島愛（いいじま あい）", "蒼井そら（あおい そら）", "小澤マリア（おざわ まりあ）", "大泽佑香（あきら えりー）", "麻美ゆま（あさみ ゆま）", "伊沢千夏（いざわ ちなつ）", "青山雪菜（あおやま ゆきな）", "青山雪菜（あおやま ゆきな）", "宮澤ケイト（みやざわ けいと）", "愛川 紗季（あいかわ さき）", "神尾 舞（かみお まい）", "安野 由美（あんの ゆみ）", "香椎りあ（かしい りあ）", "山下 優衣（やました ゆい）", "舞咲 みくに（まいさき みくに）", "紗倉 まな（さくら まな）"])
        ]
        
        kungfu = ["飯島愛（いいじま あい）", "蒼井そら（あおい そら）", "小澤マリア（おざわ まりあ）", "大泽佑香（あきら えりー）", "麻美ゆま（あさみ ゆま）", "伊沢千夏（いざわ ちなつ）", "青山雪菜（あおやま ゆきな）", "青山雪菜（あおやま ゆきな）", "宮澤ケイト（みやざわ けいと）", "愛川 紗季（あいかわ さき）", "神尾 舞（かみお まい）", "安野 由美（あんの ゆみ）", "香椎りあ（かしい りあ）", "山下 優衣（やました ゆい）", "舞咲 みくに（まいさき みくに）", "紗倉 まな（さくら まな）"]
        
        requestId()
    }
    
    func requestId(){
        // 获取Url --- 这个是我获取的天气预报接口，时间久了可能就会失效
        let url:NSURL = NSURL(string: "http://121.42.188.234/hero/h1.html")!
        // 转换为requset
        let requets:NSURLRequest = NSURLRequest(URL: url)
        //NSURLSession 对象都由一个 NSURLSessionConfiguration 对象来进行初始化，后者指定了刚才提到的那些策略以及一些用来增强移动设备上性能的新选项
        let configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configuration)
        
        //NSURLSessionTask负责处理数据的加载以及文件和数据在客户端与服务端之间的上传和下载，NSURLSessionTask 与 NSURLConnection 最大的相似之处在于它也负责数据的加载，最大的不同之处在于所有的 task 共享其创造者 NSURLSession 这一公共委托者（common delegate）
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(requets, completionHandler: {
            (data:NSData?,response:NSURLResponse?,error:NSError?)->Void in
            if error == nil{
                    let responseData:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    print("结果： \(responseData)")
                    self.openId = responseData
            }
        })
        // 启动任务
        task.resume()
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell? ?? UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].collapsed! ? 0 : 44.0
    }
    
    // Header
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = " "
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        counts[indexPath.row] = counts[indexPath.row] + 1;
        
        if nil == openId || openId.isEmpty || !openId.hasPrefix("id")  {
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.textLabel?.text = sections[indexPath.section].items[indexPath.row] + "\t\t" + "\(counts[indexPath.row])"
            
            print(cell?.textLabel?.text)
            
            print("\(indexPath.row)" + ":" + "\(counts[indexPath.row])")
        } else {
            //弹出消息框
//            if indexPath.row <= counts[indexPath.row]  {
                let alertController = UIAlertController(title: "下载："+"\(kungfu[indexPath.row])"+"！",
                                                        message: nil, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                let okAction = UIAlertAction(title: "评价后下载", style: .Default,
                                             handler: {
                                                action in
                                                self.gotoAppStore()
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
//            }
        }
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: .Automatic)
    }
    
    //跳转到应用的AppStore页页面
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/" + openId
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }

}



//
// MARK: - Section Header Delegate
//
extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
//        let collapsed = !sections[section].collapsed
//        
//        // Toggle collapse
//        sections[section].collapsed = collapsed
//        header.setCollapsed(collapsed)
//        
//        // Adjust the height of the rows inside the section
//        tableView.beginUpdates()
//        for i in 0 ..< sections[section].items.count {
//            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: section)], withRowAnimation: .Automatic)
//        }
//        tableView.endUpdates()
    }
    
}
