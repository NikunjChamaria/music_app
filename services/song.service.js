const SongModel = require("../model/song.model");

class SongService{
    static async getSongs(){
        try {
            return  await SongModel.find({},{name:1,coverImage:1});

        } catch (error) {
            throw error;
        }
    }
}

module.exports=SongService;