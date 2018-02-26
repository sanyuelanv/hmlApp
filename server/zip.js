var fs = require('fs')
var archiver = require('archiver')
// 目标目录
var output = fs.createWriteStream('public/app.zip')
var archive = archiver('zip')

archive.on('error', function(err){throw err})
archive.pipe(output)
// 前端开发目录
archive.directory('miniApp/', false)
archive.finalize()