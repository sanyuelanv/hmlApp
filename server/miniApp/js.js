var vConsole = new VConsole()
class HmlApp {
  constructor() {
    this.getUserInfoID = 0
    this.getUserInfoCallbackSet = {}
  }
  getUserInfo(cb) {
    try {
      //存下回调函数
      let key = this.getUserInfoID
      this.getUserInfoCallbackSet[key] = cb
      // 调用 native 方法
      window.webkit.messageHandlers.hmlapp.postMessage({ name: 'getUserInfo', key: key })
      // ++
      this.getUserInfoID += 1
    } catch (error) {
      console.log(error)
    }

  }
  getUserInfoCallback(key, obj) {
    try {
      this.getUserInfoCallbackSet[key](obj,null)
      this.getUserInfoCallbackSet[key] = null
    } catch (error) {
      this.getUserInfoCallbackSet[key](null, error)
    }
  }
}
const hmlApp = new HmlApp()
window.onload = () => {
  let ua = window.navigator.userAgent.toLocaleLowerCase()
  let main = document.getElementById("main")
  let isInApp = false
  if (ua.indexOf('com.haodan123.miniapp') != -1) { isInApp = true }
  try {
    hmlApp.getUserInfo(function (obj, err) {
      let { name, age } = obj
      console.log(name)
      console.log(age)
    })
  } catch (error) {
    console.log(error)
  }
  // hmlApp.getUserInfoCallback(0,null)
  main.innerHTML = isInApp ? "在APP" : "不在APP"
}

