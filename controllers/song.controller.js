const ArtistModel = require("../model/artist.model");
const PlayLsitModel = require("../model/playlist.model");
const SongModel = require("../model/song.model");
const SongService = require("../services/song.service");
const axios = require('axios');
const Jimp = require('jimp');

exports.getSongs=async(req,res,next)=>{
    try {
        const result =await SongService.getSongs();
        res.send(result);
    } catch (error) {
        throw error;
    }
}
exports.getSongData=async(req,res,next)=>{
    const songId = req.params.id;
    try {
        const songData=await SongModel.findById(songId);
        res.send(songData);
    } catch (error) {
        throw error;
    }
}
exports.getSong=async(req,res,next)=>{
  const songId = req.params.id;
  try {
      const songData=await SongModel.findById(songId,{mp3File:0});
      res.send(songData);
  } catch (error) {
      throw error;
  }
}
exports.updateWeeklyPlays=async(req,res,next)=>{
    const songId = req.params.id;

  try {
    const song1 = await SongModel.findById(songId);
    var newWeek=song1.weeklyPlays+1;
    var newMonth=song1.monthlyPlays+1;
    var newTotal=song1.totalPlays+1;
    const artist =await ArtistModel.findOne({name:song1.artist});
    if(artist){
      artist.plays=artist.plays+1;
    artist.save();
    }

    const song=await SongModel.findByIdAndUpdate(songId,{weeklyPlays:newWeek,monthlyPlays:newMonth,totalPlays:newTotal});

    if (!song) {
      return res.status(404).json({ message: 'Song not found' });
    }

    return res.status(200).json(song.weeklyPlays);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Internal server error' });
  }
}
async function createTop10Playlist(songs,name) {
  try {
    const playlistName = name;
    const songIds = songs.map(song => song._id);

    let playlistImage = null;

    if (songs.length > 0) {
      const coverImageBuffers = songs.slice(0, 4).map(song => song.coverImage.data);

      if (coverImageBuffers.length === 1) {
        // If there is only one song, use its cover image directly
        const coverImage = await Jimp.read(coverImageBuffers[0]);
        playlistImage =  new Jimp(400, 400);
        playlistImage.composite(coverImage, 0, 0);
      } else {
        // If there are more than one song, composite the cover images into one image
        const coverImages = await Promise.all(
          coverImageBuffers.map(buffer => Jimp.read(buffer))
        );

        playlistImage =  new Jimp(400, 400);
        const positions = [
          { x: 0, y: 0 },
          { x: 200, y: 0 },
          { x: 0, y: 200 },
          { x: 200, y: 200 }
        ];

        coverImages.forEach((image, index) => {
          const position = positions[index];
          playlistImage.composite(image, position.x, position.y);
        });
      }
    }

    // Convert the playlist image to buffer (or null if no cover image)
    const playlistImageBuffer = playlistImage ? await playlistImage.getBufferAsync(Jimp.MIME_PNG) : null;


    // Check if the playlist already exists
    const existingPlaylist = await PlayLsitModel.findOne({ name: playlistName });

    if (existingPlaylist) {
      // Update the existing playlist
      existingPlaylist.playListImage = playlistImageBuffer;
      existingPlaylist.songs = songIds;
      await existingPlaylist.save();
      
    } else {
      // Create a new playlist
      const playlist = new PlayLsitModel({
        name: playlistName,
        playListImage: playlistImageBuffer,
        songs: songIds
      });
      await playlist.save();
  
    }
  } catch (error) {
    console.log(error);
  }
}


exports.getTop10inWeek=async(req,res,next)=>{
  try {
    const songs = await SongModel.find({},{name:1,coverImage:1})
      .sort({ weeklyplays: -1 }).limit(10) ; 
    createTop10Playlist(songs,'Top 10 This Week');
    return res.send(songs);
  } catch (error) {
    
    console.error('Error retrieving top songs:', error);
    throw error;
  }
}

exports.getTop100intotalforMain=async(req,res,next)=>{
  try {
    const songs = await SongModel.find({},{name:1,coverImage:1})
    .sort({ totalPlays: -1 }).limit(7) ;
    
  return res.send(songs);
  } catch (error) {
    throw error;
  }
}


exports.getTop100intotal=async(req,res,next)=>{
  try {
    const songs = await SongModel.find({},{name:1,coverImage:1})
    .sort({ totalPlays: -1 }).limit(100) ;
    createTop10Playlist(songs,'Top 100');
  return res.send(songs);
  } catch (error) {
    throw error;
  }
}

exports.getTop10inEnglish=async(req,res,next)=>{
  try {
    const songs = await SongModel.find({language:"English"},{name:1,coverImage:1})
    .sort({ totalPlays: -1 }).limit(10) ; 
    createTop10Playlist(songs,'Top 10 in English');
  return res.send(songs);
  } catch (error) {
    throw error;
  }
}

exports.getTop10inHindi=async(req,res,next)=>{
  try {
    const songs = await SongModel.find({language:"Hindi"},{name:1,coverImage:1})
    .sort({ totalPlays: -1 }).limit(10) ; 
    createTop10Playlist(songs,'Top 10 in Hindi');
  return res.send(songs);
  } catch (error) {
    throw error;
  }
}