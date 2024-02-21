 import dotenv from "dotenv";
import { connect } from "./config/database.config.js";
import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import logger from "morgan";
import { AuthRouter } from "./routes/auth.route.js";
import { TripRouter } from "./routes/trip.route.js";

//firebase packages for deploying yiy to firebase
import  admin from 'firebase-admin'
import * as functions from 'firebase-functions'

dotenv.config();
admin.initializeApp(functions.config().firebase);
connect();

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(
  cors()
);

app.use(cookieParser());
app.use(logger("dev"));

app.use("/api/auth", AuthRouter);
app.use("/api/trip", TripRouter);

app.all("/", (req, res) => {
  res.json({
    message: "Welcome to node starter code",
  });
});

app.all("*", (req, res) => {
  res.status(404).json({
    success: false,
    message: `Path does not exist`,
    data: {
      path: req.path,
      method: req.method,
      protocol: req.protocol,
    },
  });
});

app.listen(process.env.PORT_EXPRESS, () => {
  console.log(
    "---------------------------------------------------------------"
  );
  console.log(
    `          Server is listening on http://localhost:${process.env.PORT_EXPRESS}          `
  );
  console.log(
    "---------------------------------------------------------------"
  );
});

let  test_app = functions.https.onRequest(app);

export {test_app}