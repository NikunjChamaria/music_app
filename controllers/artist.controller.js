const ArtistModel = require("../model/artist.model");

exports.getArtist=async(req,res,next)=>{
    try {
        const result =await ArtistModel.find();
        res.send(result);
    } catch (error) {
        throw error;
    }
}