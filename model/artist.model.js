const mongoose=require('mongoose');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;

const artistSchema= new Schema({
    name: { type: String, required: true },
    artistImage: { type: Buffer },
    plays:{type:Number,default:0},
    songs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Song' }]
});

const ArtistModel=db.model('artists',artistSchema);

module.exports=ArtistModel;