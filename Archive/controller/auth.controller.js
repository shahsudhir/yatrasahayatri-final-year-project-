import { UserModel } from "../model/user.model.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import mongoose from "mongoose";

class AuthController {

  signupWithEmailPassword = () => {
    return async (req, res) => {
      try {
        console.log(req.body)
        if (!(req.body.email || req.body.password)) {
          res.status(300).json({
            success: false,
            message: "Please Enter Details in Required Fields",
          });
          return
        }
          const emailExist = await UserModel.findOne({ email: req.body.email });
          if (emailExist) {
            res.status(300).json({
              success: false,
              message: `${req.body.email} is already exist`,
            });
          } else {
            let userData = await (await UserModel({
              email: req.body.email,
              fullName: req.body.fullName,
              password: await bcrypt.hash(req.body.password, 10),
            }).save()).toObject();
            delete userData.password;
            console.log(userData)
            res.status(200).json({
              success: true,
              token: jwt.sign(userData, process.env.JWT_SECRET),
              data: userData,
            });
          }
        
      } catch (error) {
        res.status(400).json({
          success: false,
          message: "Something Went Wrong.",
          error: error.message,
        });
      }
    };
  };
  updateDetails = () => {
    return async (req, res) => {
      try {
          const emailExist = await UserModel.findOne({ email: req.body.email });
          if (emailExist) {
            res.status(300).json({
              success: false,
              message: `${req.body.email} is already exist`,
            });
          } else {
            let userData ={...req.body}
            if(userData.password){
              userData.password = await bcrypt.hash(req.body.password, 10)
            }
            await UserModel.findByIdAndUpdate(req.user._id, userData)
            res.status(200).json({
              success: true,
              message:"Details Updated Successfully",
            });
          }
        
      } catch (error) {
        res.status(400).json({
          success: false,
          message: "Something Went Wrong.",
          error: error.message,
        });
      }
    };
  };
  login = () => {
    return async (req, res) => {
      try {
        const { email, password } = req.body;

        if (!(email && password)) {
          res.status(300).json({
            success: false,
            message: "Enter your email address and password",
          });
        }

        let userResponse = await UserModel.findOne({ email });
        if (!userResponse) {
          return res.status(300).json({
            success: false,
            message: "Account is not found!!",
          });
        }

        const validPassword = await bcrypt.compare(
          req.body.password,
          userResponse.password
        );

        if (validPassword) {
          let user = userResponse.toJSON();
          delete user.password;
          res.status(200).json({
            success: true,
            message: "Login successful",
            token: jwt.sign(user, process.env.JWT_SECRET),
            data: user,
          });
        } else {
          res.status(401).json({
            success: false,
            message: "Wrong password",
          });
        }
      } catch (error) {
        res.status(404).json({
          success: false,
          message: "Something Went Wrong. Some Internal Server Error.",
          error: error,
        });
      }
    };
  };
}

export { AuthController };
