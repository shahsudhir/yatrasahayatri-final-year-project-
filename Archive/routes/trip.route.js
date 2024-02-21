import Express from "express";
import { TripController } from "../controller/trip.controller.js";
import { Middleware } from "../middleware/auth.middleware.js";
const TripRouter = Express.Router();
const Controller = new TripController();

TripRouter.post("/add",Middleware.isLoginCheck, Controller.create);
TripRouter.get("/list",Middleware.isLoginCheck, Controller.list);
TripRouter.delete("/delete/:id",Middleware.isLoginCheck, Controller.remove);
TripRouter.patch("/update/:id",Middleware.isLoginCheck, Controller.update);
export { TripRouter };