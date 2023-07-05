const UserModel = require('../model/user.model');
const UserService=require('../services/user.services');

exports.register= async(req,res,next)=>{
    try{
        const {email,password,name,phone}=req.body;

        const success=await UserService.registerUser(email,password,name,phone);

        const user= await UserService.loginUser(email);
        let tokenData={_id:user._id,email:user.email,name:user.name,phone:user.phone};
        const token = await UserService.generateToken(tokenData,"123",'365d');

        res.status(200).json({status:true,token:token});
    }catch(e){
        throw e;
    }
}
exports.login= async(req,res,next)=>{
    try{
        const {email,password}=req.body;

        const user= await UserService.loginUser(email);

        if(!user){
            return res.status(200).json({ status: false });
        }

        const isMatch=await user.comparePassword(password);
        if(isMatch===false){
            return res.status(200).json({ status: false });
        }

        let tokenData={_id:user._id,email:user.email,name:user.name,phone:user.phone};

        const token = await UserService.generateToken(tokenData,"123",'365d');
        

        res.status(200).json({status:true,token:token});
    }catch(e){
        throw e;
    }
}

exports.updateHistory = async (req, res, next) => {
  try {
    const { email, isPlaylist, id } = req.body;
    const user = await UserModel.findOne({ email: email });
    
    const success=UserModel.updateMany({"recently.id":id},{$pull:{recently:{id:id}}});
    const newItem = {
      id: id,
      isPlaylist: isPlaylist,
    };
    user.recently.unshift(newItem);
    
    if (user.recently.length > 15) {
      user.recently.pop(); 
    }
    
    await user.save();
    res.status(200).json({ message: 'History updated successfully' });
  } catch (error) {
    next(error);
  }
};

  

  
  exports.getHistory=async(req,res,next)=>{
    try {
        const {email}=req.body;
        const user=await UserModel.findOne({email:email});
        res.send(user.recently);
    } catch (error) {
        throw error;
    }
  }