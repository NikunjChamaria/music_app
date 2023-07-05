const route=require('express').Router();
const UserController=require("../controllers/user.controller");
const SongController=require('../controllers/song.controller');
const fs = require('fs');
const path = require('path');
const SongModel = require('../model/song.model');
const multer = require('multer');
const ArtistController=require('../controllers/artist.controller');
const ArtistModel = require('../model/artist.model');
const PlayListController=require('../controllers/playlist.controller');
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
      const extension = path.extname(file.originalname);
      cb(null, file.fieldname + '-' + uniqueSuffix + extension);
    }
  });
  
  const upload = multer({ storage });

route.post('/register',UserController.register);
route.post('/login',UserController.login);
route.post('/getSongs',SongController.getSongs);
route.post('/songs/:id',SongController.getSongData);
route.post('/song/:id',SongController.getSong);
route.post('/songs/weeklyPlays/:id',SongController.updateWeeklyPlays);
route.get('/top10week',SongController.getTop10inWeek);
route.get('/getTop100intotalforMain',SongController.getTop100intotalforMain);
route.get('/getTop100intotal',SongController.getTop100intotal);
route.get('/getTop10inEnglish',SongController.getTop10inEnglish);
route.get('/getTop10inHindi',SongController.getTop10inHindi);
route.get('/artist',ArtistController.getArtist);
route.post('/getplaylistbyname',PlayListController.getPlayList);
route.post('/history',UserController.updateHistory);
route.post('/gethistory',UserController.getHistory);

route.post('/songs', upload.fields([{ name: 'mp3File', maxCount: 1 }, { name: 'coverImage', maxCount: 1 }]), async (req, res) => {
    try {
      const { name, artist, genre, language } = req.body;
      const mp3FilePath = req.files['mp3File'][0].path;
      const coverImagePath = req.files['coverImage'][0].path;
  
      const mp3FileBuffer = fs.readFileSync(mp3FilePath);
      const coverImageBuffer = fs.readFileSync(coverImagePath);
  
      // Delete temporary files
      fs.unlinkSync(mp3FilePath);
      fs.unlinkSync(coverImagePath);
  
      const newSong = new SongModel({
        name,
        artist,
        genre,
        language,
        
        coverImage: {
          data: coverImageBuffer,
          contentType: req.files['coverImage'][0].mimetype
        },
        mp3File: {
            data: mp3FileBuffer,
            contentType: 'audio/mpeg'
          }
      });
  
      const savedSong = await newSong.save();
      const artistmodel=await ArtistModel.findOne({name: artist});
      
      if(artistmodel){
        artistmodel.songs.push(savedSong._id);
      await artistmodel.save();
      }
      res.status(201).json({"STATUS":true});
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to create song' });
    }
  });

  route.post('/artist', upload.single('artistImage'), async (req, res) => {
    try {
      const { name } = req.body;
      const artistImagePath = req.file.path;

      const artistImageBuffer=fs.readFileSync(artistImagePath);

      if (!artistImageBuffer) {
        return res.status(400).json({ error: 'No artist image uploaded' });
      }
  
      const songs = await SongModel.find({ artist: name }).exec();
      const artist = new ArtistModel({ name:name, artistImage: artistImageBuffer, songs: songs.map(song => song._id) });
      const savedArtist = await artist.save();
      fs.unlinkSync(artistImagePath);
  
      res.json(savedArtist);
    } catch (error) {
      console.error('Error creating artist:', error);
      res.status(500).json({ error: 'Server error' });
    }
  });
  

module.exports=route;
