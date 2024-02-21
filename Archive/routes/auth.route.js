import Express from "express";
import { AuthController } from "../controller/auth.controller.js";
import { Middleware } from "../middleware/auth.middleware.js";
const AuthRouter = Express.Router();
const Controller = new AuthController();

AuthRouter.post("/signup/email-password", Controller.signupWithEmailPassword());
AuthRouter.patch("/user/update-detail",Middleware.isLoginCheck, Controller.updateDetails());
AuthRouter.post("/login/email-password", Controller.login());
export { AuthRouter };