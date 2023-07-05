const express=require('express');
const body_parser=require('body-parser');
const UserRoute=require('./routes/routes');
const cors = require('cors');
const db=require('./config/db');
const app=express();
app.use(body_parser.json());
app.use(cors());
app.use('/',UserRoute);

module.exports=app;