const mongoose=require('mongoose');
const bcrypt=require('bcrypt');
const db=require('../config/db');
const e = require('express');

const { Schema }=mongoose;


const userSchema= new Schema({
    email:{
        type:String,
        lowercase: true,
        required:true,
        unique:true
    },
    password:{
        type:String,
        required:true,
    },
    name:{
        type:String,
        required:false,
    },
    phone:{
        type:String,
        required:false,
    },
    recently: {
        type: [{
          id: {
            type: mongoose.Schema.Types.ObjectId,
          },
          isPlaylist: {
            type: Boolean,
            default: false
          }
        }],
        default: [],
      }
      
});

userSchema.pre('save',async function(){
    try {
        var user=this;
        const salt=await(bcrypt.genSalt(10));
        const hashpass=await bcrypt.hash(user.password,salt);
        user.password=hashpass;
    } catch (error) {
        throw error;
    }
})

userSchema.methods.comparePassword=async function(userPassword){
   try {
    const isMatch = await bcrypt.compare(userPassword,this.password);
    return isMatch;
   } catch (error) {
    throw error;
   } 
}

const UserModel=db.model('user',userSchema);

module.exports=UserModel;