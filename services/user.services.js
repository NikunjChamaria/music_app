const UserModel=require('../model/user.model');
const jwt=require('jsonwebtoken');

class UserService{
    static async registerUser(email,password,name,phone){
        try{
            const createUser= new UserModel({email,password,name,phone});
            return await createUser.save();
        }catch(e){
            throw e;
        }
    }

    static async loginUser(email){
        try {
            //console.log(UserModel.findOne({email}));
            return await UserModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateToken(tokenData,secretKey,jwt_expire){
        return jwt.sign(tokenData,secretKey,{expiresIn:jwt_expire});
    }
}
module.exports=UserService;