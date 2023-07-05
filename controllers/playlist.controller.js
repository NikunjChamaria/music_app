const PlayLsitModel = require("../model/playlist.model");

exports.getPlayList=async(req,res,next)=>{
    try {
        const {name}=req.body;
        const result=await PlayLsitModel.findOne({name:name});
        res.send(result);
    } catch (error) {
        throw error;
    }
}