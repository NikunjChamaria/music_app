const mongoose=require('mongoose');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;

const playlistSchema= new Schema({
    name: { type: String, required: true },
    playListImage: { type: Buffer },
    plays:{type:Number,default:0},
    songs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Song' }]
});

const PlayLsitModel=db.model('playlists',playlistSchema);



module.exports=PlayLsitModel;