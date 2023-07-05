const mongoose=require('mongoose');
const bcrypt=require('bcrypt');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;

const songSchema= new Schema({
    name: {
        type: String,
       
      },
      artist: {
        type: String,
       
      },
      genre: {
        type: String,
        
      },
      weeklyPlays: {
        type: Number,
        default: 0
      },
      monthlyPlays: {
        type: Number,
        default: 0
      },
      totalPlays: {
        type: Number,
        default: 0
      },
      language: {
        type: String,
        
      },
      coverImage: {
        data: Buffer,
        contentType: String
        
      },
      mp3File: {
        data: Buffer,
        contentType: String
        
      }
});


songSchema.pre('save', function (next) {
  const currentDate = new Date();
  const startOfWeek = new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate() - currentDate.getDay());
  const startOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);

  if (currentDate >= startOfWeek) {
    this.weeklyPlays = 0;
  }

  if (currentDate >= startOfMonth) {
    this.monthlyPlays = 0;
  }

  next();
});

const SongModel=db.model('songs',songSchema);

module.exports=SongModel;