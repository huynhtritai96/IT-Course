import express from 'express'     //import express
require('dotenv').config()        // import và cấu hình dotenv
import 'dotenv/config';
import webRoutes from './routes/web';
import { getConnection } from './config/database';

const app = express()             // tạo express application object
const port = process.env.PORT     // init port

// configure view engine
app.set('view engine', 'ejs')     // set ejs làm view engine
app.set('views', './src/views')   // set thư mục views


// config req.body
app.use(express.json()) // for parsing application/json
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded

// config static files (css, js, images)
app.use(express.static('public')) // khai báo thư mục public chứa các file tĩnh

webRoutes(app); // nạp các routes từ file routes/web.ts

getConnection(); // test kết nối database

//khai báo routes: req (request), res(response) là 2 object trong môi trường Node.js
// app.get('/', (req, res) => {
//   res.render('home') // render file home.ejs trong thư mục views
// })


//run server trên port đã khởi tạo trước đấy nạp các thông tin khai báo ở trên rồi chạy (ví dụ như nạp routes)
app.listen(port, () => {
  console.log(`My app is running on port ${port}`)
  console.log(`env port: process.env.PORT = ${process.env.PORT}`)
  console.log(`__dirname = ${__dirname}`)
})
